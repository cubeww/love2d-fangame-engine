require('engine.game')

function love.load()
    love.filesystem.setIdentity('scripts')

    Game:_load()
end

function love.update(dt)
    Game:_update(dt)
end

function love.draw()
    Game:_draw()
end
