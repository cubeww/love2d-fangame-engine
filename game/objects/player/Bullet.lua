Object.extends('Bullet', function(self)
    self.visible = true
    self.sprite = Sprites.sBullet
    self.mask = Same
    self.persistent = false

    local timer = 0

    function self:onUpdate()
        timer = timer + 1

        if timer == 40 then
            self:destroy()
            return
        end

        if self:placeMeeting(Objects.Block, self.x + self.hspeed, self.y + self.vspeed) then
            self:destroy()
            return
        end

        if self:placeMeeting(Objects.SaveBlocker) then
            self:destroy()
            return
        end
    end
end)
