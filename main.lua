-- the lua script file currently being loaded is used for some judgments
LoadingDir = ''
LoadingFile = ''

-- recursively require all lua files in the directory
function requireAll(folder, exclude)
    for _, file in pairs(love.filesystem.getDirectoryItems(folder)) do
        local filePath = folder .. '/' .. file
        local t = love.filesystem.getInfo(filePath)
        if t.type == "file" and string.match(file, '.lua$') then
            local fn = string.sub(filePath, 1, -5)
            if fn ~= exclude then
                LoadingDir = folder
                LoadingFile = fn
                require(fn)
            end
        elseif t.type == "directory" then
            requireAll(filePath, exclude)
        end
    end
end

function love.load()
    -- load modules
    
    -- 1. third party libraries
    requireAll('libs')

    -- 2. engine modules
    require('engine.init')

    -- 3. game modules
    requireAll('game')

    -- go to start room (defined in 'game.lua')
    Room:enter(StartRoom)

    nextTime = love.timer.getTime()
end

function love.update(dt)
    nextTime = nextTime + (1 / RoomSpeed) -- RoomSpeed is defined in 'game.lua'

    InstPool:update()
end

function love.draw()
    love.graphics.print('FPS: '..tostring(love.timer.getFPS()))

    InstPool:draw()
    InstPool:clean()

    -- cap fps
    local curTime = love.timer.getTime()
    if nextTime <= curTime then
        nextTime = curTime
    end
    love.timer.sleep(nextTime - curTime)
end
