Object.extends('BlockFake', function(self)
    self.visible = true
    self.sprite = Sprites.sBlock
    self.mask = Same
    self.persistent = false
    
    function self:onAfterUpdate()
        if self:placeMeeting(Objects.Player) then
            Sounds.sndBlockChange:play()
            self:destroy()
        end
    end
end)