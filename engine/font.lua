-- sound.lua

Fonts = {}

Font = {}

local fontFormats = { '.ttf', '.otf' }

function Font.new(name, settings)
    settings = settings or {}
    local self = setmetatable({}, { __index = Font })

    self.name = name
    Fonts[name] = self

    local filename
    for _, ext in ipairs(fontFormats) do
        -- Search for font files with the same name
        if love.filesystem.getInfo(Game._loadingDir .. '/' .. self.name .. ext) then
            filename = Game._loadingDir .. '/' .. self.name .. ext
            break
        end
    end

    if filename then
        self.loveFonts = {}
        if type(settings.size) == 'table' then
            for _, s in ipairs(settings.size) do
                self.loveFonts[s] = love.graphics.newFont(filename, s)
            end
        elseif type(settings.size) == 'number' then
            self.loveFonts[settings.size] = love.graphics.newFont(filename, settings.size)
        else
            self.loveFonts[12] = love.graphics.newFont(filename, 12)
        end
    end
end

function Font:draw(size, text, x, y, width, align, color, alpha)
    local font = self.loveFonts[size]
    if font and text then
        x = x or 0
        y = y or 0
        width = width or 0
        align = align or 'left'
        color = color or Color.black
        alpha = alpha or 1

        local oldFont = love.graphics.getFont()
        local r, g, b, a = love.graphics.getColor()

        love.graphics.setFont(font)
        love.graphics.setColor(color[1] / 255, color[2] / 255, color[3] / 255, alpha or 1)

        love.graphics.printf(text, x, y, width, align)

        love.graphics.setFont(oldFont)
        love.graphics.setColor(r, g, b, a)
    end
end
