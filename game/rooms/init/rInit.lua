local rInit = Room:extends('rInit')

rInit:setSettings({
    size = { 800, 608 },
})

rInit:setInstances({
    { x = 0, y = 0, object = 'World'},
    { x = 400, y = 304, object = 'Player'},
    { x = 400, y = 333, object = 'SpikeUp'},

})