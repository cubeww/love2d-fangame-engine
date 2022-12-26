-- game.lua
-- control the game loop and encapsulate methods related to game management.

require('engine.color')
require('engine.object')
require('engine.instance')
require('engine.instancepool')
require('engine.collision')
require('engine.movement')
require('engine.room')
require('engine.sprite')
require('engine.input')

Game = {}

-- recursively require all lua files in the **game** directory
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

local nextTime

function Game:_load()
    -- record the currently loading lua file in order to make some loading.
    self._loadingDir = ''
    self._loadingFile = ''

    -- load game scripts
    requireAll('game')

    -- make room background image
    for _, room in pairs(Rooms) do
        room:makeBackgroundImage()
    end

    -- initialize game properties
    self._newRoomName = nil

    self.backgroundX = 0
    self.backgroundY = 0

    self.displayWidth = self.displayWidth or 800
    self.displayHeight = self.displayHeight or 608

    -- go to start room (defined in 'game.lua')
    self:_changeRoom(self.startRoomName)

    nextTime = love.timer.getTime()
end

function Game:_update(dt)
    nextTime = nextTime + (1 / self.roomSpeed) -- roomSpeed is defined in 'game.lua'

    OrderedInstancePool:update()
end

function Game:_draw()
    local bg = self.roomTarget.background

    -- draw room background color
    if bg.color then
        love.graphics.setBackgroundColor({ bg.color[1] / 255, bg.color[2] / 255, bg.color[3] / 255 })
    else
        love.graphics.setBackgroundColor(Color.black)
    end

    -- draw room background image
    if bg.loveImage then
        if bg.mode == 'tile' then
            love.graphics.draw(bg.loveImage, bg.loveQuad,
                -bg.width + self.backgroundX % bg.width,
                -bg.height + self.backgroundY % bg.height)
        else
            for j = -1, 1, 1 do
                for i = -1, 1, 1 do
                    love.graphics.draw(bg.loveImage,
                        i * Game.displayWidth + self.backgroundX % Game.displayWidth,
                        j * Game.displayHeight + self.backgroundY % Game.displayHeight, 0,
                        Game.displayWidth / bg.width, Game.displayHeight / bg.height)
                end
            end
        end
    end

    -- draw instances
    OrderedInstancePool:draw()
    OrderedInstancePool:clearRemoved()

    -- move background
    self.backgroundX = self.backgroundX + (bg.hspeed or 0)
    self.backgroundY = self.backgroundY + (bg.vspeed or 0)

    -- change room check
    if self._newRoomName then
        self:_changeRoom(self._newRoomName)
        self._newRoomName = nil
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

    -- call onExit method of old room
    if self.roomTarget and self.roomTarget.onExit then
        self.roomTarget:onExit()
    end

    -- destroy old instances
    OrderedInstancePool:destroyAndRemoveAll()

    -- change current room
    self.roomName = roomName
    self.roomTarget = room

    -- create new instances
    for _, i in ipairs(room.instances) do
        local inst = Instance.new(i.object, i.x, i.y)

        -- call additional onCreate method of instance
        if i.onCreate then
            i.onCreate(inst)
        end
    end

    -- call onEnter method of new room
    if self.roomTarget.onEnter then
        self.roomTarget:onEnter()
    end
end

-- ******************** public methods ********************
function Game:gotoRoom(roomName)
    if not Rooms[roomName] then
        return
    end

    self._newRoomName = roomName
end
