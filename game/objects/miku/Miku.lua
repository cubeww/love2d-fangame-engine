Object.extends('Miku', 'PlayerKiller', function(self)
    self.visible = true
    self.sprite = Sprites.sMiku
    self.mask = Same
    self.persistent = false
    self.depth = 10000

    -- Change current time
    -- 950
    -- local time = 1800
    local time = -50

    local music
    local BPM = 160
    local FPB = 1 / BPM * 3000

    local beat = 0

    local beatDone = {}

    local mouthX, mouthY
    local handX, handY
    local rhandX, rhandY

    local random = math.random
    local choose = math.choose

    local flag = 1
    local rng = random()

    local cx = 0

    function on(...)
        local args = { ... }
        for i, v in ipairs(args) do
            if i == #args then
                break
            end
            if math.abs(beat - v) <= 1 / FPB and not beatDone[v] then
                beatDone[v] = true
                args[#args]()
            end
        end
    end

    function ranget(startBeat, endBeat, timeInterval, callback)
        local startTime = math.round(startBeat * FPB)
        if beat >= startBeat and beat <= endBeat then
            if (time - startTime - 1) % math.round(timeInterval) == 0 then
                callback()
            end
        end
    end

    function self:onCreate()
        mouthX = self.x + 148
        mouthY = self.y + 79

        handX = self.x + 68
        handY = self.y + 244

        rhandX = self.x + 185
        rhandY = self.y + 255

        World:stopMusic()
        if time > 0 then
            music = World:playMusic(Sounds.musMiku, false)
            music:seek(time / 50)
        end
    end

    function self:onUpdate()
        if not Objects.Player:first() then
            World:stopMusic()
            return
        end

        time = time + 1
        beat = time / FPB

        if time == 0 then
            music = World:playMusic(Sounds.musMiku, false)
        end

        -------------------- mk-1 --------------------
        ranget(5, 20, FPB, function()
            Objects['mk-1-big']:new(100 + random() * 600, 0)
        end)

        ranget(21, 36, FPB, function()
            Objects['mk-1-big']:new(100 + random() * 600, 0):next(function(a)
                a.makeCurve = true
            end)
        end)

        -------------------- mk-2-1 --------------------
        ranget(37, 47, 4, function()
            Objects['mk-2']:new(mouthX, mouthY)
        end)

        on(47, function()
            Objects['mk-2']:with(function(a)
                a:slow()
            end)
        end)

        on(49, function()
            Objects['mk-2']:with(function(a)
                a:boom(1)
            end)
        end)

        on(50, function()
            Objects['mk-2']:with(function(a)
                a:boom(2)
            end)
        end)

        on(51, function()
            Objects['mk-2']:with(function(a)
                a:boom(3)
            end)
        end)

        -------------------- mk-2-2 --------------------
        on(53, 55, 57, function()
            MikuUtil.makeCircle(mouthX, mouthY, Objects['mk-2'], 15, 8, random() * 360, function(a, i)
                a.frameIndex = flag
                a.flag = flag
                a.index = i
            end)

            flag = flag + 1
        end)

        on(60, function()
            Objects['mk-2']:with(function(a)
                a:slow()
            end)
        end)

        on(61, function()
            Objects['mk-2']:with(function(a)
                a:move(1, rng * 360)
            end)
        end)
        on(62, function()
            Objects['mk-2']:with(function(a)
                a:move(2, rng * 360)
            end)
        end)
        on(63, function()
            Objects['mk-2']:with(function(a)
                a:move(3, rng * 360)
            end)
        end)

        on(65, function()
            Objects['mk-2']:with(function(a)
                a:exit()
            end)
        end)

        -------------------- mk-3 --------------------
        on(67, function()
            Objects['mk-3-big']:new(handX, handY):next(function(a)
                a.tx = 200
                a.ty = 288
            end)
        end)

        on(76, function()
            Objects['mk-3-big']:new(rhandX, rhandY):next(function(a)
                a.tx = 500
                a.ty = 288
            end)
        end)

        ranget(67, 81, 2, function()
            Objects['mk-3-speak']:new(mouthX, mouthY):next(function(a)
                a.direction = random() * 360
                a.speed = 5 + random() * 3
            end)
        end)

        on(82, function()
            MikuUtil.makeStarOutline(400, 304, Objects['mk-3-2'], 3, 64, 30, random() * 360)
        end)

        -------------------- mk-4 --------------------
        on(100, function()
            Objects['mk-4']:new(0, 608 - 48):next(function(a)
                a.flag = 1
            end)
        end)

        on(102, function()
            Objects['mk-4']:new(0, 608 - 48 - 32):next(function(a)
                a.flag = 2
            end)
        end)

        on(104, 105, 105.5, 106, function()
            Objects['mk-4-1']:with(function(a)
                a:up()
            end)
        end)

        on(106.5, function()
            Objects['mk-4-1']:with(function(a)
                a:down()
            end)
        end)

        on(109, function()
            Objects['mk-4-2-big']:new(handX, handY):next(function(a)
                a.tx = 320
                a.ty = 160
            end)
        end)

        on(111, function()
            Objects['mk-4-2-big']:new(rhandX, rhandY):next(function(a)
                a.tx = 320
                a.ty = 432
            end)
        end)

        on(112, function()
            Objects['mk-4-2-big']:with(function(a)
                a.shoot = true
            end)
        end)

        on(115, function()
            Objects['mk-4-2-big']:with(function(a)
                a.shoot = false
            end)
            Objects['mk-4-2-big']:with(function(a)
                if a.y < 304 then
                    a:boom()
                end

            end)
        end)
        on(116, function()
            Objects['mk-4-2-big']:with(function(a)
                if a.y > 304 then
                    a:boom()
                end
            end)
        end)

        on(116.5, function()
            Objects['mk-4-3']:new(handX, handY):next(function(a)
            end)
        end)

        on(118, function()
            Objects['mk-4-3']:new(rhandX, rhandY):next(function(a)
            end)
        end)

        on(120, 121, 121.5, 122, 122.5, function()
            Objects['mk-4-1']:with(function(a)
                a.outDestroy = false
                MikuUtil.rotateAround(a, 400, 304, 30)
            end)
        end)

        on(123, function()
            Objects['mk-4-1']:with(function(a)
                a.direction = 30 + random() * 120
                a.speed = random() * 10
                a.gravity = 0.1
                a.small = true
                a.outDestroy = true
            end)
        end)

        ranget(128, 138, 16, function()
            Objects['mk-4-4']:new(mouthX, mouthY):next(function(a)
                a.speed = 4 + random() * 2
                a.direction = random() * 360
            end)
        end)

        ranget(145, 153, 16, function()
            Objects['mk-4-4']:new(mouthX, mouthY):next(function(a)
                a.curve = -0.5 + random() * 1
                a.speed = 4 + random() * 2
                a.direction = random() * 360
            end)
        end)

        on(158, function()
            Objects['mk-4-4']:with(function(a)
                a.outDestroy = true
            end)
        end)

        -------------------- mk-5 --------------------
        on(165, function()
            local f = random(11)
            MikuUtil.makeCircle(handX, handY, Objects['mk-5'], 16, 8, random(), function(a, i)
                a.frameIndex = f
            end)
        end)

        on(166, function()
            local f = random(11)
            MikuUtil.makeCircle(handX, handY, Objects['mk-5'], 16, 8, random(), function(a, i)
                a.frameIndex = f
            end)
        end)

        ranget(168, 171, 2, function()
            Objects['mk-5-1']:new(mouthX, mouthY):next(function(a)
                a.direction = 90 + random() * 45
                a.speed = 10 + random() * 5
                a.gravity = 0.3
            end)
        end)

        on(172, function()
            flag = 1
        end)

        on(173, 174, 175, 176, 177, function()
            Objects.Player:with(function(p)
                Objects['mk-5-2']:new(800, p.y):next(function(a)
                    a.hspeed = -1
                    a.friction = -0.4
                    a.flag = flag
                end)
            end)
            flag = flag + 1
        end)

        on(180, function()
            Objects.Player:with(function(p)
                Objects['mk-5-3']:new(p.x - 64, 0):next(function(a)
                    a.vspeed = 25
                    a.flag = 1
                end)
                Objects['mk-5-3']:new(p.x + 64, 0):next(function(a)
                    a.vspeed = 25
                    a.flag = 1
                    cx = p.x
                end)
            end)
        end)
        on(182, function()
            Objects.Player:with(function(p)
                Objects['mk-5-3']:new(0, p.y):next(function(a)
                    a.hspeed = 25
                    a.flag = 2
                end)
            end)
        end)
        on(184, function()
            Objects['mk-5-3-1']:with(function(a)
                if a.flag == 2 then
                    a.gravity = 0.4
                    a.gravityDirection = 90
                    a.vspeed = 8
                    a.warp = 1
                    a.outDestroy = false
                end
            end)
        end)
        on(187, function()
            Objects['mk-5-3-1']:with(function(a)
                if a.flag == 1 then
                    a.direction = math.pdir(a.x, a.y, cx, 304)
                    a.speed = 10
                end
            end)
        end)
        on(192, function()
            Objects['mk-5-3-1']:with(function(a)
                if a.flag == 2 then
                    a:exit()
                end
            end)
        end)

        -------------------- mk-6 --------------------
        -- 200, 201, 201.5, 202, 202.5
        on(197, 198, function()
            local f = random(11)
            Objects.Player:with(function(p)
                Objects['mk-6']:new(0, p.y):next(function(a)
                    for i = 0, 800, 26 do
                        Objects['mk-6']:new(i, p.y):next(function(b)
                            b.frameIndex = f
                        end)
                    end
                    for i = 0, 608, 26 do
                        Objects['mk-6']:new(p.x, i):next(function(b)
                            b.frameIndex = f
                        end)
                    end
                end)
            end)
        end)

        on(200, function()
            local f = random(11)
            for i = -200, 1200, 128 do
                for j = -200, 1000, 26 do
                    Objects['mk-6']:new(i, j):next(function(b)
                        b.frameIndex = f
                        b.flag = 1
                        b.outDestroy = false
                    end)
                end
            end
            for i = -200, 1000, 128 do
                for j = -200, 1000, 26 do
                    Objects['mk-6']:new(j, i):next(function(b)
                        b.frameIndex = f
                        b.flag = 1
                        b.outDestroy = false
                    end)
                end
            end
        end)

        on(201, 201.5, 202, function()
            Objects['mk-6']:with(function(a)
                a.x = a.x - 32
                a.y = a.y - 32
            end)

        end)

        on(202.5, function()
            Objects['mk-6']:with(function(a)
                a.x = a.x - 32
                a.y = a.y - 32
                a.flag = 0
            end)
        end)

        ranget(204, 210, 15, function()
            local f = random(11)
            MikuUtil.makeCircle(64 + random() * (800 - 64), 64 + random() * 64, Objects['mk-6-1'], 16, 5, random() *
                360, function(a)
                a.frameIndex = f
            end)
        end)

        on(212.5, function()
            MikuUtil.makeCircle(400, 304, Objects['mk-6-2'], 8, 14, 0, function(a, i)
                a.index = i
            end)
        end)

        on(213.5, function()
            MikuUtil.makeCircle(400, 304, Objects['mk-6-2'], 8, 14, 0 + 360 / 16, function(a, i)
                a.index = i + 8
            end)
        end)

        on(216, function()
            Objects['mk-6-2']:with(function(a)
                a.rotate = 1
            end)
        end)

        on(218, function()
            Objects['mk-6-2']:with(function(a)
                a.flag = 1
            end)
        end)

        ranget(223.5, 229, 3, function()
            Objects['mk-6-2']:with(function(a)
                a:shoot()
            end)
        end)

        on(229, function()
            MikuUtil.makeStarOutline(mouthX, mouthY, Objects['mk-6-4'], 3, 64, 30, random() * 360)
        end)

        ranget(224, 229.5, 3, function()
            Objects['mk-6-2']:with(function(a)
                a.flag = 3
            end)
        end)

        on(244, function()
            Objects['mk-6-4']:with(function(a)
                a.curve = -0.5 + random()
            end)
        end)

        on(250, function()
            Objects['mk-6-4']:with(function(a)
                a.friction = -0.01
            end)
        end)

        on(253, function()
            Objects['mk-6-4']:with(function(a)
                a.outDestroy = true
            end)
        end)

        on(266, function()
            Objects.BossItem:new(672, 544):next(function(a)
                a.itemNum = 1
            end)
            self:destroy()
        end)

    end

    function self:onDraw()
        -- Fonts.default:draw(16, 'Time: ' .. time, 32, 32, 100, 'left')
        -- Fonts.default:draw(16, 'Beat: ' .. math.round(beat), 32, 64, 100, 'left')
        self:drawSelf()
    end
end)
