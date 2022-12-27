Object.extends('World', function(self)
    -- instance properties
    self.visible = false
    self.depth = 10001
    self.sprite = None

    -- private variables
    local time = 0
    local deaths = 0

    -- public variables
    self.infjump = 0
    self.godmode = 0

    -- private methods
    local function addDeaths(v)
        deaths = deaths + 1
    end

    -- public methods
    function self:quitGame()
        print('不好意思，提前退出游戏会有惩罚的哦')
    end

    -- lifecycle hooks
    function self:onCreate()
        love.window.setTitle('I wanna play in Love2D!!!')

        Sounds.liyue:play(true)
    end

    function self:onUpdate()
        for i in Objects.Player:iter() do

        end

        if Input:pressed(1) then
            print('lsp!')
        end

        if Input:released(1) then
            print('lsr!')
        end
    end

    function self:onDraw()
        self:drawSelf()
    end
end)
