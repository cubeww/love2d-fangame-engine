-- instancepool.lua

-- ******************** Ordered Instance Pool ********************
-- global instance pool. mainly used for executing instance callback functions,
-- such as onUpdate, onDraw, etc.


OrderedInstancePool = {
    pool = {},
    sortPool = {}
}
-- use binary search algorithm to quickly insert instance into the correct depth index
function OrderedInstancePool:insert(inst)
    local left = 1
    local right = #self.pool
    while left <= right do
        local mid = math.floor((left + right) / 2)
        if self.pool[mid].depth > inst.depth then
            left = mid + 1
        else
            right = mid - 1
        end
    end

    table.insert(self.pool, left, inst)
end

-- generally called at the end of a game frame
function OrderedInstancePool:clearRemoved()
    for i = #self.pool, 1, -1 do
        local inst = self.pool[i]
        if inst._shouldRemove then
            inst:removeFromPools()
            table.remove(self.pool, i)
        end
    end
end

-- generally called when switching rooms
function OrderedInstancePool:destroyAndRemoveAll()
    for i = #self.pool, 1, -1 do
        local inst = self.pool[i]
        if not inst.persistent then
            inst:destroy()
            inst:removeFromPools()
            table.remove(self.pool, i)
        end
    end
end

-- only remove the instance from this instance pool without performing any other things
function OrderedInstancePool:remove(inst)
    for i, v in ipairs(inst) do
        if inst == v then
            table.remove(self.pool, i)
        end
    end
end

-- called when the instance depth value changes
function OrderedInstancePool:pushSort(inst)
    table.insert(self.sortPool, inst)
end

-- called before drawing
function OrderedInstancePool:sortDepth()
    local inst = table.remove(self.sortPool)
    while inst do
        self:remove(inst)
        self:insert(inst)
        inst = table.remove(self.sortPool)
    end
end

function OrderedInstancePool:update()
    for _, inst in ipairs(self.pool) do
        if not inst._shouldRemove then
            if inst.onUpdate then
                inst:onUpdate()
            end

            inst:updatePosition()
            inst:updateFrameIndex()
        end
    end
end

function OrderedInstancePool:draw()
    self:sortDepth()

    -- local tiles = Game.roomTarget.orderedTiles

    for _, inst in ipairs(self.pool) do
        if not inst._shouldRemove then
            if inst.onDraw then
                inst:onDraw()
            else
                inst:drawSelf()
            end
        end
    end
end

-- ******************** Instance Pool ********************
-- instance pool held by each object.
-- mainly used for collision detection and traversing instances of a certain type of object.

InstancePool = {
    pool = {},
    stack = {}
}

function InstancePool:append(inst)
    local i = table.remove(self.stack)
    if i then
        self.pool[i] = inst
    else
        table.insert(self.pool, inst)
    end
end

function InstancePool:findIndex(inst)
    for i, v in ipairs(inst) do
        if inst == v then
            return i
        end
    end
    return nil
end

function InstancePool:remove(inst)
    local index = self:findIndex(inst)
    if index then
        table.insert(self.stack, index)
    end
end

function InstancePool.new()
    local self = {}
    setmetatable(self, { __index = InstancePool })
    return self
end
