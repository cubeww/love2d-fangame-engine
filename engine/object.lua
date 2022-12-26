-- object.lua
-- game objects can be extended and instantiated.

Object = {}

Objects = {}

-- some special constants only used for sprite name and mask name
None = false
Same = true -- mask name only

-- the transform of instance
Transform = {
    x = 0,
    y = 0,
    xscale = 1,
    yscale = 1,
    angle = 0,

    -- the following properties are used for collision detection
    xo = 0, -- x-origin
    yo = 0, -- y-origin
    rxs = 1, -- reciprocal of xscale
    rys = 1, -- reciprocal of yscale
    st = 0, -- sine of angle
    ct = 1, -- cosine of angle
}

function Transform.new(x, y)
    return setmetatable({
        x = x or 0,
        y = y or 0,
    }, { __index = Transform })
end

-- prepare a special table, and when the instance accesses an undefined attribute, get the value from this table first.
-- this is very useful for extending the methods of an instance from other modules.
Instance = {}

-- Instance property access order:

-- -> Instance Properties (with getter/setter)
--   -> Instance Methods (the table above)
--     -> User Instance Fields & Methods

local objectMetatable = {
    __index = function(t, k)
        -- NB: called only when object gets a variable that doesn't exist
        if t._properties[k] then
            return t._properties[k].get(t)
        else
            return Instance[k]
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

-- define object properties (with getter, setter) here
local objectProperties = {
    -- object
    objectTarget = {
        get = function(t)
            return Objects[t._objectName]
        end
    },
    parentTarget = {
        get = function(t)
            return Objects[t._parentName]
        end
    },

    -- transform
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

    -- sprite & mask
    depth = {
        get = function(t)
            return t._depth
        end,
        set = function(t, v)
            t._depth = v
            OrderedInstancePool.shouldSortDepth = true
        end
    },
    spriteName = {
        get = function(t)
            return t._spriteName
        end,
        set = function(t, v)
            t._spriteName = v
            t.bbox.dirty = true
        end
    },
    maskName = {
        get = function(t)
            return t._maskName
        end,
        set = function(t, v)
            t._maskName = v
            t.bbox.dirty = true
        end
    },
    frameIndex = {
        get = function(t)
            return t._frameIndex
        end,
        set = function(t, v)
            t._frameIndex = v
            t.bbox.dirty = true
        end
    },

    spriteTarget = { -- read only
        get = function(t)
            return Sprites[t._spriteName]
        end,
        set = function() end
    },
    maskTarget = { -- read only
        get = function(t)
            if t._maskName == Same then
                return Sprites[t._spriteName]
            else
                return Sprites[t._maskName]
            end
        end,
        set = function() end
    },

    -- movement
    hspeed = {
        get = function(t)
            return t._hspeed
        end,
        set = function(t, v)
            t._hspeed = v
            Movement.computeSpeedDirection(t)
        end
    },
    vspeed = {
        get = function(t)
            return t._vspeed
        end,
        set = function(t, v)
            t._vspeed = v
            Movement.computeSpeedDirection(t)
        end
    },
    speed = {
        get = function(t)
            return t._speed
        end,
        set = function(t, v)
            t._speed = v
            Movement.computeHVSpeed(t)
        end
    },
    direction = {
        get = function(t)
            return t._direction
        end,
        set = function(t, v)
            t._direction = v
            Movement.computeHVSpeed(t)
        end
    },
}

-- basic instantiation function
function Object.new()
    local self = {}

    self._properties = objectProperties
    setmetatable(self, objectMetatable)

    -- object
    self.visible = true
    self._depth = 0
    self.persistent = false

    -- transform
    self.transform = Transform.new()

    -- sprite & mask
    self._spriteName = None
    self._maskName = Same
    self._frameIndex = 0
    self.frameSpeed = 1

    -- movement
    self._hspeed = 0
    self._vspeed = 0
    self._speed = 0
    self._direction = 0
    self.gravity = 0
    self.gravityDirection = 270
    self.friction = 0

    self.color = Color.white
    self.alpha = 1

    -- bounding box
    self.bbox = {
        dirty = true,
        left = nil,
        right = nil,
        top = nil,
        bottom = nil,
        lbbox = nil,
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

    local self = {
        objectName = objectName,
        parentName = parentName,
        instancePool = InstancePool.new(),
        recursiveInstancePool = InstancePool.new(),
    }

    -- instantiation function
    function self.new()
        local inst
        if parentName then
            inst = Objects[parentName].new()
        else
            inst = Object.new()
        end
        constructor(inst)

        inst._objectName = objectName
        inst._parentName = parentName

        return inst
    end

    Objects[objectName] = self

    return self
end
