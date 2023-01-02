Object.extends('Save', function(self)
    self.visible = true
    self.sprite = Sprites.sSave
    self.mask = Sprites.sBlock
    self.persistent = false
    self.depth = 1
    self.frameSpeed = 0

    local timer = 0
    local canSave = true

    self.dif = 1
    self.grav = 1

    function self:onCreate()
        if World.difficulty > self.dif then
            self:destroy()
        end
    end

    function self:onAfterUpdate()
        if timer > 0 then
            timer = timer - 1
        else
            canSave = true
        end

        if self.frameIndex >= 2 then
            self.frameSpeed = 0
            self.frameIndex = 0
        end

        local player = Objects.Player:first()
        if self.grav == World.grav and canSave and player then
            local playerTouch = self:placeMeeting(Objects.Player)
            local bulletTouch = self:placeMeeting(Objects.Bullet)
            local pressShoot = Input:pressed('z')
            if bulletTouch or (playerTouch and pressShoot) then
                if player.x >= 0 and player.x <= Game.room.width and player.y >= 0 and player.y <= Game.room.height then
                    canSave = false
                    timer = 30
                    self.frameIndex = 1
                    self.frameSpeed = 0.017
                    World:saveGame(true)
                end
            end
        end
    end
end)
