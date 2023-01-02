Object.extends('DifficultyMenu', function(self)
    self.visible = true
    self.sprite = None
    self.mask = Same
    self.persistent = false

    local select = 0
    local playerIndex = 0
    local cherryIndex = 0

    local death = { 0, 0, 0 }
    local time = { '0:00:00', '0:00:00', '0:00:00' }
    local difficulty = { 'No Data', 'No Data', 'No Data' }

    function self:onCreate()
        for i = 1, 3, 1 do
            if love.filesystem.getInfo('saveData' .. i) then
                local data = json.decode(love.filesystem.read('saveData' .. i))
                death[i] = data.death
                local d = data.difficulty

                if d == 0 then
                    difficulty[i] = 'Medium'
                elseif d == 1 then
                    difficulty[i] = 'Hard'
                elseif d == 2 then
                    difficulty[i] = 'Very Hard'
                elseif d == 3 then
                    difficulty[i] = 'Impossible'
                end

                local t = data.time
                local hours = math.floor(t / 180000)
                local minutes = math.floor(t / 3000) % 60
                local seconds = math.floor(t / 50) % 60
                time[i] = hours .. ':' ..
                    (minutes < 10 and '0' .. minutes or minutes) .. ':' .. (seconds < 10 and '0' .. seconds or seconds)
            end
        end
    end

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
            World.saveNum = select + 1
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
            Fonts.default:draw(smallSize, difficulty[i + 1], xs, self.y + 48, w, 'center', Color.black)
            Fonts.default:draw(smallSize, 'Deaths: ' .. death[i + 1], xs + 8, self.y + 72, w, 'left', Color.black)
            Fonts.default:draw(smallSize, 'Time: ' .. time[i + 1], xs + 8, self.y + 96, w, 'left', Color.black)

            local mid = xs + w / 2

            if select == i then
                Sprites.sCherry:draw(cherryIndex, mid - 60, self.y + 310)
                Sprites.sCherry:draw(cherryIndex, mid - 40, self.y + 310)
                Sprites.sCherry:draw(cherryIndex, mid - 20, self.y + 310)
                Sprites.sPlayerIdle:draw(playerIndex, mid, self.y + 310)
                Sprites.sCherry:draw(cherryIndex, mid + 20, self.y + 310)
                Sprites.sCherry:draw(cherryIndex, mid + 40, self.y + 310)
                Sprites.sCherry:draw(cherryIndex, mid + 60, self.y + 310)
            end

        end
    end
end)
