Object.extends('World', function(self)
    -- Set as a global singleton for easy control
    World = self

    self.visible = false
    self.depth = 10001
    self.sprite = None
    self.persistent = true

    function self:initialize()
        self.grav = 1
        self.gameStarted = false
        self.death = 0
        self.time = 0
        self.saveNum = 0
        self.trigger = {}

        love.window.setTitle('I wanna play in Love2D!!!')
        self.startRoom = Rooms.rStage01
    end

    function self:onCreate()
        self:initialize()

        Sounds.musGuyRock:play()

        Game:gotoRoom(Rooms.rTitle)
    end

    function self:onUpdate()
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
