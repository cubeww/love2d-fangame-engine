Object.extends('WarpStart', function(self)
    self.visible = true
    self.sprite = Sprites.sWarp
    self.mask = Same
    self.persistent = false

    self.difName = ''
    self.dif = 0 -- 0=Load Game, 1=Medium, 2=Hard, 3=Very Hard, 4=Impossible

    function self:onUpdate()
        local p = self:placeMeeting(Objects.Player)
        if p then
            if self.dif == 4 then
                if love.filesystem.getInfo('saveData'..World.saveNum) then
                    World:loadGame(true)
                else
                    p:kill()
                end
            else
                p:destroy()

                World.gameStarted = true
                World.autosave = true
                World.difficulty = self.dif

                Game:gotoRoom(World.startRoom)
            end

        end
    end

    function self:onDraw()
        self:drawSelf()
        Fonts.default:draw(16, self.difName, self.x - 32, self.y - 16, 32 * 3, 'center')
    end
end)
