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

-- call this after all sprites are loaded
function Room:makeBackgroundImage()
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

