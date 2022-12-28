Object.extends('MovingPlatform', 'Platform', function(self)
    self.visible = true
    self.sprite = Sprites.sMovingPlatform
    self.mask = Same
    self.persistent = false

    self.bounce = true

    function self:onUpdate()
        if self.speed ~= 0 or self.yspeed ~= 0 then -- make sure the platform is moving before doing collision checks
            if self.bounce then
                if self:placeMeeting(Objects.Block, self.x + self.hspeed, self.y) then
                    self.hspeed = -self.hspeed
                end

                if self:placeMeeting(Objects.Block, self.x, self.y + self.vspeed + self.yspeed) then
                    if self.vspeed ~= 0 then
                        self.yspeed = -self.vspeed
                        self.vspeed = 0
                    else
                        self.vspeed = -self.yspeed
                        self.yspeed = 0
                    end
                end
            end

            local p = self:placeMeeting(Objects.Player, self.x, self.y - 2 * World.grav)
            if p then
                p.y = p.y + self.vspeed + self.yspeed
                if not p:placeMeeting(Objects.Block, p.x + self.hspeed, p.y) then
                    p.x = p.x + self.hspeed
                end
            end

            self.y = self.y + self.yspeed

            if self.vspeed < 0 then
                self.yspeed = self.vspeed
                self.vspeed = 0
            end
            if self.yspeed > 0 then
                self.vspeed = self.yspeed
                self.yspeed = 0
            end
        end
    end
end)
