-- https://stackoverflow.com/questions/18313171/lua-rounding-numbers-and-then-truncate
function math.round(num)
    return num + (2 ^ 52 + 2 ^ 51) - (2 ^ 52 + 2 ^ 51)
end

