-- object.lua
-- Game objects can be extended and instantiated.

Object = {}

Objects = {}

-- Some special constants only used for sprite and mask
None = false
Same = true -- Mask only

-- The transform of instance
Transform = {
    x = 0,
    y = 0,
    xscale = 1,
    yscale = 1,
    angle = 0,

    -- The following properties are used for collision detection
    xo = 0, -- X-origin
    yo = 0, -- Y-origin
    rxs = 1, -- Reciprocal of xscale
    rys = 1, -- Reciprocal of yscale
    st = 0, -- Sine of angle
    ct = 1, -- Cosine of angle
}

function Transform.new(x, y)
    return setmetatable({
        x = x or 0,
        y = y or 0,
    }, { __index = Transform })
end

-- Prepare a special table, and when the instance accesses an undefined attribute, get the value from this table first.
-- This is very useful for extending the methods of an instance from other modules.
Instance = {}

-- Instance property access order:

-- -> Instance Properties (with getter/setter)
--   -> User Instance Fields & Methods
--     -> Instance Methods (the table above)

local objectMetatable = {
    __index = function(t, k)
        -- NB: Called only when object gets a variable that doesn't exist
        local prop
        prop = t._properties[k]
        if prop then
            return prop.get(t)
        else
            prop = rawget(t, k)
            if prop then
                return prop
            else
                return Instance[k]
            end
        end
    end,
    __newindex = function(t, k, v)
        if t._properties[k] then
            t._properties[k].set(t, v)
        else
            rawset(t, k, v)
        end
    end
}

-- Define object properties (with getter, setter) here
local objectProperties = {
    -- Transform
    x = {
        get = function(t)
            return t.transform.x
        end,
        set = function(t, v)
            t.transform.x = v
            t.bbox.dirty = true
        end
    },
    y = {
        get = function(t)
            return t.transform.y
        end,
        set = function(t, v)
            t.transform.y = v
            t.bbox.dirty = true
        end
    },
    xscale = {
        get = function(t)
            return t.transform.xscale
        end,
        set = function(t, v)
            t.transform.xscale = v
            t.bbox.dirty = true
        end
    },
    yscale = {
        get = function(t)
            return t.transform.yscale
        end,
        set = function(t, v)
            t.transform.yscale = v
            t.bbox.dirty = true
        end
    },
    angle = {
        get = function(t)
            return t.transform.angle
        end,
        set = function(t, v)
            t.transform.angle = v
            t.bbox.dirty = true
        end
    },

    -- Sprite & Mask
    depth = {
        get = function(t)
            return t._depth
        end,
        set = function(t, v)
            t._depth = v
            OrderedInstancePool.instancesToSort[t] = true
        end
    },
    frameIndex = {
        get = function(t)
            return t._frameIndex
        end,
        set = function(t, v)
            if t.mask and (t.mask:getFrame(v) ~= t.mask:getFrame(t._frameIndex)) then
                t.bbox.dirty = true
            end
            t._frameIndex = v
        end
    },
    frame = { -- Read only
        get = function(t)
            if t.sprite then
                return t.sprite:getFrame(t._frameIndex)
            end
        end,
        set = function() end
    },
    maskFrame = { -- Read only
        get = function(t)
            if t.mask then
                return t.mask:getFrame(t._frameIndex)
            end
        end,
        set = function() end
    },
    sprite = {
        get = function(t)
            return t._sprite
        end,
        set = function(t, v)
            t._sprite = v
            t.bbox.dirty = true
        end
    },
    mask = {
        get = function(t)
            if t._mask == Same then
                return t._sprite
            else
                return t._mask
            end
        end,
        set = function(t, v)
            t._mask = v
            t.bbox.dirty = true
        end
    },

    -- Movement
    hspeed = {
        get = function(t)
            return t._hspeed
        end,
        set = function(t, v)
            t._hspeed = v
            t:computeSpeedDirection(t)
        end
    },
    vspeed = {
        get = function(t)
            return t._vspeed
        end,
        set = function(t, v)
            t._vspeed = v
            t:computeSpeedDirection(t)
        end
    },
    speed = {
        get = function(t)
            return t._speed
        end,
        set = function(t, v)
            t._speed = v
            t:computeHVSpeed(t)
        end
    },
    direction = {
        get = function(t)
            return t._direction
        end,
        set = function(t, v)
            t._direction = v
            t:computeHVSpeed(t)
        end
    },
}

-- Basic instantiation function

