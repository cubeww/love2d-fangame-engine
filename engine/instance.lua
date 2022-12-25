-- instance.lua
-- game object instance & instance Pool definitions and core methods.

-- instance = object metatable (visible, sprite, create()...) - object specific methods (extends, props...)
-- + instance fields (_speed, _frameIndex...) + instance properties (speed, direction...) + instance methods (placeMeeting...)
Inst = {}

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

function Transform:new(x, y)
    return setmetatable({
        x = x or 0,
        y = y or 0,
    }, { __index = self })
end

local function instIndex(t, k)
    -- NB: called only when instance gets a variable that doesn't exist
    if t._properties[k] then
        return t._properties[k].get(t)
    else
        return t._super[k]
    end
end

local function instNewIndex(t, k, v)
    if t._properties[k] then
        t._properties[k].set(t, v)
    else
        rawset(t, k, v)
    end
end

-- define instance properties (with getter, setter) here
local instProps = {
    -- transform
    x = {
        get = function(inst)
            return inst.transform.x
        end,
        set = function(inst, v)
            inst.transform.x = v
            inst.bbox.dirty = true
        end
    },
    y = {
        get = function(inst)
            return inst.transform.y
        end,
        set = function(inst, v)
            inst.transform.y = v
            inst.bbox.dirty = true
        end
    },
    xscale = {
        get = function(inst)
            return inst.transform.xscale
        end,
        set = function(inst, v)
            inst.transform.xscale = v
            inst.bbox.dirty = true
        end
    },
    yscale = {
        get = function(inst)
            return inst.transform.yscale
        end,
        set = function(inst, v)
            inst.transform.yscale = v
            inst.bbox.dirty = true
        end
    },
    angle = {
        get = function(inst)
            return inst.transform.angle
        end,
        set = function(inst, v)
            inst.transform.angle = v
            inst.bbox.dirty = true
        end
    },

    -- sprite & mask
    depth = {
        get = function(inst)
            return inst._depth
        end,
        set = function(inst, v)
            inst._depth = v
            OrderedInstPool.reorder = true
        end
    },
    spriteName = {
        get = function(inst)
            return inst._spriteName
        end,
        set = function(inst, v)
            inst._spriteName = v
            inst.bbox.dirty = true
        end
    },
    maskName = {
        get = function(inst)
            return inst._maskName
        end,
        set = function(inst, v)
            inst._maskName = v
            inst.bbox.dirty = true
        end
    },
    frameIndex = {
        get = function(inst)
            return inst._frameIndex
        end,
        set = function(inst, v)
            inst._frameIndex = v
            inst.bbox.dirty = true
        end
    },

    spriteTarget = { -- read only
        get = function(inst)
            return Sprites[inst._spriteName]
        end,
        set = function() end
    },
    maskTarget = { -- read only
        get = function(inst)
            if inst._maskName == Same then
                return Sprites[inst._spriteName]
            else
                return Sprites[inst._maskName]
            end
        end,
        set = function() end
    },

    -- movement
    hspeed = {
        get = function(inst)
            return inst._hspeed
        end,
        set = function(inst, v)
            inst._hspeed = v
            inst:computeSpeedDirection()
        end
    },
    vspeed = {
        get = function(inst)
            return inst._vspeed
        end,
        set = function(inst, v)
            inst._vspeed = v
            inst:computeSpeedDirection()
        end
    },
    speed = {
        get = function(inst)
            return inst._speed
        end,
        set = function(inst, v)
            inst._speed = v
            inst:computeHVSpeed()
        end
    },
    direction = {
        get = function(inst)
            return inst._direction
        end,
        set = function(inst, v)
            inst._direction = v
            inst:computeHVSpeed()
        end
    },
}

-- create an new instance of object
function Inst:new(objectName, x, y)
    local obj = Objects[objectName]

    local inst = {}

    inst._super = obj
    inst._properties = instProps

    -- implement property getter/setter hacks
    setmetatable(inst, { __index = instIndex, __newindex = instNewIndex })

    -- ******************* define fields *******************
    inst._objectName = objectName

    -- inherit from object:
    -- inst.visible = obj.visible
    -- inst.persistent = obj.persistent

    -- transform
    inst.transform = Transform:new(x, y)

    -- sprite & mask
    inst._depth = obj.depth
    inst._spriteName = obj.spriteName
    inst._maskName = obj.maskName
    inst._frameIndex = 0
    inst.frameSpeed = 1

    -- movement
    inst._hspeed = 0
    inst._vspeed = 0
    inst._speed = 0
    inst._direction = 0
    inst.gravity = 0
    inst.gravityDirection = 270
    inst.friction = 0

    inst.color = Color.white
    inst.alpha = 1

    -- bounding box
    inst.bbox = {
        dirty = true,
        left = nil,
        right = nil,
        top = nil,
        bottom = nil,
        lbbox = nil,
    }

    inst._removed = false

    -- since object has some properties that instance does not have,
    -- we need to remove them when instantiating.
    inst.extends = nil
    inst.props = nil
    inst._instPool = nil
    inst._recursiveInstPool = nil

    -- also, add instance methods to instance
    for k, v in pairs(Inst) do
        inst[k] = v
    end

    -- calling the new method on an instance doesn't seem appropriate...
    inst.new = nil

    -- insert to ordered instance pool
    OrderedInstPool:insertInst(inst)

    -- insert to object instance pool
    -- TODO
    -- table.insert(obj._instPool, inst)

    -- execute create method
    if inst.create then
        inst:create()
    end

    return inst
end

-- mark the instance as "removed"
function Inst:destroy()
    self._removed = true

    if self.destroyed then
        self:destroyed()
    end
end

-- draw the current sprite with the current transform
function Inst:drawSelf()
    local spr = self.spriteTarget
    if spr then
        spr:draw(self.frameIndex, self.x, self.y, self.xscale, self.yscale, self.angle,
            { self.color[1] / 255, self.color[2] / 255, self.color[3] / 255, self.color.a })
    end
end

function Inst:updateFrameIndex()
    self.frameIndex = self.frameIndex + self.frameSpeed
end

-- ******************* ordered instance pool *******************
OrderedInstPool = InstPool:new()
OrderedInstPool.reorder = false

function OrderedInstPool:update()
    OrderedInstPool:traverseInst(function(inst)
        if not inst._removed then
            if inst.update then
                inst:update()
            end

            inst:handleMovement()
            inst:updateFrameIndex()
        end
    end)
end

function OrderedInstPool:draw()
    if OrderedInstPool.reorder then
        OrderedInstPool:sortDepth()
    end


    OrderedInstPool:traverseInst(function(inst)
        if not inst._removed then
            if inst.draw then
                inst:draw()
            else
                inst:drawSelf()
            end
        end
    end)
end
