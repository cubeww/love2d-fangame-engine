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

function Instance:appendToPools()
    -- Append to ordered instance pool
    OrderedInstancePool:append(self)
    
    -- Append to object instance pool
    local o = self.object
    self._poolIndex = o.instancePool:append(self)

    -- Append to recursive instance pool
    self._recursivePoolIndexes = {}
    while o do
        table.insert(self._recursivePoolIndexes, o.recursiveInstancePool:append(self))
        o = Objects[o.parentName]
    end
end

function Instance:removeFromPools()
    -- Remove from object instance pool
    local o = self.object
    o.instancePool:remove(self._poolIndex)

    -- Remove from recursive instance pool
    for _, index in ipairs(self._recursivePoolIndexes) do
        o.recursiveInstancePool:remove(index)
    end
end
