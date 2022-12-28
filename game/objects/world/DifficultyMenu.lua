Object.extends('DifficultyMenu', function(self)
    self.visible = true
    self.sprite = None
    self.mask = Same
    self.persistent = false

    local select = 0
    local playerIndex = 0
    local cherryIndex = 0

    function self:onUpdate()
        cherryIndex = cherryIndex + 1 / 15
        playerIndex = playerIndex + 1 / 5

        if Input:pressed('left') then
            select = (select - 1) % 3
        end
        if Input:pressed('right') then
            select = (select + 1) % 3
        end
        if Input:pressed('lshift') then
            Game:gotoRoom(Rooms.rDifficultySelect)
        end
    end

    function self:onDraw()
        for i = 0, 2, 1 do
            local xs = self.x + 240 * i
            local w = 128

            local bigSize = 40
            local smallSize = 16

            Fonts.default:draw(bigSize, 'Save ' .. (i + 1), xs, self.y, w, 'center', Color.black)
            Fonts.default:draw(smallSize, 'No Data', xs, self.y + 48, w, 'center', Color.black)
            Fonts.default:draw(smallSize, 'Deaths: 0', xs + 8, self.y + 72, w, 'left', Color.black)
            Fonts.default:draw(smallSize, 'Time: 0:00:00', xs + 8, self.y + 96, w, 'left', Color.black)

            local mid = xs + w / 2

            if select == i then
                Sprites.sCherry:draw(cherryIndex, mid-60, self.y + 310)
                Sprites.sCherry:draw(cherryIndex, mid-40, self.y + 310)
                Sprites.sCherry:draw(cherryIndex, mid-20, self.y + 310)
                Sprites.sPlayerIdle:draw(playerIndex, mid, self.y + 310)
                Sprites.sCherry:draw(cherryIndex, mid+20, self.y + 310)
                Sprites.sCherry:draw(cherryIndex, mid+40, self.y + 310)
                Sprites.sCherry:draw(cherryIndex, mid+60, self.y + 310)
            end

        end
    end
end)
