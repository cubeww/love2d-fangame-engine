Object.extends('BossBlock', 'Block', function(self)
    self.visible = true
    self.sprite = Sprites.sBossBlock
    self.mask = Same
    self.persistent = false
    self.depth = 101

    self.itemNum = 0

    function self:onUpdate()
        if World.bossItem[self.itemNum] then
            self:destroy()
        end
    end
end)
