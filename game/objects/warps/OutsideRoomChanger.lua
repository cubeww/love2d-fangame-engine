Object.extends('OutsideRoomChanger', 'RoomChanger', function(self)
    self.visible = true
    self.sprite = Sprites.sTriggerMask
    self.mask = Same
    self.persistent = false
    self.depth = 10

    local onAfterUpdate = self.onAfterUpdate
    function self:onAfterUpdate()
        Objects.Player:with(function(p)
            local xx = p.x + p.hspeed
            local yy = p.y + p.vspeed
            if xx < 0 or xx > Game.room.width or yy < 0 or yy > Game.room.height then
                onAfterUpdate(self)
            end
        end)
    end
end)
