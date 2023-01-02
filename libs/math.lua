-- https://stackoverflow.com/questions/18313171/lua-rounding-numbers-and-then-truncate
function math.round(num)
    return num + (2 ^ 52 + 2 ^ 51) - (2 ^ 52 + 2 ^ 51)
end

function math.clamp(x, min, max)
    if x < min then return min end
    if x > max then return max end
    return x
end

function math.choose(...)
    local args = { ... }
    return args[math.random(1, #args)]
end

function math.ldir(x, y, len, dir)
    return x + len * math.cos(dir * math.pi / 180), y + len * -math.sin(dir * math.pi / 180)
end

function math.pdir(x1, y1, x2, y2)
    local dd = math.atan2(y1 - y2, x1 - x2) * 180 / math.pi
    if dd < 0 then
        return -dd + 180
    else
        return 360 - dd + 180
    end
end
