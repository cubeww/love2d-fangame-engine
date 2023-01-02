Object.extends('World', function(self)
    -- Set as a global singleton for easy control
    World = self

    self.visible = false
    self.depth = 10001
    self.sprite = None
    self.persistent = true
    self.death = -1000000

    self.bossRooms = {
        Rooms.rMiku,
    }

    self.roomMusic = {
        [Sounds.musGuyRock] = {
            Rooms.rInit,
            Rooms.rTitle,
            Rooms.rMenu,
            Rooms.rDifficultySelect,
            Rooms.rStage01,
            Rooms.rStage02,
        },
    }

    self.isBossRoom = false

    function self:initialize()
        self.gameStarted = false

        self.saveNum = 1

        self.grav = 1
        self.death = 0
        self.time = 0
        self.secretItem = {}
        self.bossItem = {}
        self.difficulty = 0
        self.gameClear = false

        self.autosave = false

        self.saveData = {}

        self.trigger = {}

        self.currentMusic = nil
        self.currentMusicSource = nil

        -- Game settings
        self.quickStart = false
        self.quickStartRoom = Rooms.rMiku

        self.gameTitle = 'I wanna play in Love2D!!!'
        self.startRoom = Rooms.rStage01
    end

    function self:saveGame(savePosition)
        local data = self.saveData

        if savePosition then
            Objects.Player:with(function(p)
                data.roomName = Game.room.name
                data.playerX = p.x
                data.playerY = p.y
                data.grav = self.grav

                if p:placeMeeting(Objects.Block, math.floor(data.playerX), data.playerY) then
                    data.playerX = data.playerX + 1
                end

                if p:placeMeeting(Objects.Block, data.playerX, math.floor(data.playerY)) then
                    data.playerY = data.playerY + 1
                end

                if p:placeMeeting(Objects.Block, math.floor(data.playerX), math.floor(data.playerY)) then
                    data.playerX = data.playerX + 1
                    data.playerY = data.playerY + 1
                end

                data.playerX = math.floor(data.playerX)
                data.playerY = math.floor(data.playerY)

                data.gameClear = self.gameClear
            end)
        end

        data.death = self.death
        data.time = self.time
        data.difficulty = self.difficulty

        data.secretItem = {}
        data.bossItem = {}

        for key, value in pairs(self.secretItem) do
            data.secretItem[key] = value
        end

        for key, value in pairs(self.bossItem) do
            data.bossItem[key] = value
        end

        -- Save to file
        love.filesystem.write('saveData' .. self.saveNum, json.encode(data))
    end

    function self:loadGame(loadFile)
        if loadFile then
            self.saveData = json.decode(love.filesystem.read('saveData' .. self.saveNum))

            self.difficulty = self.saveData.difficulty
            self.death = self.saveData.death
            self.time = self.saveData.time
            self.gameClear = self.saveData.gameClear
        end

        Objects.Player:with(function(p)
            p:destroy()
        end)

        self.gameStarted = true
        self.autosave = false

        self.grav = self.saveData.grav

        for key, value in pairs(self.saveData.secretItem) do
            self.secretItem[key] = value
        end

        for key, value in pairs(self.saveData.bossItem) do
            self.bossItem[key] = value
        end

        self.gameClear = self.saveData.gameClear

        Objects.Player:new(self.saveData.playerX, self.saveData.playerY)
        Game:gotoRoom(Rooms[self.saveData.roomName])
    end

    function self:onCreate()

        self:initialize()

        if self.quickStart then
            self.gameStarted = true
            self.autosave = true
            self.difficulty = 0

            Game:gotoRoom(self.quickStartRoom)
        else
            Game:gotoRoom(Rooms.rTitle)
        end
    end

    function self:restart()
        self:saveGame(false)
        self:loadGame(false)
    end

    function self:updateTitle()
        local title = self.gameTitle

        if self.gameStarted then
            local t = self.time
            local hours = math.floor(t / 180000)
            local minutes = math.floor(t / 3000) % 60
            local seconds = math.floor(t / 50) % 60
            local timeStr = hours ..
                ':' ..
                (minutes < 10 and '0' .. minutes or minutes) .. ':' .. (seconds < 10 and '0' .. seconds or seconds
                )

            title = title .. ' ~ Deaths: ' .. self.death .. ' Time: ' .. timeStr
        end

        if self.lastTitle ~= title then
            love.window.setTitle(title)
            self.lastTitle = title
        end
    end

    function self:restartGame()
        for inst in OrderedInstancePool:iter() do
            inst:destroy()
        end

        love.audio.stop()

        Game:gotoRoom(Rooms.rInit)
    end

    function self:onUpdate()
        -- Game check
        if self.gameStarted then
            self.time = self.time + 1

            if Input:pressed('p') and not self.isBossRoom then
                love.window.showMessageBox('Pause', 'Game is paused.')
            end

            if Input:pressed('r') then
                self:restart()
            end
        end

        -- Update window title
        self:updateTitle()

        -- Function keys
        if Input:pressed('f2') then
            self:restartGame()
        end

        if Input:pressed('f4') then
            Game:toggleFullscreen()
        end

        if Input:pressed('escape') then
            love.event.quit()
        end
    end

    function self:onDraw()
        self:drawSelf()
    end

    function self:stopMusic()
        if self.currentMusic then
            self.currentMusicSource:stop()
        end

        self.currentMusic = nil
        self.currentMusicSource = nil
    end

    function self:playMusic(music, loop)
        if self.currentMusic then
            self.currentMusicSource:stop()
        end

        self.currentMusic = music
        self.currentMusicSource = music:play(loop)

        return self.currentMusicSource
    end

    function self:onEnterRoom()
        -- Boss room check
        for _, room in ipairs(self.bossRooms) do
            if Game.room == room then
                self.isBossRoom = true
            end
        end

        -- Play room music
        local hasMusic = false
        for music, rooms in pairs(self.roomMusic) do
            for _, room in ipairs(rooms) do
                if Game.room == room then
                    hasMusic = true
                    if self.currentMusic ~= music then
                        self:playMusic(music, true)
                    end
                    goto endmusic
                end
            end
        end
        ::endmusic::
        if not hasMusic then
            if not self.isBossRoom then
                self:stopMusic()
            end
        end
    end
end)
