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
    love.filesystem.setIdentity('scripts')
    -- load modules
    
    -- 1. third party libraries
    requireAll('libs')

    -- 2. engine modules
    require('engine.init')

    -- 3. game modules
    requireAll('game')

    Game:_load()
end

function love.update(dt)
    Game:_update(dt)
end

function love.draw()
    Game:_draw()
end
