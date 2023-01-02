Object.extends('Bow', function(self)
    self.visible = true
    self.sprite = Sprites.sBow
    self.mask = Same
    self.persistent = true
    self.depth = -11

    function self:onDraw()
        local p = Objects.Player:first()
        if p then
            self.x = p.x
            self.y = p.y
            self.xscale = p.face

            if World.grav == 1 then
                self.yscale = 1
            else
                self.yscale = -1
                self.y = self.y + 1
            end

            self:drawSelf()
        else
            self:destroy()
        end
    end
end)
