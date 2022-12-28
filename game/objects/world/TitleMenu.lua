Object.extends('TitleMenu', function(self)
    self.visible = false
    self.sprite = None
    self.mask = Same
    self.persistent = false

    function self:onUpdate()
        if Input:pressed('lshift') then
            Game:gotoRoom(Rooms.rMenu)
        end
    end
end)