Object.extends('KillerTrigger', 'PlayerKiller', function(self)
    self.visible = true
    self.sprite = None
    self.mask = Same
    self.persistent = false

    local triggered = false

    self.trg = 0
    self.h = 0
    self.v = 0

    self.dir = 0
    self.spd = 0

    function self:onUpdate()
        if not triggered and World.trigger[self.trg] then
            if self.v ~= 0 or self.h ~= 0 then
                self.vspeed = self.v
                self.hspeed = self.h
            elseif self.spd ~= 0 then
                self.direction = self.dir
                self.speed = self.spd
            end

            triggered = true
        end
    end
end)
