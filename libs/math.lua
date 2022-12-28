-- https://stackoverflow.com/questions/18313171/lua-rounding-numbers-and-then-truncate
function math.round(num)
    return num + (2 ^ 52 + 2 ^ 51) - (2 ^ 52 + 2 ^ 51)
end

function math.clamp(x, min, max)
    if x < min then return min end
    if x > max then return max end
    return x
end