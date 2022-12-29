-- game.lua
-- Control the game loop and encapsulate methods related to game management.

-- Recursively require all lua files in the **game** directory
local function requireAll(folder)
    for _, file in pairs(love.filesystem.getDirectoryItems(folder)) do
        local filePath = folder .. '/' .. file
        local t = love.filesystem.getInfo(filePath)
        if t.type == "file" and string.match(file, '.lua$') then
            local fn = string.sub(filePath, 1, -5)
            Game._loadingDir = folder
            Game._loadingFile = fn
            require(fn)
        elseif t.type == "directory" then
            requireAll(filePath)
        end
    end
end

Game = {}

requireAll('libs')
require('engine.color')
require('engine.object')
require('engine.instance')
require('engine.instancepool')
require('engine.collision')
require('engine.movement')
require('engine.room')
require('engine.sprite')
require('engine.input')
require('engine.sound')
require('engine.font')

local nextTime

function Game:_load()
    -- Record the currently loading lua file in order to make some loading.
    self._loadingDir = ''
    self._loadingFile = ''

    -- Load game scripts
    requireAll('game')

    -- Build rooms
    for _, room in pairs(Rooms) do
        room:build()
    end

    -- Initialize game properties
    self._newRoom = nil

    self.backgroundX = 0
    self.backgroundY = 0

    self.displayWidth = self.displayWidth or 800
    self.displayHeight = self.displayHeight or 608

    self.cameraX = 0
    self.cameraY = 0
    self.cameraWidth = 800
    self.cameraHeight = 608

    -- Go to start room (defined in 'game.lua')
    self:_changeRoom(Rooms[self.startRoomName])

    nextTime = love.timer.getTime()
end

function Game:_update(dt)
    XXOO = 0
    REMOVE = 0
    nextTime = nextTime + (1 / self.roomSpeed) -- roomSpeed is defined in 'game.lua'

    for inst in OrderedInstancePool:iter() do
        if inst.onUpdate then
            inst:onUpdate()
        end

        inst:updatePosition()
        inst:updateFrameIndex()
    end
end

function Game:_draw()
    love.graphics.push()

    love.graphics.translate(-self.cameraX, -self.cameraY)

    local bg = self.room.background

    -- Draw room background color
    if bg.color then
        love.graphics.setBackgroundColor({ bg.color[1] / 255, bg.color[2] / 255, bg.color[3] / 255 })
    else
        love.graphics.setBackgroundColor(Color.black)
    end

    -- Draw room background image
    if bg.loveImage then
        if bg.mode == 'tile' then
            love.graphics.draw(bg.loveImage, bg.loveQuad,
                -bg.width + (self.backgroundX - self.cameraX) % bg.width + self.cameraX,
                -bg.height + (self.backgroundY - self.cameraY) % bg.height + self.cameraY)
        else
            for j = -1, 1, 1 do
                for i = -1, 1, 1 do
                    love.graphics.draw(bg.loveImage,
                        i * Game.displayWidth + (self.backgroundX - self.cameraX) % Game.displayWidth + self.cameraX,
                        j * Game.displayHeight + (self.backgroundY - self.cameraY) % Game.displayHeight + self.cameraY
                        ,
                        0,
                        Game.displayWidth / bg.width, Game.displayHeight / bg.height)
                end
            end
        end
    end

    -- Draw instances
    OrderedInstancePool:sortDepth()

    local function drawInstance(inst)
        -- Draw instance
        if inst.visible then
            if inst.onDraw then
                inst:onDraw()
            else
                inst:drawSelf()
            end
        end
    end

    local function drawTileLayer(layer)
        -- Draw tile layer
        for _, tile in ipairs(layer) do
            love.graphics.draw(tile.loveImage, tile.loveQuad, tile.x, tile.y)
        end

    end

    local iter = OrderedInstancePool:iter()
    local inst = iter()

    local j = 1
    while inst and j <= #self.room.tileLayerDepths do
        local tileLayerDepth = self.room.tileLayerDepths[j]
        if inst.depth > tileLayerDepth then
            drawInstance(inst)
            inst = iter()
        else
            drawTileLayer(self.room.tileLayers[tileLayerDepth])
            j = j + 1
        end
    end

    while inst do
        drawInstance(inst)
        inst = iter()
    end

    while j <= #self.room.tileLayerDepths do
        local tileLayerDepth = self.room.tileLayerDepths[j]
        drawTileLayer(self.room.tileLayers[tileLayerDepth])
        j = j + 1
    end

    -- Clear removed instances form pools
    OrderedInstancePool:clearRemoved()

    -- Move background
    self.backgroundX = self.backgroundX + (bg.hspeed or 0)
    self.backgroundY = self.backgroundY + (bg.vspeed or 0)

    -- Change room check
    if self._newRoom then
        self:_changeRoom(self._newRoom)
        self._newRoom = nil
    end

    -- Clear input states
    Input:_clear()

    -- Limit frame rate
    local curTime = love.timer.getTime()
    if nextTime <= curTime then
        nextTime = curTime
    end
    love.timer.sleep(nextTime - curTime)

    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), self.cameraX, self.cameraY)
    love.graphics.print('Count: ' .. tostring(XXOO), self.cameraX, self.cameraY + 16)

    local count1 = 0
    for _, value in pairs(SpatialHash.cells) do
        for _, v1 in pairs(value) do
            count1 = count1 + 1
        end
    end
    love.graphics.print('XCount: ' .. tostring(count1), self.cameraX, self.cameraY + 32)
    love.graphics.print('REMOVE: ' .. tostring(REMOVE), self.cameraX, self.cameraY + 48)

    love.graphics.pop()
end

function Game:_changeRoom(room)
    if not room then
        return
    end

    -- Call onExitRoom method of every instance
    for inst in OrderedInstancePool:iter() do
        if inst.onExitRoom then
            inst:onExitRoom()
        end
    end

    -- Call onExit method of old room
    if self.room and self.room.onExit then
        self.room:onExit()
    end

    -- Destroy old instances
    OrderedInstancePool:destroyAndRemoveAll()

    -- Change current room
    self.room = room

    -- Create new instances
    for _, i in ipairs(room.instances) do
        local inst = Objects[i.object]:new(i.x, i.y)
        if inst then
            -- Call additional onCreate method of instance (instance creation code)
            if i.onCreate then
                i.onCreate(inst)
            end
        end
    end

    OrderedInstancePool:sortDepth()

    -- Call onEnterRoom method of every instance
    for inst in OrderedInstancePool:iter() do
        if inst.onEnterRoom then
            inst:onEnterRoom()
        end
    end

    -- Call onEnter method of new room
    if self.room.onEnter then
        self.room:onEnter()
    end
end

-- Public methods

function Game:gotoRoom(room)
    if room then
        self._newRoom = room
    end
end

function Game:restartRoom()
    self._newRoom = self.room
end

function Game:restartGame()
    require('game.game')
    self._newRoom = Rooms[startRoomName]
end
