Object.extends('Platform', function(self)
    self.visible = false
    self.sprite = Sprites.sPlatform
    self.mask = Same
    self.persistent = false

    self.yspeed = 0
end)