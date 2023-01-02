local random = math.random
local choose = math.choose
local ldir = math.ldir
local pdir = math.pdir

-- You can define multiple objects in one lua file like this!
Object.extends('mk-base', 'PlayerKiller', function(self)
    self.visible = true
    self.sprite = Sprites.sColorCherry
    self.mask = Same
    self.persistent = false
    self.depth = 100

    self.frameSpeed = 0
    self.frameIndex = math.random(11)

    self.tx = nil
    self.ty = nil
    self.tspeed = 7

    self.outDestroy = true

    self.timer = 0

    function self:onUpdate()
        self.timer = self.timer + 1

        self:onTime(self.timer)

        if self.tx then
            self.x = self.x + (self.tx - self.x) / self.tspeed
        end
        if self.ty then
            self.y = self.y + (self.ty - self.y) / self.tspeed
        end

        if self.outDestroy and (self.x < 0 or self.y < 0 or self.x > 800 or self.y > 608) then
            self:destroy()
        end
    end

    -- Override
    function self:onTime(t) end
end)
----------------------------------------------------------------------
Object.extends('mk-1-big', 'mk-base', function(self)
    self.xscale = 3
    self.yscale = 3
    self.vspeed = 6

    self.makeCurve = false

    function self:onTime(t)
        if t == 10 then
            local curve = self.makeCurve and (-1 + 2 * random()) or 0
            MikuUtil.makeCircle(self.x, self.y, Objects['mk-1'], 12, 8, random() * 360, function(a)
                a.frameIndex = self.frameIndex
                a.dir = curve
            end)

            self:destroy()
        end
    end
end)

Object.extends('mk-1', 'mk-base', function(self)
    self.dir = 0
    function self:onTime()
        self.direction = self.direction + self.dir
    end
end)

----------------------------------------------------------------------
Object.extends('mk-2', 'mk-base', function(self)
    self.direction = random() * 360
    self.speed = 6
    self.flag = choose(1, 2, 3)
    self.frameIndex = self.flag
    self.bounce = true

    function self:slow()
        self.friction = 0.2
    end

    function self:boom(flag)
        if self.flag == flag then
            self.friction = 0
            self.speed = 8
            self.direction = random() * 360
            self.bounce = false
        end
    end

    function self:move(flag, rng)
        if self.flag == flag then
            self.friction = 0
            self.speed = 0
            self.bounce = false

            self.tx, self.ty = ldir(400, 304, 150, self.index * (120 / 15) + self.flag * 120 + rng)
        end
    end

    function self:exit()
        self.direction = pdir(self.tx, self.ty, 400, 304)
        self.speed = 10
        self.tx = nil
        self.ty = nil
    end

    function self:onTime()
        if self.bounce then
            if self:placeMeeting(Objects.Block, self.x + self.hspeed, self.y) then
                self.hspeed = self.hspeed * -1
            end

            if self:placeMeeting(Objects.Block, self.x, self.y + self.vspeed) then
                self.vspeed = self.vspeed * -1
            end
        end

    end
end)
----------------------------------------------------------------------
Object.extends('mk-3-big', 'mk-base', function(self)
    self.xscale = 3
    self.yscale = 3

    self.tspeed = 20

    function self:onTime(t)
        if t == 45 then
            MikuUtil.makeStar(self.x, self.y, Objects['mk-3-1'], 15, 250, 40, random() * 360, function(a, i)
                a.frameIndex = self.frameIndex
            end)

            self:destroy()
        end
    end
end)

Object.extends('mk-3-1', 'mk-base', function(self)
    function self:onTime(t)
    end
end)

Object.extends('mk-3-speak', 'mk-base', function(self)
    function self:onTime(t)
    end
end)

