Object.extends('GameOver', function(self)
    self.visible = false
    self.sprite = Sprites.sGameOver
    self.mask = Same
    self.persistent = false
    self.depth = -100

    local timer = 0

    function self:onUpdate()
        if timer < 30 then
            timer = timer + 1
        else
            self.visible = true
        end

        self.x = Game.cameraX + Game.cameraWidth / 2
        self.y = Game.cameraY + Game.cameraHeight / 2
    end
end)
