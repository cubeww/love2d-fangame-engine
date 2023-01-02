Object.extends('Bullet', function(self)
    self.visible = true
    self.sprite = Sprites.sBullet
    self.mask = Same
    self.persistent = false
    self.depth = -1

    local timer = 0

    function self:onAfterUpdate()
        timer = timer + 1

        if timer == 40 then
            self:destroy()
            return
        end

        if self:placeMeeting(Objects.Block) then
            self:destroy()
            return
        end

        if self:placeMeeting(Objects.SaveBlocker) then
            self:destroy()
            return
        end
    end
end)
