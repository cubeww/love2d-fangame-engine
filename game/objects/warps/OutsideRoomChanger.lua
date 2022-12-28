Object.extends('OutsideRoomChanger', function(self)
    self.visible = true
    self.sprite = Sprites.sTriggerMask
    self.mask = Same
    self.persistent = false

    local onUpdate = self.onUpdate
    function self:onUpdate()
        Objects.Player:with(function(p)
            if p.x < 0 or p.x > Game.room.width or p.y < 0 or p.y > Game.room.height then
                onUpdate(self)
            end
        end)
    end
end)
