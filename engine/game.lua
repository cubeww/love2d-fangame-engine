-- game.lua
-- control the game loop and encapsulate methods related to game management.

Game = {}

local nextTime

function Game:_load()
    -- initialize game properties
    self._newRoom = nil
    
    -- go to start room (defined in 'game.lua')
    self:_changeRoom(self.startRoom)

    nextTime = love.timer.getTime()
end

function Game:_update(dt)
    nextTime = nextTime + (1 / self.roomSpeed) -- roomSpeed is defined in 'game.lua'

    OrderedInstPool:update()
end

function Game:_draw()
    OrderedInstPool:draw()
    OrderedInstPool:clearRemoved()

    if self._newRoom then
        self:_changeRoom(self._newRoom)
        self._newRoom = nil
    end

    -- cap fps
    local curTime = love.timer.getTime()
    if nextTime <= curTime then
        nextTime = curTime
    end
    love.timer.sleep(nextTime - curTime)

    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()))
end


function Game:_changeRoom(roomName)
    local room = Rooms[roomName]
    if not room then
        return
    end

    -- destroy old instances
    for _, inst in ipairs(InstPool) do
        if not inst.persistent then
            inst:destroy()
        end
    end

    -- clean ordered instance pool
    OrderedInstPool:clearRemoved()

    -- change current room
    self.roomName = roomName
    
    -- create new instances
    for _, i in ipairs(room.instances) do
        local inst = Inst:new(i.object, i.x, i.y)

        -- execute creation function
        if i.onCreate then
            i.onCreate(inst)
        end
    end
end

-- ******************** public methods ********************
function Game:gotoRoom(roomName)
    self._newRoom = roomName
end
