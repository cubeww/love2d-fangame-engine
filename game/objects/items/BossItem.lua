Object.extends('BossItem', function(self)
    self.visible = true
    self.sprite = Sprites.sBossItem
    self.mask = Same
    self.persistent = false
    self.depth = 0

    self.itemNum = 0

    function self:onUpdate()
        if self:placeMeeting(Objects.Player) then
            World.bossItem[self.itemNum] = true
            Sounds.sndBlockChange:play()
            self:destroy()
        end
    end
end)