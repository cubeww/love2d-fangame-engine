Object.extends('Block', function(self)
    self.visible = false
    self.sprite = Sprites.sBlockMask
    self.mask = Same
    self.persistent = false
    self.depth = 100
end)