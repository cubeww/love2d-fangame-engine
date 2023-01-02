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

    -- Set save data folder
    love.filesystem.setIdentity(self.name)

    love.graphics.setDefaultFilter('nearest', 'nearest', 1)

    -- Build rooms
    for _, room in pairs(Rooms) do
        room:build()
    end

    -- Initialize game properties
    self._newRoom = nil

    self.showDebugText = false

    self.backgroundX = 0
    self.backgroundY = 0

    self.displayWidth = self.displayWidth or 800
    self.displayHeight = self.displayHeight or 608

    self.cameraX = 0
    self.cameraY = 0
    self.cameraWidth = 800
    self.cameraHeight = 608

    self.windowScaleX = 1
    self.windowScaleY = 1

    -- Go to start room (defined in 'game.lua')
    self:_changeRoom(Rooms[self.startRoomName])

    nextTime = love.timer.getTime()
end

function Game:_update(dt)
    nextTime = nextTime + (1 / self.roomSpeed) -- roomSpeed is defined in 'game.lua'

    if not self._newRoom then
        for inst in OrderedInstancePool:iter() do
            if inst.onUpdate then
                inst:onUpdate()
            end

            inst:updatePosition()
            inst:updateFrameIndex()
        end
    end

    if not self._newRoom then
        for inst in OrderedInstancePool:iter() do
            if inst.onAfterUpdate then
                inst:onAfterUpdate()
            end
        end
    end

end

function Game:_draw()
    love.graphics.push()

    love.graphics.scale(self.windowScaleX, self.windowScaleY)

    local cx = math.round(self.cameraX)
    local cy = math.round(self.cameraY)

    love.graphics.translate(-cx, -cy)

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
                -bg.width + (self.backgroundX - cx) % bg.width + cx,
                -bg.height + (self.backgroundY - cy) % bg.height + cy)
        else
            for j = -1, 1, 1 do
                for i = -1, 1, 1 do
                    love.graphics.draw(bg.loveImage,
                        i * Game.displayWidth + (self.backgroundX - cx) % Game.displayWidth + cx,
                        j * Game.displayHeight + (self.backgroundY - cy) % Game.displayHeight + cy,
                        0,
                        Game.displayWidth / bg.width, Game.displayHeight / bg.height)
                end
            end
        end
    end

    -- Sort all instances that have not been depth-sorted
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

    -- Draw instances and tiles by depth.
    -- This part is very ugly and may be modified in the future...

    -- Example: (Number is depth value)
    -- Instances: (10) (9) (8) (5) (2)
    -- Tile Layers: [11] [9] [6] [3]

    -- Will draw:
    -- [11] (10) [9] (9) (8) [6] (5) [3] (2)

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
    end

    -- Clear input states
    Input:_clear()

    -- Limit frame rate
    local curTime = love.timer.getTime()
    if nextTime <= curTime then
        nextTime = curTime
    end
    love.timer.sleep(nextTime - curTime)

    love.graphics.pop()

    local yy = 0
    local function debugText(text)
        love.graphics.setColor(Color.red)
        love.graphics.printf(text, 4, yy, 800, 'left')
        yy = yy + 16
        love.graphics.setColor(Color.white)
    end

    if self.showDebugText then
        debugText('FPS: ' .. tostring(love.timer.getFPS()))
        debugText('Memory (kB): ' .. math.floor(collectgarbage('count')))
        debugText('Inst: ' .. #OrderedInstancePool.pool)

        local pn = 0
        for _, o in pairs(Objects) do
            pn = pn + #o.instancePool.pool + #o.recursiveInstancePool.pool
        end
        debugText('PoolTotal: ' .. pn)
    end
end

-- Enter a room immediately. For internal use only. Use Game:gotoRoom in game instead.
function Game:_changeRoom(room)
    if not room then
        return
    end

    self._newRoom = nil
    self.cameraX = 0
    self.cameraY = 0

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
    OrderedInstancePool:destroyAndRemoveAll(false)

    -- Change current room
    self.room = room

    -- Create new instances
    for _, i in ipairs(room.instances) do
        -- We want the instances to be sorted when creating a room instance.
        local inst = Objects[i.object]:_insertNew(i.x, i.y, true)
        if inst then
            -- Call additional onCreate method of instance (instance creation code)
            if i.onCreate then
                i.onCreate(inst)
            end
        end
    end

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

function Game:toggleFullscreen()
    -- TODO: Keep aspect ratio in full screen
    local isFullscreen = love.window.getFullscreen()
    if not isFullscreen then
        love.window.setFullscreen(true, 'desktop')
    else
        love.window.setFullscreen(false)
    end

    self.windowScaleX = love.graphics.getWidth() / 800
    self.windowScaleY = love.graphics.getHeight() / 608
end
