-- instancepool.lua
-- doubly linked list implementation of instance pool.

local InstancePoolNode = {}
InstancePoolNode.__index = InstancePoolNode

function InstancePoolNode.new(inst)
    local self = { inst = inst, prev = nil, next = nil }
    setmetatable(self, InstancePoolNode)
    return self
end

InstancePool = {}
InstancePool.__index = InstancePool

function InstancePool.new()
    local self = { head = nil, tail = nil }
    setmetatable(self, InstancePool)
    return self
end

function InstancePool:appendInstance(inst)
    local node = InstancePoolNode.new(inst)
    if self.tail then
        self.tail.next = node
        node.prev = self.tail
        self.tail = node
    else
        self.head = node
        self.tail = node
    end
    return node
end

function InstancePool:prependInstance(inst)
    local node = InstancePoolNode.new(inst)
    if self.head then
        self.head.prev = node
        node.next = self.head
        self.head = node
    else
        self.head = node
        self.tail = node
    end
    return node
end

-- NB: this method only removes the instance from the current instance pool, no other actions are performed
function InstancePool:removeNode(node)
    if node.prev then
        node.prev.next = node.next
    else
        self.head = node.next
    end
    if node.next then
        node.next.prev = node.prev
    else
        self.tail = node.prev
    end
end

function InstancePool:traverseInstance(callback)
    local node = self.head
    while node do
        callback(node.inst)
        node = node.next
    end
end

function InstancePool:findNode(inst)
    local node = self.head
    while node do
        if node.inst == inst then
            return node
        end
        node = node.next
    end
    return nil
end

-- ******************** Ordered Instance Pool ********************
-- the most important instance pool, the instance's onUpdate, onDraw, etc. methods are all called by it.


OrderedInstancePool = InstancePool.new()
OrderedInstancePool.shouldSortDepth = false

function OrderedInstancePool:insertInstance(inst)
    local newNode = InstancePoolNode.new(inst)
    local current = self.head
    while current and current.inst.depth > inst.depth do
        current = current.next
    end
    if current then
        newNode.prev = current.prev
        newNode.next = current
        if current.prev then
            current.prev.next = newNode
        else
            self.head = newNode
        end
        current.prev = newNode
    else
        return self:appendInstance(inst)
    end
end

function OrderedInstancePool:sortDepth()
    local current = self.head
    while current do
        local next = current.next
        while next do
            if current.inst.depth < next.inst.depth then
                current.inst.depth, next.inst.depth = next.inst.depth, current.inst.depth
            end
            next = next.next
        end
        current = current.next
    end
end

function OrderedInstancePool:update()
    self:traverseInstance(function(inst)
        if not inst._shouldRemove then
            if inst.onUpdate then
                inst:onUpdate()
            end

            inst:updatePosition()
            inst:updateFrameIndex()
        end
    end)
end

function OrderedInstancePool:draw()
    if self.shouldSortDepth then
        self:sortDepth()
    end

    local tiles = Game.roomTarget.orderedTiles
    

    self:traverseInstance(function(inst)
        if not inst._shouldRemove then
            if inst.onDraw then
                inst:onDraw()
            else
                inst:drawSelf()
            end
        end
    end)
end

function OrderedInstancePool:destroyAndRemoveAll()
    self:traverseInstance(function(inst)
        if not inst.persistent then
            inst:destroy()
            inst:removeFromPools() -- defined in instance.lua
        end
    end)
end

function OrderedInstancePool:clearRemoved()
    local node = self.head
    while node do
        local next = node.next
        if node.inst._shouldRemove then
            node.inst:removeFromPools()
        end
        node = next
    end
end
