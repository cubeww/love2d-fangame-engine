Room.new('rInit', {
    size = { 800, 608 },

    background = {
        color = { 128, 255, 255 },
        sprite = 'k3s5',
        mode = 'tile',
        hspeed = 1,
        vspeed = 1,
    },

    instances = {
        { x = 0, y = 0, object = 'World', onCreate = function() end },
        { x = 400, y = 304, object = 'Player', onCreate = function() end },
    },

    tiles = {
        { x = 0, y = 0, sprite = 'sAllTiles', xo = 32, yo = 32, w = 32, h = 32, depth = 100000 }
    },

    onEnter = function()
        print('enter rInit!')
    end,

    onExit = function()
        print('exit rInit!')
    end,
})
