-- movement.lua
-- The movement functions of the instance.
-- Some are derived from Gamemaker HTML5, for consistency with the classic engine.

Movement = {}


-- Called when hspeed or vspeed is modified
function Instance:computeSpeedDirection()
    -- Compute direction
    if self._hspeed == 0 then
        if self._vspeed > 0 then
            self._direction = 270
        elseif self._vspeed < 0 then
            self._direction = 90
        else
            self._direction = 0
        end
    else
        local dd = math.atan2(self._vspeed, self._hspeed) * 180 / math.pi
        if dd <= 0 then
            self._direction = -dd
        else
            self._direction = 360 - dd
        end
    end

    if self._direction - math.round(self._direction) < 0.0001 then
        self._direction = math.round(self._direction) % 360
    end

    -- Compute speed
    self._speed = math.sqrt(math.pow(self._hspeed, 2) + math.pow(self._vspeed, 2))
    if math.abs(self._speed - math.round(self._speed)) < 0.0001 then
        self._speed = math.round(self._speed)
    end
end

-- Called when speed or direction is modified
function Instance:computeHVSpeed()
    self._hspeed = self._speed * math.cos(self._direction * 0.0174532925) -- 0.0174532925 <=> math.pi / 180
    self._vspeed = -self._speed * math.sin(self._direction * 0.0174532925)

    -- Round if close enough
    if math.abs(self._hspeed - math.round(self._hspeed)) < 0.0001 then
        self._hspeed = math.round(self._hspeed)
    end
    if math.abs(self._vspeed - math.round(self._vspeed)) < 0.0001 then
        self._vspeed = math.round(self._vspeed)
    end
end

function Instance:updatePosition()
    if self.friction ~= 0 then
        local newSpeed

        -- When the friction is positive, the direction of the friction is opposite to the direction of the speed
        if self._speed > 0 then
            newSpeed = self._speed - self.friction
        else
            newSpeed = self._speed + self.friction
        end

        -- Stops the instance if the speed drops to 0
        if self._speed > 0 and newSpeed < 0 or self._speed < 0 and newSpeed > 0 then
            self.speed = 0
        elseif self._speed ~= 0 then
            self.speed = newSpeed
        end
    end

    if self.gravity ~= 0 then
        -- Apply gravity
        self._hspeed = self._hspeed + self.gravity * math.cos(self.gravityDirection * 0.0174532925)
        self._vspeed = self._vspeed - self.gravity * math.sin(self.gravityDirection * 0.0174532925)
        Movement.computeSpeedDirection(self)
    end

    -- Update position
    if self._hspeed ~= 0 or self._vspeed ~= 0 then
        self.x = self.x + self._hspeed
        self.y = self.y + self._vspeed
    end
end
