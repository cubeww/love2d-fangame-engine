-- object.lua
-- game objects can be extended and instantiated.

Object = {}

-- an table containing all Object resources
Objects = {}

-- mask name constant, used to indicate that the mask is the same as the sprite
Same = -1

-- sprite / mask name constant, used to indicate a blank sprite/mask
None = -2

-- inherit an game object
function Object:extends(name, superName)
    if Objects[name] then
        -- the object has already been defined, so skip it directly
        return
    end

    local obj = {}
    Objects[name] = obj
    obj.objectName = name

    -- specifically, each object contains an additional instance pool and recursive instance pool 
    -- for convenience in some methods.
    obj._instPool = InstPool:new()
    obj._recursiveInstPool = InstPool:new()

    -- inherits from its super class
    if superName then
        if not Objects[superName] then
            -- the base class was not found, it may be defined before the base class definition,
            -- so perform *recursive* require
            requireAll('game/objects', LoadingFile)
        end

        self._super = Object[superName]
        setmetatable(obj, { __index = Objects[superName] })
    else
        setmetatable(obj, { __index = self })
    end

    return obj
end

-- define object properties
function Object:props(props)
    self.visible = props.visible or false
    self.depth = props.depth or 0
    self.spriteName = props.sprite or None
    self.maskName = props.mask or Same
    self.persistent = props.persistent or false
end
