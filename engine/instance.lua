-- instance = object metatable (visible, sprite, create()...) - object specific methods (extends, props...)
--  + instance properties (speed, direction...) + instance methods (placeMeeting...)
Inst = {}

-- speed getter & setter
local function speedGetter(t, k)
    if k == 'h' then
        return t._h or 0
    elseif k == 'v' then
        return t._v or 0
    elseif k == 'len' then
        return t._len or 0
    elseif k == 'dir' then
        return t._dir or 0
    end
end

local function speedSetter(t, k, v)
    if k == 'h' then
        t._h = v
    elseif k == 'v' then
        t._v = v
    elseif k == 'len' then
        t._len = v
    elseif k == 'dir' then
        t._dir = v
    end
end

-- create an new instance of object
function Inst:new(objectName, x, y)
    local obj = Objects[objectName]
    local inst = setmetatable({}, { __index = obj })

    inst.object = {
        name = objectName,
        target = obj,
    }

    -- instance properties

    -- transform
    inst.x = x or 0
    inst.y = y or 0

    inst.scale = {
        x = 1,
        y = 1,
    }

    inst.angle = 0

    inst.sprite = {
        name = obj.spriteName, -- eq: sprite_index
        index = 0, -- eq: image_index
        speed = 1, -- eq: image_speed
    }

    inst.mask = {
        name = obj.maskName, -- eq: mask_index
    }

    -- color
    inst.color = {
        r = 255,
        g = 255,
        b = 255, -- eq: image_blend

        a = 1, -- eq: image_alpha
    }

    -- movement
    inst.speed = setmetatable({}, {
        __index = speedGetter,
        __newindex = speedSetter,
    })

    inst.gravity = {
        len = 0, -- eq: gravity
        dir = 0, -- eq: gravity_direction
    }

    -- bounding box
    inst.bbox = {
        left = nil,
        right = nil,
        top = nil,
        bottom = nil,
    }

    inst.removed = false

    -- since object has some properties that instance does not have,
    -- we need to remove them when instantiating.
    inst.extends = nil
    inst.props = nil
    inst.spriteName = nil
    inst.objectName = nil
    inst.addlPool = nil

    -- also, add instance methods to instance
    for k, v in pairs(Inst) do
        inst[k] = v
    end

    -- calling the new method on an instance doesn't seem appropriate...
    inst.new = nil

    -- insert to instance pool
    table.insert(InstPool.pool, inst)

    -- insert to additional pool for collision detection
    table.insert(obj.addlPool, inst)

    -- execute create method
    if inst.create then
        inst:create()
    end

    return inst
end

-- mark the instance as "removed"
function Inst:destroy()
    self.removed = true
end

function Inst:handleMovement()

end

-- draw the current sprite with the current transform
function Inst:drawSelf()
    local spr = self:getCurrentSprite()
    if spr ~= None then
        spr:draw(self.sprite.index, self.x, self.y, self.xscale, self.yscale, self.angle,
            { self.color.r / 255, self.color.g / 255, self.color.b / 255, self.color.a })
    end
end

function Inst:updateImageIndex()
    self.sprite.index = self.sprite.index + self.sprite.speed
end

function Inst:getCurrentSprite()
    return Sprites[self.sprite.name]
end

function Inst:getCurrentMask()
    if self.mask.name == Same then
        return Sprites[self.sprite.name]
    elseif self.mask.name == None then
        return None
    else
        return Sprites[self.mask.name]
    end

end

-- instance pool
InstPool = {
    pool = {}
}

function InstPool:update()
    for _, inst in ipairs(self.pool) do
        if not inst.removed then
            if inst.update then
                inst:update()
            end

            inst:updateImageIndex()
        end
    end
end

function InstPool:draw()
    self:sortDepth()

    for _, inst in ipairs(self.pool) do
        if not inst.removed then
            if inst.draw then
                inst:draw()
            else
                inst:drawSelf()
            end
        end
    end
end

function InstPool:clean()
    -- clean removed instances
    for i = #self.pool, 1, -1 do
        if self.pool[i].removed then
            table.remove(self.pool, i)
        end
    end
end

local function compareDepth(a, b)
    return a.depth > b.depth
end

function InstPool:sortDepth()
    table.sort(self.pool, compareDepth)
end
