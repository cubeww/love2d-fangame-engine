Object.extends('BlockInvis', 'Block', function(self)
    self.visible = false
    self.sprite = Sprites.sBlock
    self.mask = Same
    self.persistent = false

    function self:onUpdate()
        if self:placeMeeting(Objects.Player) then
            Sounds.sndBlockChange:play()
            self.visible = true
        end
    end
end)
