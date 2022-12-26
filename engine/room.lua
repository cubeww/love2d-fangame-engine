-- room.lua
-- in-game room resource.

Room = {}

Rooms = {}

function Room.new(roomName, contents)
    local self = contents
    setmetatable(self, { __index = Room })

    self.name = roomName
    self.size = self.size or { 800, 608 }
    self.background = self.background or {}
    self.instances = self.instances or {}
    self.tiles = self.tiles or {}

    Rooms[roomName] = self

    return self
end

function Room:buildBackgroundImage()
    if not self.background.sprite then
        return
    end

    local loveImage = Sprites[self.background.sprite]:getFrame(0).loveImage
    loveImage:setWrap('repeat', 'repeat')
    self.background.loveImage = loveImage

    local w, h = loveImage:getWidth(), loveImage:getHeight()
    self.background.width, self.background.height = w, h

    self.background.mode = self.background.mode or 'tile'

    if self.background.mode == 'tile' then
        self.background.loveQuad = love.graphics.newQuad(0, 0,
            (math.floor(Game.displayWidth / w) + 2) * w,
            (math.floor(Game.displayHeight / h) + 2) * h,
            w, h)
    else
        -- stretch mode uses scale, no need to create additional quad
    end
end

-- Two things were done when building tiles: 
--   1. Putting tiles with the same depth together; 
--   2. Creating a love quad for each tile.
function Room:buildTiles()
    if not self.tiles then
        return
    end

    local orderedTiles = {}
    local tileQuads = {}

    for _, tile in pairs(self.tiles) do
        local depth = tile.depth or 0
        if not orderedTiles[depth] then
            orderedTiles[depth] = {}
        end

        table.insert(orderedTiles[depth], tile)

        local loveImage = Sprites[tile.sprite]:getFrame(0).loveImage
        tile.loveImage = loveImage

        local width, height = loveImage:getWidth(), loveImage:getHeight()
        local xo = tile.xo
        local yo = tile.yo
        local tileWidth = tile.w or width
        local tileHeight = tile.h or height

        -- key = loveImage,xo,yo,w,h
        local key = tostring(loveImage) .. ',' .. tostring(xo) .. ',' .. tostring(yo)
            .. ',' .. tostring(tileWidth) .. ',' .. tostring(tileHeight)

        if not tileQuads[key] then
            -- generate a new quad for tile
            local quad = love.graphics.newQuad(xo, yo, tileWidth, tileHeight, width, height)
            tile.loveQuad = quad
            tileQuads[key] = quad
        else
            -- just get the exists one
            tile.loveQuad = tileQuads[key]
        end
    end

    self.orderedTiles = orderedTiles
end

-- call this after all sprites are loaded
function Room:build()
    self:buildBackgroundImage()
    self:buildTiles()
end
