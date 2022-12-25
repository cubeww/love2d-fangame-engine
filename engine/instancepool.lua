-- instancepool.lua
-- doubly linked list implementation of instance pool.

local InstPoolNode = {}
InstPoolNode.__index = InstPoolNode

function InstPoolNode:new(inst)
    local node = { inst = inst, prev = nil, next = nil }
    setmetatable(node, InstPoolNode)
    return node
end

InstPool = {}
InstPool.__index = InstPool

function InstPool:new()
    local pool = { head = nil, tail = nil }
    setmetatable(pool, InstPool)
    return pool
end

function InstPool:appendInst(inst)
    local node = InstPoolNode:new(inst)
    if self.tail then
        self.tail.next = node
        node.prev = self.tail
        self.tail = node
    else
        self.head = node
        self.tail = node
    end
end

function InstPool:prependInst(inst)
    local node = InstPoolNode:new(inst)
    if self.head then
        self.head.prev = node
        node.next = self.head
        self.head = node
    else
        self.head = node
        self.tail = node
    end
end

function InstPool:removeNode(node)
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

function InstPool:traverseInst(callback)
    local node = self.head
    while node do
        callback(node.inst)
        node = node.next
    end
end

function InstPool:sortDepth()
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

function InstPool:findNode(inst)
    local node = self.head
    while node do
        if node.inst == inst then
            return node
        end
        node = node.next
    end
    return nil
end

-- use this method if the instance pool requires depth sorting
function InstPool:insertInst(inst)
    local newNode = InstPoolNode:new(inst)
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
        self:appendInst(inst)
    end
end

function InstPool:clearRemoved()
    local node = self.head
    while node do
        local next = node.next
        if node.inst._shouldRemove then
            self:removeNode(node)
        end
        node = next
    end
end

function InstPool:clearAll()
    local node = self.head
    while node do
        local next = node.next
        node.prev = nil
        node.next = nil
        node.inst = nil
        node = next
    end
    self.head = nil
    self.tail = nil
end