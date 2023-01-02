Object.extends('SmoothCamera', function(self)
    self.visible = false
    self.sprite = None
    self.mask = Same
    self.persistent = false
    self.depth = 0

    local snapDiv = 4
    local init = false

    function self:onUpdate()
        local p = Objects.Player:first()
        if p then
            if not init then
                init = true
                self.x = self.x + (p.x - Game.cameraWidth / 2 - self.x)
                self.y = self.y + (p.y - Game.cameraWidth / 2 - self.y)
            else
                self.x = self.x + (p.x - Game.cameraWidth / 2 - self.x) / snapDiv
                self.y = self.y + (p.y - Game.cameraWidth / 2 - self.y) / snapDiv
            end
        end

        self.x = math.clamp(self.x, 0, Game.room.width - Game.cameraWidth)
        self.y = math.clamp(self.y, 0, Game.room.height - Game.cameraHeight)

        Game.cameraX = self.x
        Game.cameraY = self.y
    end
end)
