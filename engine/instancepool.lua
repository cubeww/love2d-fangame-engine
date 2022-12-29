-- instancepool.lua

-- ******************** Ordered Instance Pool ********************
-- Global instance pool. Mainly used for executing instance callback functions,
-- such as onUpdate, onDraw, etc.


OrderedInstancePool = {
    pool = {},
    sortPool = {}
}
-- Use binary search algorithm to quickly insert instance into the correct depth index
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

-- Generally called at the end of a game frame
function OrderedInstancePool:clearRemoved()
    for i = #self.pool, 1, -1 do
        local inst = self.pool[i]
        if inst._shouldRemove then
            inst:removeFromPools()
            table.remove(self.pool, i)
        end
    end
end

-- Generally called when switching rooms
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

-- Only remove the instance from this instance pool without performing any other things
function OrderedInstancePool:remove(inst)
    for i, v in ipairs(inst) do
        if inst == v then
            table.remove(self.pool, i)
        end
    end
end

-- Called when the instance depth value changes
function OrderedInstancePool:pushSort(inst)
    table.insert(self.sortPool, inst)
end

-- Called before drawing
function OrderedInstancePool:sortDepth()
    -- Pop item from sort pool
    local inst = table.remove(self.sortPool)
    while inst do
        self:remove(inst)
        self:insert(inst)

        inst._shouldSort = false

        inst = table.remove(self.sortPool)
    end
end

-- The pool iterator will skip over all instances that have been 'removed'
function OrderedInstancePool:iter()
    local i = 0
    local pool = self.pool
    return function()
        while i < #pool do
            i = i + 1
            if not pool[i]._shouldRemove then
                return pool[i]
            end
        end
        return nil
    end
end

-- ******************** Instance Pool ********************
-- Instance pool held by each object.
-- Mainly used for collision detection and traversing instances of a certain type of object.

InstancePool = {}

function InstancePool.new()
    local self = {}

    setmetatable(self, { __index = InstancePool })
    self.pool = {}
    self.stack = {}

    return self
end

function InstancePool:append(inst)
    local i = table.remove(self.stack)
    if i ~= nil then
        self.pool[i] = inst
    else
        table.insert(self.pool, inst)
    end
    return i or #self.pool
end

function InstancePool:remove(index)
    table.insert(self.stack, index)
end

InstancePool.iter = OrderedInstancePool.iter

----------------------------------------------------------------

SpatialHash = {
    cells = {},
    cellSize = 32,
    shouldUpdateHash = {},
}

function SpatialHash:update()
    for inst, _ in pairs(self.shouldUpdateHash) do
        self:remove(inst)
        self:insert(inst)
        SpatialHash.shouldUpdateHash[inst] = nil
    end
end

function SpatialHash:insert(inst)
    inst:computeBoundingBox()

    if not inst.bbox.left then
        return
    end

    local x1 = math.floor(inst.bbox.left / self.cellSize)
    local y1 = math.floor(inst.bbox.top / self.cellSize)
    local x2 = math.floor(inst.bbox.right / self.cellSize)
    local y2 = math.floor(inst.bbox.bottom / self.cellSize)

    inst.insertedCells = {}

    for xx = x1, x2, 1 do
        for yy = y1, y2, 1 do
            local pos = xx .. ',' .. yy
            if not self.cells[pos] then
                self.cells[pos] = {}
            end

            self.cells[pos][inst] = true --插入实例到网格中
            table.insert(inst.insertedCells, pos)
        end
    end
end

function SpatialHash:remove(inst)
    if inst.insertedCells then
        for _, i in ipairs(inst.insertedCells) do
            self.cells[i][inst] = nil
        end
    end
end

function SpatialHash:with(inst, object, func)
    inst:computeBoundingBox()

    local x1 = math.floor(inst.bbox.left / self.cellSize)
    local y1 = math.floor(inst.bbox.top / self.cellSize)
    local x2 = math.floor(inst.bbox.right / self.cellSize)
    local y2 = math.floor(inst.bbox.bottom / self.cellSize)

    for xx = x1, x2, 1 do
        for yy = y1, y2, 1 do
            local pos = xx .. ',' .. yy
            if self.cells[pos] then
                for inst1, _ in pairs(self.cells[pos]) do
                    if inst1.object == object then
                        func(inst1)
                    end
                end
            end
        end
    end
end
