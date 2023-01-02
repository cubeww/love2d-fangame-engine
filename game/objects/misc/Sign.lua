Object.extends('Sign', function(self)
    self.visible = true
    self.sprite = Sprites.sSign
    self.mask = Same
    self.persistent = false
    self.depth = 10

    local showText = false
    local width = 256

    self.signText = ''

    function self:onUpdate()
        if self:placeMeeting(Objects.Player) then
            if Input:pressed('up') then
                showText = true
            end
        else
            showText = false
        end
    end

    function self:onDraw()
        self:drawSelf()
        if showText then
            Fonts.default:draw(16, self.signText, self.x + 16 - width / 2, self.y - 32, width, 'center')
        end
    end
end)
