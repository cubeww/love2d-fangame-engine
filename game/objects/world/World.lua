local World = Object:extends('World')

World:props({
    -- object properties
    visible = false,
    depth = 10001,
})

function World:onCreate()
    -- init globals
    love.window.setMode(800, 608)
    love.window.setTitle('I wanna play in Love2D!!!')

    -- Room:enter('rTitle')

    -- for i = 1, 5000, 1 do
    --     Inst:new('Player',math.random()*800,math.random()*608)
    -- end
    
end

function World:onUpdate()

end

function World:onDraw()

end
