Object.extends('World', function(self)
    -- instance properties
    self.visible = false
    self.depth = 10001
    self.sprite = None


    function self:onCreate()
        love.window.setTitle('I wanna play in Love2D!!!')

        for _ = 1, 10000, 1 do
            Objects.SpikeUp:new()
                :next(function(i)
                    i.x = math.random(800)
                    i.y = math.random(608)
                end)
        end

        Sounds.liyue:play(true)
    end

    function self:onUpdate()

    end

    function self:onDraw()
        self:drawSelf()
    end
end)
