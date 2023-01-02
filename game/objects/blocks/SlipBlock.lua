Object.extends('SlipBlock', 'Block', function(self)
    self.visible = false
    self.sprite = Sprites.sBlock
    self.mask = Same
    self.persistent = false
    self.depth = 100

    self.slip = 0.2
end)