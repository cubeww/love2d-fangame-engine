-- instance.lua
-- provide some basic extension methods for the instance.

function Instance.new(objectName, x, y)
    local obj = Objects[objectName]

    if obj then
        local inst = obj.new()
        inst.x = x or 0
        inst.y = y or 0

        -- append to instance pools
        inst._orderedInstancePoolNode = OrderedInstancePool:insertInstance(inst) -- 1

        local o = inst.objectTarget
        inst._instancePoolNode = o.instancePool:appendInstance(inst) -- 2
        inst._recursiveInstancePoolNode = {}
        while o do
            inst._recursiveInstancePoolNode[o] = o.recursiveInstancePool:appendInstance(inst) -- 3...
            o = Objects[o.parentName]
        end

        -- call onCreate method
        if inst.onCreate then
            inst:onCreate()
        end

        return inst
    end

    return nil
end

function Instance:updateFrameIndex()
    self.frameIndex = self.frameIndex + self.frameSpeed
end

function Instance:drawSelf()
    local spr = self.spriteTarget
    if spr then
        spr:draw(self.frameIndex, self.x, self.y, self.xscale, self.yscale, self.angle,
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
    OrderedInstancePool:removeNode(self._orderedInstancePoolNode) -- 1

    local o = self.objectTarget
    o.instancePool:removeNode(self._instancePoolNode) -- 2

    while o do
        o.recursiveInstancePool:removeNode(self._recursiveInstancePoolNode[o]) -- 3...
        o = Objects[o.parentName]
    end
end
