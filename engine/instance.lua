-- instance.lua
-- Provide some basic extension methods for the instance.

function Instance:next(func)
    func(self)
    return self
end

function Instance:updateFrameIndex()
    self.frameIndex = self.frameIndex + self.frameSpeed
end

function Instance:drawSelf()
    if self.sprite then
        self.sprite:draw(self.frameIndex, self.x, self.y, self.xscale, self.yscale, self.angle,
            { self.color[1] / 255, self.color[2] / 255, self.color[3] / 255, self.color.a })
    end
end

function Instance:destroy()
    if not self._shouldRemove then
        self._shouldRemove = true

        if self.onDestroy then
            self:onDestroy()
        end
    end
end

function Instance:removeFromPools()
    local o = self.object
    o.instancePool:remove(self)

    while o do
        o.recursiveInstancePool:remove(self)
        o = Objects[o.parentName]
    end
end
