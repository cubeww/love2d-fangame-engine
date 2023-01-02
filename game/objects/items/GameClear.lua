Object.extends('GameClear', function(self)
    self.visible = false
    self.sprite = Sprites.sTriggerMask
    self.mask = Same
    self.persistent = false
    self.depth = 0

    function self:onUpdate()
        if not World.gameClear and self:placeMeeting(Objects.Player) then
            World.gameClear = true
            World:saveGame(true)
        end
    end

end)
