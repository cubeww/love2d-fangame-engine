Object.extends('PlayerStart', function(self)
    self.visible = false
    self.sprite = Sprites.sPlayerStart
    self.mask = Same
    self.persistent = false
    self.depth = -10

    function self:onEnterRoom()
        if not Objects.Player:first() then
            Objects.Player:new(self.x + 17, self.y + 23)
        end
    end
end)
