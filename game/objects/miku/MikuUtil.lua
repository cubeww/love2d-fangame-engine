MikuUtil = {}

function MikuUtil.makeCircle(x, y, obj, num, speed, angle, callback)
    for i = 1, num, 1 do
        local a = obj:new(x, y)
        a.speed = speed
        a.direction = angle + i * 360 / num

        if callback then
            callback(a, i)
        end
    end
end

function MikuUtil.makeStar(x, y, obj, num, rad, speed, angle, callback)
    local points = {}
    -- Compute points
    for i = 1, 5, 1 do
        points[i] = {}
        points[i].x, points[i].y = math.ldir(x, y, rad, angle + 360 / 5 * (i - 1) + 90)
    end

    -- Make lines
    local indices = { 1, 3, 5, 2, 4, 1 }
    for i = 1, 5, 1 do
        local p1 = points[indices[i]]
        local p2 = points[indices[i + 1]]
        for j = 0, num - 1, 1 do
            local xx = p1.x + (p2.x - p1.x) / num * j
            local yy = p1.y + (p2.y - p1.y) / num * j
            local a = obj:new(x, y)
            a.hspeed = (xx - x) / speed
            a.vspeed = (yy - y) / speed

            if callback then
                callback(a, j)
            end
        end
    end
end

function MikuUtil.makeStarOutline(x, y, obj, num, rad, speed, angle, callback)
    local outrad = rad * math.sin(126 * math.pi / 180) / math.sin(18 * math.pi / 180)

    -- Make each corner
    for i = 1, 5, 1 do
        local dir = (i - 1) * 72 + angle
        local x1, y1 = math.ldir(x, y, outrad, dir)

        for j = 0, 1, 1 do
            local x2, y2 = math.ldir(x, y, rad, dir - 36 + 72 * j)
            for k = 0, num, 1 do
                local xx = x1 + (x2 - x1) / num * k
                local yy = y1 + (y2 - y1) / num * k

                local a = obj:new(x, y)
                a.hspeed = (xx - x) / speed
                a.vspeed = (yy - y) / speed

                if callback then
                    callback(a, k)
                end
            end
        end
    end
end

function MikuUtil.rotateAround(inst, x, y, angle)
    inst.x = (inst.x - x) * math.cos(angle * math.pi / 180) + (inst.y - y) * math.sin(angle * math.pi / 180) + x
    inst.y = (inst.x - x) * -math.sin(angle * math.pi / 180) + (inst.y - y) * math.cos(angle * math.pi / 180) + y
end
