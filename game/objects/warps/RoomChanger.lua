Object.extends('RoomChanger', function(self)
    self.visible = true
    self.sprite = Sprites.sTriggerMask
    self.mask = Same
    self.persistent = false

    self.warpX = false
    self.warpY = false
    self.roomTo = World.startRoom

    function self:onUpdate()
        if self:placeMeeting(Objects.Player) then
            if self.warpX ~= false and self.warpY ~= false then
                Objects.Player:with(function(p)
                    p:destroy()
                end)
            else
                Objects.Player:with(function(p)
                    p.x = self.warpX
                    p.y = self.warpY
                end)
            end

            Game:gotoRoom(self.roomTo)
        end
    end
end)
