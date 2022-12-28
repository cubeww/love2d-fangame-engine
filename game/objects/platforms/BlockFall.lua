Object.extends('BlockFall', 'MovingPlatform', function(self)
    self.visible = true
    self.sprite = Sprites.sBlock
    self.mask = Same
    self.persistent = false

    local onUpdate = self.onUpdate
    function self:onUpdate()
        local p = Objects.Player:first()
        if self.vspeed == 0 and p then
            if self:placeMeeting(Objects.Player, self.x, self.y - p.vspeed - World.grav) then
                self.vspeed = 2
            end
        end

        onUpdate(self)
    end
end)
