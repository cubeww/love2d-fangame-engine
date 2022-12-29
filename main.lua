require('engine.game')

function love.load()
    Game:_load()
end

function love.update(dt)
    Game:_update(dt)
end

function love.draw()
    Game:_draw()
end

function love.keypressed(key)
    Input:_pressed(key)
end

function love.keyreleased(key)
    Input:_released(key)
end

function love.mousepressed(_, _, button)
    Input:_pressed(button)
end

function love.mousereleased(_, _, button)
    Input:_released(button)
end
