-- room.lua
-- in-game room resource.

Room = {}

Rooms = {}

CurrentRoom = nil
NewRoom = nil


function Room:extends(name)
    local room = {
        settings = {},
        instances = {},
        tiles = {},
    }

    setmetatable(room, { __index = self })
    room[name] = name

    Rooms[name] = room

    return room
end

function Room:setSettings(settings)
    self.width, self.height = settings.size[1], settings.size[2]
end

function Room:setInstances(instances)
    self.instances = instances
end

function Room:setTiles(tiles)
    self.tiles = tiles
end