Object.extends('mk-3-2', 'mk-base', function(self)
    local count = 0
    function self:onTime(t)
        if t >= 45 and count < 5 then
            self.speed = 0
            MikuUtil.rotateAround(self, 400, 304, 2)
        end

        if t >= 45 and (t - 45) % 45 == 0 and count < 5 then
            Objects['mk-3-1']:new(self.x, self.y):next(function(a)
                a.hspeed = (a.x - 400) / 40
                a.vspeed = (a.y - 304) / 40
                a.frameIndex = self.frameIndex
            end)

            count = count + 1
            if count == 5 then
                self.direction = pdir(self.x, self.y, 400, 304)
                self.speed = 6
            end
        end
    end
end)
----------------------------------------------------------------------
Object.extends('mk-4', 'mk-base', function(self)
    self.hspeed = 25
    local f = 0
    function self:onTime(t)
        Objects['mk-4-1']:new(self.x, self.y):next(function(a)
            a.frameIndex = f % 11
            a.flag = self.flag
        end)
        f = f + 1
    end
end)
Object.extends('mk-4-1', 'mk-base', function(self)
    self.small = false

    function self:onTime()
        if self.small then
            if self.xscale > 0.3 then
                self.xscale = self.xscale - 0.01
                self.yscale = self.yscale - 0.01
            end
        end
    end

    function self:up()
        if self.flag == 2 then
            self.x, self.y = ldir(self.x, self.y, 50, 45 + 90 * random())
        end
    end

    function self:down()
        if self.flag == 2 then
            self.gravity = 0.20
            self.direction = 45 + 90 * random()
            self.speed = 8
        end
    end
end)
Object.extends('mk-4-2-big', 'mk-base', function(self)
    self.xscale = 3
    self.yscale = 3
    self.tspeed = 10
    self.shoot = false

    function self:onTime(t)
        if self.shoot and t % 2 == 0 then
            Objects.Player:with(function(p)
                Objects['mk-4-2']:new(self.x, self.y):next(function(a)
                    a.speed = 10
                    a.direction = pdir(self.x, self.y, p.x, p.y)
                    a.frameIndex = self.frameIndex
                end)
            end)
        end

        if self.x < 100 or self.x > 700 and t > 100 then
            MikuUtil.makeStar(self.x, self.y, Objects['mk-4-2'], 5, 250, 40, 0, function(a, i)
                a.frameIndex = self.frameIndex
            end)
            self:destroy()
        end
    end

    function self:boom()
        if self.y < 304 then
            self.hspeed = 20
            self.tx = nil
            self.ty = nil
        else
            self.hspeed = -20
            self.tx = nil
            self.ty = nil
        end
    end
end)

Object.extends('mk-4-2', 'mk-base', function(self)
end)

Object.extends('mk-4-3', 'mk-base', function(self)
    self.speed = 18
    self.f = 0
    function self:onCreate()
        Objects.Player:with(function(p)
            self.direction = pdir(self.x, self.y, p.x, p.y)
        end)
    end

    function self:onTime()
        Objects['mk-4-1']:new(self.x, self.y):next(function(a)
            a.frameIndex = self.f % 11
        end)
        self.f = self.f + 1
    end
end)

Object.extends('mk-4-4', 'mk-base', function(self)
    self.outDestroy = false
    self.curve = 0

    function self:onTime()
        self.direction = self.direction + self.curve

        if not self.outDestroy then
            if self.x > 800 then
                self.x = 0
            end
            if self.x < 0 then
                self.x = 800
            end
            if self.y > 608 then
                self.y = 0
            end
            if self.y < 0 then
                self.y = 608
            end
        end
    end
end)

----------------------------------------------------------------------
Object.extends('mk-5', 'mk-base', function(self)
    function self:onTime(t)
        if t == 15 then
            Objects.Player:with(function(p)
                self.direction = pdir(self.x, self.y, p.x, p.y)
            end)
        end
    end
end)

Object.extends('mk-5-1', 'mk-base', function(self)
    self.outDestroy = false

    function self:onTime(t)
        if t > 250 then
            self.outDestroy = true
        end
    end
end)
Object.extends('mk-5-2', 'mk-base', function(self)
    self.xscale = 2
    self.yscale = 2

    function self:onTime()
        if self.x < 100 then
            Objects.Player:with(function(p)
                MikuUtil.makeCircle(self.x, self.y, Objects['mk-5-2-1'], 14, 10, pdir(self.x, self.y, p.x, p.y),
                    function(a, i)
                        a.frameIndex = self.frameIndex
                        a.rot = self.flag % 2 == 1 and 1 or -1
                    end)
            end)

            self:destroy()
        end
    end
end)

