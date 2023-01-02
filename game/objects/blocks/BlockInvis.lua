Object.extends('BlockInvis', 'Block', function(self)
    self.visible = false
    self.sprite = Sprites.sBlock
    self.mask = Same
    self.persistent = false

    function self:onUpdate()
        local dist = self:distanceTo(Objects.Player)

        if not self.visible and dist <= 1 then
            Sounds.sndBlockChange:play()
            self.visible = true
        end
    end
end)
