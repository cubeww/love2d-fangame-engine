Object.extends('SlideBlock', 'Block', function(self)
    self.visible = true
    self.sprite = Sprites.sSlideBlock
    self.mask = Same
    self.persistent = false
    self.depth = 100

    self.h = 0
end)