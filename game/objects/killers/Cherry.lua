Object.extends('Cherry', 'PlayerKiller', function(self)
    self.visible = true
    self.sprite = Sprites.sCherry
    self.mask = Same
    self.persistent = false

    self.frameSpeed = 1 / 15
end)
