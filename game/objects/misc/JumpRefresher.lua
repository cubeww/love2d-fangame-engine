Object.extends('JumpRefresher', function(self)
    self.visible = true
    self.sprite = Sprites.sJumpRefresher
    self.mask = Same
    self.persistent = false
    self.depth = 0

    self.refreshTime = 100

    local timer = -1

    function self:take()
        if self.visible then
            timer = self.refreshTime

            self.visible = false
        end
    end

    function self:onUpdate()
        self.yscale = World.grav

        if timer > 0 then
            timer = timer - 1
        elseif timer == 0 then
            timer = -1
            self.visible = true
        end
    end
end)
