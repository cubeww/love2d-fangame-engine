Object.extends('Player', function(self)
    self.visible = true
    self.persistent = true
    self.sprite = Sprites.sPlayerIdle
    self.mask = Sprites.sPlayerMask
    self.depth = -10

    local jump = 8.5 * World.grav
    local jump2 = 7 * World.grav
    local maxSpeed = 3
    local maxVspeed = 9
    local onPlatform = false

    local xprevious = 0
    local yprevious = 0

    self.frameSpeed = 0.2
    self.frozen = false
    self.gravity = 0.4 * World.grav
    self.djump = 1
    self.face = 1

    function self:onCreate()
        self:setMask()

        if World.gameStarted and World.difficulty == 0 then
            Objects.Bow:new(self.x, self.y)
        end

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
            b.hspeed = self.face * 16
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
        Objects.GameOver:new()
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

        local slipBlockTouching = self:placeMeeting(Objects.SlipBlock, self.x, self.y + World.grav)

        -- Vine checks
        local notOnBlock = not self:placeMeeting(Objects.Block, self.x, self.y + World.grav)
        local onVineL = self:placeMeeting(Objects.WalljumpL, self.x - 1, self.y) and notOnBlock
        local onVineR = self:placeMeeting(Objects.WalljumpR, self.x + 1, self.y) and notOnBlock

        if h ~= 0 then
            if not onVineL and not onVineR then
                self.face = h
            end
            if (h == -1 and not onVineR) or (h == 1 and not onVineL) then
                if not slipBlockTouching then
                    self.hspeed = maxSpeed * h
                else
                    self.hspeed = self.hspeed + slipBlockTouching.slip * h

                    if math.abs(self.hspeed) > maxSpeed then
                        self.hspeed = maxSpeed * h
                    end
                end

                self.sprite = Sprites.sPlayerRunning
                self.frameSpeed = 0.5
            end
        else
            if not slipBlockTouching then
                self.hspeed = 0
            else
                if self.hspeed > 0 then
                    self.hspeed = self.hspeed - slipBlockTouching.slip

                    if self.hspeed <= 0 then
                        self.hspeed = 0
                    end
                elseif self.hspeed < 0 then
                    self.hspeed = self.hspeed + slipBlockTouching.slip

                    if self.hspeed >= 0 then
                        self.hspeed = 0
                    end
                end
            end

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

        local slideBlockTouching = self:placeMeeting(Objects.SlideBlock, self.x, self.y + World.grav)
        if slideBlockTouching then
            self.hspeed = self.hspeed + slideBlockTouching.h
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
                self.face = -1
            else
                self.face = 1
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

    function self:setMask()
        if World.grav == 1 then
            self.mask = Sprites.sPlayerMask
        else
            self.mask = Sprites.sPlayerMaskFlip
        end
    end

    function self:flipGrav()
        World.grav = -World.grav

        self.djump = 1
        self.vspeed = 0

        jump = math.abs(jump) * World.grav
        jump2 = math.abs(jump2) * World.grav

        self.gravity = math.abs(self.gravity) * World.grav

        self:setMask()

        self.y = self.y + 4 * World.grav
    end

    function self:onAfterUpdate()
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
                if self.y - self.vspeed / 2 >= platform.y + platform.frame.size.height - 1 then
                    if platform.yspeed <= 0 then
                        self.y = platform.y + platform.frame.size.height + 8
                        self.vspeed = platform.yspeed
                    end

                    onPlatform = true
                    self.djump = 1
                end
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

        -- Gravity arrow check
        if self:placeMeeting(Objects.GravityUp) then
            if World.grav == 1 then
                self:flipGrav()
            end
        end

        if self:placeMeeting(Objects.GravityDown) then
            if World.grav == -1 then
                self:flipGrav()
            end
        end

        -- Jump refresher check
        local jr = self:placeMeeting(Objects.JumpRefresher)
        if jr then
            jr:take()
            self.djump = 1
        end

        -- Killer check
        if self:placeMeeting(Objects.PlayerKiller, self.x, self.y) then
            self:kill()
        end

        -- Edge death
        if self.x < 0 or self.y > Game.room.height or self.y < 0 or self.x > Game.room.width then
            self:kill()
        end
    end

    function self:onDraw()
        local drawY = self.y

        if World.grav == -1 then
            drawY = drawY + 1
        end

        self.sprite:draw(self.frameIndex, self.x, drawY, self.face, World.grav)
    end

    function self:onDestroy()
        Objects.Bow:with(function(i)
            i:destroy()
        end)
    end
end)
