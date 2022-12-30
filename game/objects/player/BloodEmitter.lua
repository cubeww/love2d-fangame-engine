Object.extends('BloodEmitter', function(self)
    self.visible = true
    self.sprite = None
    self.mask = Same
    self.persistent = false

    local timer = 0

    function self:onUpdate()
        timer = timer + 1

        for _ = 1, 20, 1 do
            Objects.Blood:new(self.x, self.y)
        end

        if timer == 20 then
            self:destroy()
        end
    end
end)
