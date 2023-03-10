-- sprite.lua
-- The sprite of object.

Sprite = {}

Sprites = {}

function Sprite.new(name, settings)
    local self = setmetatable({}, { __index = Sprite })

    self.name = name
    Sprites[name] = self

    settings = settings or {}
    -- Load sprite with settings
    if not settings.mode or settings.mode == 'sheet' then
        local col = settings.col or 1
        local row = settings.row or 1

        local bbox = settings.bbox or false

        -- Get the bounding box by default
        if bbox ~= false then
            bbox = true
        end

        local filename

        -- Search for image files with the same name
        if love.filesystem.getInfo(Game._loadingDir .. '/' .. self.name .. '.png') then
            filename = Game._loadingDir .. '/' .. self.name .. '.png'
        elseif love.filesystem.getInfo(Game._loadingDir .. '/' .. self.name .. '.jpg') then
            filename = Game._loadingDir .. '/' .. self.name .. '.jpg'
        end

        -- Load image file
        local imgData = love.image.newImageData(filename)

        -- Get width / height of sprite sheet
        local sheetWidth = imgData:getWidth()
        local sheetHeight = imgData:getHeight()

        -- Compute width / height of single image
        local w = sheetWidth / col
        local h = sheetHeight / row

        -- Compute x / y origin
        local xorigin, yorigin

        if type(settings.origin) == 'table' then
            -- 1. Custom origin
            xorigin, yorigin = settings.origin[1], settings.origin[2]
        elseif type(settings.origin) == 'string' then
            -- 2. Auto origin
            if settings.origin == 'center' then
                xorigin = math.floor(w / 2)
                yorigin = math.floor(h / 2)
            elseif settings.origin == 'topleft' then
                xorigin = 0
                yorigin = 0
            elseif settings.origin == 'topright' then
                xorigin = w
                yorigin = 0
            elseif settings.origin == 'middleleft' then
                xorigin = 0
                yorigin = math.floor(h / 2)
            elseif settings.origin == 'middleright' then
                xorigin = w
                yorigin = math.floor(h / 2)
            elseif settings.origin == 'bottomleft' then
                xorigin = 0
                yorigin = h
            elseif settings.origin == 'bottomright' then
                xorigin = w
                yorigin = h
            elseif settings.origin == 'topcenter' then
                xorigin = math.floor(w / 2)
                yorigin = 0
            elseif settings.origin == 'bottomcenter' then
                xorigin = math.floor(w / 2)
                yorigin = h
            end
        else
            -- 3. Default origin: top left
            xorigin = 0
            yorigin = 0
        end

        local loveImageData = imgData
        local loveImage = love.graphics.newImage(imgData)

        -- Create sprite frames
        self.frames = {}
        for y = 0, row - 1, 1 do
            for x = 0, col - 1, 1 do
                local frame = {}

                frame.loveImage = loveImage
                frame.loveImageData = loveImageData

                -- Generate quad
                frame.loveQuad = love.graphics.newQuad(x * w, y * h, w, h, sheetWidth, sheetHeight)

                -- Set size & origin
                frame.size = { width = w, height = h }
                frame.origin = { x = xorigin, y = yorigin }

                -- Generate bounding box data
                if bbox then
                    local l = w - 1
                    local r = 0
                    local t = h - 1
                    local b = 0
                    local d = {}

                    -- Traverse each pixel to get the bounding box and collision mask data
                    for yy = 0, h - 1, 1 do
                        for xx = 0, w - 1, 1 do
                            local _, _, _, a = imgData:getPixel(x * w + xx, y * h + yy)
                            if a ~= 0 then
                                table.insert(d, true)
                                l = math.min(l, xx)
                                r = math.max(r, xx)
                                t = math.min(t, yy)
                                b = math.max(b, yy)
                            else
                                table.insert(d, false)
                            end
                        end
                    end

                    frame.bbox = {
                        size = frame.size,
                        origin = frame.origin,

                        left = l,
                        right = r,
                        top = t,
                        bottom = b,

                        data = d,
                    }
                else
                    frame.bbox = false
                end

                -- Finally, insert to sprite.frames
                table.insert(self.frames, frame)
            end
        end
    elseif settings.mode == 'folder' then
        -- TODO: Create a sprite from multiple image files in a folder with the same name
    end
end

function Sprite:getFrame(index)
    return self.frames[math.floor(index % #self.frames) + 1]
end

function Sprite:draw(index, x, y, xscale, yscale, angle, color)
    local frame = self:getFrame(index)
    angle = angle or 0
    color = color or { 1, 1, 1, 1 }
    love.graphics.setColor(color[1], color[2], color[3], color[4])
    love.graphics.draw(frame.loveImage, frame.loveQuad,
        math.round(x), math.round(y), math.rad(angle), xscale, yscale,
        frame.origin.x, frame.origin.y)
end
