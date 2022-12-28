-- sound.lua

Sounds = {}

Sound = {}

local soundFormats = { '.wav', '.mp3', '.ogg', '.flac' }

function Sound.new(name, settings)
    settings = settings or {}
    local self = setmetatable({}, { __index = Sound })

    self.name = name
    Sounds[name] = self

    local filename, type
    for _, ext in ipairs(soundFormats) do
        -- Search for sound files with the same name
        if love.filesystem.getInfo(Game._loadingDir .. '/' .. self.name .. ext) then
            filename = Game._loadingDir .. '/' .. self.name .. ext
            type = settings.type or 'static'
        end
    end

    if filename then
        self.loveSource = love.audio.newSource(filename, type)
    end
end

function Sound:play(loop)
    local src = self.loveSource:clone()
    src:setLooping(loop or false)
    src:play()
    return src
end
