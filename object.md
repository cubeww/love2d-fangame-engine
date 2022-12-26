# Object实现的重考虑

为了解决“递归重载文件”的傻问题，现将Object-Instance实现进行修改。下面是预选方案：

1. 闭包式

优点：支持私有字段，继承灵活，易理解，不容易造成依赖缺失

```lua
Object.extends('World', function(self)
    -- private fields here
    local timer = 0
    local canSave = false

    function self:onCreate()
        -- instance properties
        self.visible = true
        self.depth = 10001
        self.persistent = true
        self.spriteName = sWorld

        -- ... create code
    end

    function self:onUpdate()
        -- ... update code
    end

    function self:onDraw()
        -- ... draw code
    end
end)

-- inheritance
Object.extends('WorldSon', 'World', function(self)
    
    local baseOnCreate = self.onCreate
    function self:onCreate()
        -- ...code
        baseOnCreate()
        -- ...code
    end
end)

```

2. 传统式

优点：好像没有

缺点：书写复杂，看起来混乱。

```lua
World = Object.extends('World')

function World:onCreate()
    -- instance properties
    self.visible = true
    self.depth = 10001
    self.persistent = true
    self.spriteName = sWorld

    -- ... create code
end

function World:onUpdate()
    -- ... update code
end

function World:onDraw()
    -- ... draw code
end

-- inheritance
WorldSon = Object.extends('WorldSon', 'World')

function WorldSon:onCreate()
    -- call parent method...
    self.__metatable.__index.onCreate()
end
```

