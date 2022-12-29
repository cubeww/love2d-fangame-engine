Object.extends('Blood', function(self)
    self.visible = true
    self.sprite = Sprites.sBlood
    self.mask = Same
    self.persistent = false

    local xprevious
    local yprevious

    function self:onCreate()
        self.frameIndex = math.random(#self.sprite.frames - 1)
        self.frameSpeed = 0

        self.direction = math.random(35) * 10
        self.speed = math.random() * 6
        self.gravity = (0.1 + math.random() * 0.2) * World.grav
    end

    function self:onUpdate()
        xprevious = self.x
        yprevious = self.y

        if self.x < 0 or self.x > Game.room.width or self.y < 0 or self.y > Game.room.height then
            self:destroy()
            return
        end
    end

    local updatePosition = self.updatePosition
    function self:updatePosition()
        updatePosition(self)

        if self:placeMeeting(Objects.Block, self.x, self.y) then
            self.x = xprevious
            self.y = yprevious

            self:moveContact(Objects.Block, self.direction, self.speed)

            self.speed = 0
            self.gravity = 0

            self.x = self.x + self.hspeed
            self.y = self.y + self.vspeed
        end

    end
end)
