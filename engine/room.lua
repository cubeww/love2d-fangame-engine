Room = {}

Rooms = {}

CurrentRoom = nil

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

function Room:enter(roomName)
    local room = Rooms[roomName]

    -- destroy old instances
    for _, inst in ipairs(InstPool) do
        if not inst.persistent then
            inst:destroy()
        end
    end

    -- change current room
    CurrentRoom = roomName
    
    -- create new instances
    for _, i in ipairs(room.instances) do
        local inst = Inst:new(i.object, i.x, i.y)

        -- execute creation function
        if i.create then
            i.create(inst)
        end
    end
end