Object.extends('Camera', function(self)
    self.visible = false
    self.sprite = None
    self.mask = Same
    self.persistent = false

    function self:onUpdate()
        Objects.Player:with(function(p)
            local xFollow, yFollow
            xFollow = math.clamp(p.x, 0, Game.room.width - 1)
            yFollow = math.clamp(p.y, 0, Game.room.height - 1)

            Game.cameraX = math.floor(xFollow / Game.cameraWidth) * Game.cameraWidth
            Game.cameraY = math.floor(yFollow / Game.cameraHeight) * Game.cameraHeight
        end)
    end
end)
