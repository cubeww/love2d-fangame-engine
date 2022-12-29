Object.extends('Player', function(self)
    self.visible = true
    self.depth = -10
    self.persistent = true
    self.sprite = Sprites.sPlayerIdle
    self.mask = Sprites.sPlayerMask

    local jump = 8.5 * World.grav
    local jump2 = 7 * World.grav
    local maxSpeed = 3
    local maxVspeed = 9
    local onPlatform = false
    local face = 1

    local xprevious = 0
    local yprevious = 0

    self.frameSpeed = 0.2
    self.frozen = false
    self.gravity = 0.4
    self.djump = 1

    function self:onCreate()
        if World.autosave then
            World:saveGame(true)
        end
    end

    function self:jump()
        if self:placeMeeting(Objects.Block, self.x, self.y + World.grav) or
            self:placeMeeting(Objects.Platform, self.x, self.y + World.grav) or
            self:placeMeeting(Objects.Water, self.x, self.y + World.grav) or
            onPlatform then

            self.vspeed = -jump
            self.djump = 1
            Sounds.sndJump:play()

        elseif self.djump == 1 or self:placeMeeting(Objects.Water2, self.x, self.y + World.grav) then
            self.vspeed = -jump2
            self.sprite = Sprites.sPlayerJump
            Sounds.sndDJump:play()

            if not self:placeMeeting(Objects.Water3, self.x, self.y + World.grav) then
                -- Take away the player's double jump
                self.djump = 0
            else
                -- Replenish self.djump if touching water3
                self.djump = 1
            end
        end
    end

    function self:vjump()
        if self.vspeed * World.grav < 0 then
            self.vspeed = self.vspeed * 0.45
        end
    end

    function self:shoot()
        if #Objects.Bullet:collect() < 4 then
            local b = Objects.Bullet:new(self.x, self.y)
            b.hspeed = face * 16
            Sounds.sndShoot:play()
        end
    end

    function self:kill()
        if Game.room == Rooms.rDifficultySelect then
            self:destroy()
            Game:restartRoom()

            return
        end

        Sounds.sndDeath:play()

        Objects.BloodEmitter:new(self.x, self.y)
        self:destroy()

        World.death = World.death + 1
    end

    function self:onUpdate()
        xprevious = self.x
        yprevious = self.y

        -- Check left/right button presses
        local L = Input:held('left')
        local R = Input:held('right')

        local h = 0
        if not self.frozen then
            if R then
                h = 1
            elseif L then
                h = -1
            end
        end

        -- Vine checks
        local notOnBlock = self:placeMeeting(Objects.Block, self.x, self.y + World.grav)
        local onVineL = self:placeMeeting(Objects.WalljumpL, self.x - 1, self.y) and notOnBlock
        local onVineR = self:placeMeeting(Objects.WalljumpR, self.x + 1, self.y) and notOnBlock

        if h ~= 0 then
            if not onVineL and not onVineR then
                face = h
            end
            if (h == -1 and not onVineR) or (h == 1 and not onVineL) then
                self.hspeed = maxSpeed * h
                self.sprite = Sprites.sPlayerRunning
                self.frameSpeed = 0.5
            end
        else
            self.hspeed = 0
            self.sprite = Sprites.sPlayerIdle
            self.frameSpeed = 0.2
        end

        if not onPlatform then
            if self.vspeed * World.grav < -0.05 then
                self.sprite = Sprites.sPlayerJump
            elseif self.vspeed * World.grav > 0.05 then
                self.sprite = Sprites.sPlayerFall
            end
        else
            if not self:placeMeeting(Objects.Platform, self.x, self.y + 4 * World.grav) then
                onPlatform = false
            end
        end

        if math.abs(self.vspeed) > maxVspeed then
            self.vspeed = self.vspeed / math.abs(self.vspeed) * maxVspeed
        end

        if not self.frozen then
            if Input:pressed('z') then
                self:shoot()
            end
            if Input:pressed('lshift') or Input:pressed('rshift') then
                self:jump()
            end
            if Input:released('lshift') or Input:released('rshift') then
                self:vjump()
            end
            if Input:pressed('q') then
                self:kill()
            end
        end

        -- Walljumps
        if onVineL or onVineR then
            if onVineR then
                face = -1
            else
                face = 1
            end

            self.vspeed = 2 * World.grav
            self.sprite = Sprites.sPlayerSliding
            self.frameSpeed = 0.5

            -- Pressed away from the vine
            if (onVineL and Input:pressed('right')) or (onVineR and Input:pressed('left')) then
                if Input:held('lshift') or Input:held('rshift') then -- jumping off vine
                    if onVineR then
                        self.hspeed = -15
                    else
                        self.hspeed = 15
                    end

                    self.vspeed = -9 * World.grav
                    Sounds.sndWalljump:play()
                    self.sprite = Sprites.sPlayerJump
                else -- moving off vine
                    if onVineR then
                        self.hspeed = -3
                    else
                        self.hspeed = 3
                    end

                    self.sprite = Sprites.sPlayerFall
                end
            end
        end
    end

    local updatePosition = self.updatePosition

    function self:updatePosition()
        -- Override the internal update position method
        updatePosition(self)

        -- Platform check
        local platform = self:placeMeeting(Objects.Platform, self.x, self.y)
        if platform then
            if World.grav == 1 then
                if self.y - self.vspeed / 2 <= platform.y then
                    if platform.vspeed >= 0 then
                        self.y = platform.y - 9
                        self.vspeed = platform.vspeed
                    end

                    onPlatform = true
                    self.djump = 1
                end
            else
                -- TODO: platform flipped check
            end
        end

        -- Water check
        local water1 = self:placeMeeting(Objects.Water)
        local water2 = self:placeMeeting(Objects.Water2)
        local water3 = self:placeMeeting(Objects.Water3)

        if water1 or water2 or water3 then
            if water1 or water3 then
                self.djump = 1
            end

            if self.vspeed * World.grav > 2 then
                self.vspeed = 2 * World.grav
            end
        end


        -- Block check
        if self:placeMeeting(Objects.Block, self.x, self.y) then
            self.x = xprevious
            self.y = yprevious

            if self:placeMeeting(Objects.Block, self.x + self.hspeed, self.y) then
                if World.grav == 1 then
                    if self.hspeed <= 0 then
                        self:moveContact(Objects.Block, 180, math.abs(self.hspeed))
                    end
                    if self.hspeed > 0 then
                        self:moveContact(Objects.Block, 0, math.abs(self.hspeed))
                    end
                else
                    if self.hspeed < 0 then
                        self:moveContact(Objects.Block, 180, math.abs(self.hspeed))
                    end
                    if self.hspeed >= 0 then
                        self:moveContact(Objects.Block, 0, math.abs(self.hspeed))
                    end
                end
                self.hspeed = 0
            end

            if self:placeMeeting(Objects.Block, self.x, self.y + self.vspeed) then
                if World.grav == 1 then
                    if self.vspeed <= 0 then
                        self:moveContact(Objects.Block, 90, math.abs(self.vspeed))
                    end
                    if self.vspeed > 0 then
                        self:moveContact(Objects.Block, 270, math.abs(self.vspeed))
                        self.djump = 1
                    end
                else
                    if self.vspeed <= 0 then
                        self:moveContact(Objects.Block, 90, math.abs(self.vspeed))
                        self.djump = 1
                    end
                    if self.vspeed > 0 then
                        self:moveContact(Objects.Block, 270, math.abs(self.vspeed))
                    end
                end
                self.vspeed = 0
            end

            if self:placeMeeting(Objects.Block, self.x + self.hspeed, self.y + self.vspeed) then
                self.hspeed = 0
            end

            self.x = self.x + self.hspeed
            self.y = self.y + self.vspeed
        end

        -- Killer check
        if self:placeMeeting(Objects.SpikeUp, self.x, self.y) then
            self:kill()
        end
    end

    function self:onDraw()
        self.sprite:draw(self.frameIndex, self.x, self.y, face, World.grav)
    end
end)