-- Internal instantiation function. Do not call it directly, instead call SomeObject:new().
function Object._new()
    local self = {}

    self._properties = objectProperties
    setmetatable(self, objectMetatable)

    -- Object
    self.visible = true
    self._depth = 0
    self.persistent = false

    -- Transform
    self.transform = Transform.new()

    -- Sprite & mask
    self._sprite = None
    self._mask = Same
    self._frameIndex = 0
    self.frameSpeed = 1

    -- Movement
    self._hspeed = 0
    self._vspeed = 0
    self._speed = 0
    self._direction = 0
    self.gravity = 0
    self.gravityDirection = 270
    self.friction = 0

    self.color = Color.white
    self.alpha = 1

    -- Bounding box
    self.bbox = {
        dirty = true,
        left = nil,
        right = nil,
        top = nil,
        bottom = nil,
        localbbox = nil,
    }

    self._shouldRemove = false

    return self
end

function Object.extends(objectName, arg2, arg3)
    local constructor, parentName
    if arg3 then
        constructor = arg3
        parentName = arg2
    else
        constructor = arg2
        parentName = nil
    end

    local self = { -- self refers to the **object**, not the instance
        name = objectName,

        -- NB: The parent here is unknown, so it cannot be set directly to the parent object itself
        -- like: parent = Objects[parentName]
        parentName = parentName,

        instancePool = InstancePool.new(),
        recursiveInstancePool = InstancePool.new(),
    }

    setmetatable(self, { __index = Object })

    -- Instantiation function
    function self._new()
        -- Now that all objects are known, you can use like: Object[parentName]
        local inst
        if parentName then
            inst = Objects[parentName]._new()
        else
            inst = Object._new()
        end
        constructor(inst)

        inst.object = Objects[objectName]

        return inst
    end

    Objects[objectName] = self
    return self
end

-- ******************** Object -> instance functions ********************

-- Creates an instance of an object. Like instance_create() in GameMaker.
-- New instance will execute in sequence:
-- -> Object:_new(inst)
--   -> Parent1:constructor(inst)
--     -> Parent2:constructor(inst)
--       -> ...
--         -> Object:constructor(inst)
--           -> Instance:onCreate(inst)
function Object:new(x, y)
    local inst = self._new()
    inst.x = x or 0
    inst.y = y or 0

    -- Append to instance pools
    inst:appendToPools()

    -- Call onCreate method
    if inst.onCreate then
        inst:onCreate()
    end

    return inst
end

-- Same as the function above, but 'inserted' into the order instance pool.
-- This is typically called when creating an instance at the start of a room.
function Object:_insertNew(x, y)
    local inst = self._new()
    inst.x = x or 0
    inst.y = y or 0

    inst:appendToPools(true)

    if inst.onCreate then
        inst:onCreate()
    end

    return inst
end

-- Advanced iterator of object.
--[[ this iterator has added some additional features on top of the instance pool iterator

    like:
        Objects.SomeObject:iter()
            :filter(function(i) return i.x < 400 end)
            :filter(function(i) return i.y < 304 end)
            :filter(function(i) return i.frameIndex >= 2 end)
            :with(function(i) i:destroy() end)

    equivalent to:
        for i in Objects.SomeObject:iter() do
            if i.x < 400 and i.y < 304 and i.frameIndex >= 2 then
                i:destroy()
            end
        end

    It's worth noting that the first method is usually more efficient!
]]
function Object:iter(recursive)
    recursive = recursive or true

    local poolIter = recursive and self.recursiveInstancePool:iter() or self.instancePool:iter()
    local iter = {}
    local filters = {}

    function iter:filter(filter)
        table.insert(filters, filter)
        return iter
    end

    function iter:with(func)
        for inst in iter do
            func(inst)
        end
        return nil
    end

    function iter:collect()
        local result = {}
        for inst in iter do
            table.insert(result, inst)
        end
        return result
    end

    local mt = {
        __call = function()
            local inst = poolIter()
            while inst do
                local flag = true
                for _, f in ipairs(filters) do
                    if not f(inst) then
                        flag = false
                        break
                    end
                end
                if flag then
                    return inst
                end

                inst = poolIter()
            end
            return nil
        end
    }
    setmetatable(iter, mt)

    return iter
end

-- some simplified functions for iterators, to make it easier for users to use

function Object:first()
    for inst in self:iter(false) do
        return inst
    end
    return nil
end

function Object:with(func, recursive)
    self:iter(recursive):with(func)
end

function Object:filter(filter, recursive)
    return self:iter(recursive):filter(filter)
end

function Object:collect(recursive)
    return self:iter(recursive):collect()
end
