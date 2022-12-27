Object.extends('World', function(self)
    -- instance properties
    self.visible = false
    self.depth = 10001
    self.sprite = None


    function self:onCreate()
        love.window.setTitle('I wanna play in Love2D!!!')

        Sounds.musGuyRock:play()
    end

    function self:onUpdate()

    end

    function self:onDraw()
        self:drawSelf()
    end
end)