Object.extends('mk-5-2-1', 'mk-base', function(self)
    function self:onTime()
        if self.rot then
            self.direction = self.direction + self.rot
        end
    end
end)

Object.extends('mk-5-3', 'mk-base', function(self)
    local f = 0
    local index = 0
    function self:onTime(t)
        Objects['mk-5-3-1']:new(self.x, self.y):next(function(a)
            a.frameIndex = f % 11
            a.flag = self.flag
            a.index = index
        end)
        index = index + 1
        f = f + 1
    end
end)

Object.extends('mk-5-3-1', 'mk-base', function(self)
    function self:onTime(t)
        if self.warp then
            if self.y < 0 then
                self.y = 608
                self.friction = 0.18
                self.gravity = 0
                self.vspeed = -10
            end
        end
        if t == self.exitTime then
            self.vspeed = 1
            if self.index % 2 == 0 then
                self.vspeed = self.vspeed * -1
            end
            self.friction = -0.5
            self.warp = false
            self.outDestroy = true
        end
    end

    function self:exit()
        self.exitTime = math.ceil(math.abs(self.x - 401) / 6)
        self.timer = 0
    end
end)
----------------------------------------------------------------------
Object.extends('mk-6', 'mk-base', function(self)
    self.mask = None

    function self:onCreate()
        self.alpha = 0.5
    end

    function self:onTime(t)
        if t == 20 then
            self.alpha = 1
            self.mask = Same
        end
        if t > 20 and self.flag ~= 1 then
            if self.xscale > 0 then
                self.xscale = self.xscale - 0.1
                self.yscale = self.yscale - 0.1
            else
                self:destroy()
            end
        end
    end
end)

Object.extends('mk-6-1', 'mk-base', function(self)
    function self:onTime(t)
        if t == 10 then
            self.speed = 0
            self.gravity = 0.1
        end
    end
end)

Object.extends('mk-6-2', 'mk-base', function(self)
    function self:onTime(t)
        if t == 17 then
            self.speed = 0
            self.dist = math.sqrt((self.x - 400) * (self.x - 400) + (self.y - 304) * (self.y - 304))
            self.dir = pdir(400, 304, self.x, self.y)
        end


        if self.rotate then
            self.x, self.y = ldir(400, 304, self.dist, self.dir)
            self.dir = self.dir + 7

            Objects['mk-6-3']:new(self.x, self.y):next(function(a)
                a.direction = pdir(400, 304, self.x, self.y)
                a.speed = 12
                a.frameIndex = self.frameIndex
            end)
        end

        if self.flag == 1 then
            if self.dist > 48 then
                self.dist = self.dist - 3
            else
                self.flag = 2
            end
        end

        if self.flag == 2 then
            if self.dist < 200 then
                self.dist = self.dist + 3
            end
        end

        if self.flag == 3 then
            self.dist = self.dist + 1
        end
    end

    function self:shoot()
        if self.index == 4 then
            Objects['mk-6-3']:new(self.x, self.y):next(function(a)
                a.direction = pdir(self.x, self.y, 400, 304) + 10
                a.speed = 8
            end)
        end
    end
end)

Object.extends('mk-6-3', 'mk-base', function(self)
end)

Object.extends('mk-6-4', 'mk-base', function(self)
    self.curve = 0
    self.outDestroy = false
    function self:onTime(t)
        if not self.outDestroy then
            if self.x > 800 then
                self.x = 0
            end
            if self.x < 0 then
                self.x = 800
            end
            if self.y > 608 then
                self.y = 0
            end
            if self.y < 0 then
                self.y = 608
            end
        end

        self.direction = self.direction + self.curve
    end
end)


----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
