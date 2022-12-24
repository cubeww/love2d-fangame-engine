Object = {}

-- an array containing all Object resources
Objects = {}

-- mask constant, used to indicate that the mask is the same as the sprite
Same = -1

-- sprite / mask constant, used to indicate a blank sprite/mask
None = -2

-- inherit an game object
function Object:extends(name, baseName)
    if Objects[name] then
        -- the object has already been defined, so skip it directly
        return
    end

    local obj = {}
    Objects[name] = obj
    obj.objectName = name

    -- in particular, each object has an additional pool of instances 
    -- for improved efficiency in collision detection
    obj.addlPool = {}

    -- inherits from its base class
    if baseName then
        if not Objects[baseName] then
            -- the base class was not found, it may be defined before the base class definition,
            -- so perform *recursive* require
            requireAll('game/objects', LoadingFile)
        end

        self.super = Object[baseName]
        setmetatable(obj, { __index = Objects[baseName] })
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
