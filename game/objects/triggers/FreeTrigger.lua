Object.extends('FreeTrigger', function(self)
    self.visible = false
    self.sprite = Sprites.sTriggerMask
    self.mask = Same
    self.persistent = false

    self.trg = 0

    function self:onEnterRoom()
        World.trigger[self.trg] = false
    end

    function self:onAfterUpdate()
        if self:placeMeeting(Objects.Player) then
            World.trigger[self.trg] = true
        end
    end
end)
