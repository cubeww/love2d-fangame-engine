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
        { object = 'World', x = 0, y = 0, onCreate = function() end },
        { object = 'Player', x = 400, y = 304, onCreate = function() end },
    },

    tiles = {
        { sprite = 'sAllTiles', x = 32, y = 0, xo = 32, yo = 0, w = 32, h = 32, depth = 1000000 },
        { sprite = 'sAllTiles', x = 32, y = 0, xo = 32, yo = 0, w = 32, h = 32, depth = 1000000 },
        { sprite = 'sAllTiles', x = 64, y = 0, xo = 32, yo = 0, w = 32, h = 32, depth = 1000000 },
        { sprite = 'sAllTiles', x = 96, y = 0, xo = 32, yo = 0, w = 32, h = 32, depth = 1000000 },
        { sprite = 'sAllTiles', x = 128, y = 0, xo = 32, yo = 0, w = 32, h = 32, depth = 1000000 },
        { sprite = 'sAllTiles', x = 160, y = 0, xo = 32, yo = 0, w = 32, h = 32, depth = 1000000 },
    },

    onEnter = function()
        print('enter rInit!')
    end,

    onExit = function()
        print('exit rInit!')
    end,
})
