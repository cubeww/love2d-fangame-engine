Object.extends('World', function(self)
    -- Set as a global singleton for easy control
    World = self

    self.visible = false
    self.depth = 10001
    self.sprite = None
    self.persistent = true

    function self:initialize()
        self.gameStarted = false

        self.saveNum = 0

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

        love.window.setTitle('I wanna play in Love2D!!!')
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
        end

        Objects.Player:with(function(p)
            p:destroy()
        end)

        self.gameStarted = true
        self.autosave = false

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

        -- Sounds.musGuyRock:play()

        Game:gotoRoom(Rooms.rTitle)
    end

    function self:restart()
        self:saveGame(false)
        self:loadGame(false)
    end

    function self:onUpdate()
        -- Game check
        if self.gameStarted then
            if Input:pressed('r') then
                self:restart()
            end
        end

        -- Function keys
        if Input:pressed('escape') then
            love.event.quit()
        end
        if Input:pressed('p') then
            love.window.showMessageBox('Pause', 'Game is paused.')
        end
    end

    function self:onDraw()
        self:drawSelf()
    end

    function self:onEnterRoom()

    end
end)
