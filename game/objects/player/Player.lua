local Player = Object:extends('Player')

Player:props({
    depth = -10,
    sprite = 'sPlayerMask',
    mask = Same,
    persistent = true,
})

function Player:onCreate()
    self.jump = 8.5
    self.jump2 = 7

    -- self.gravity = 0.4
    self.djump = 1
    self.maxSpeed = 3
    self.maxVspeed = 9

    self.frameSpeed = 0.2
    self.onPlatform = false
    self.xScale = 1

    self.hspeed=1

end

function Player:onUpdate()
    if love.keyboard.isDown('down') then
        self.y = self.y + 1
    end
    if love.keyboard.isDown('up') then
        self.y = self.y - 1
    end
    if love.keyboard.isDown('left') then
        self.x = self.x - 1
    end
    if love.keyboard.isDown('right') then
        self.x = self.x + 1
    end
    
end

function Player:onDraw()
    self:drawSelf()
end
