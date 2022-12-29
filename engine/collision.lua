-- collision.lua
-- All methods related to collision detection.

-- It might be faster to make the math function a local variable? idk...
local sin = math.sin
local cos = math.cos
local floor = math.floor
local round = math.round
local pi = math.pi
local max = math.max
local min = math.min


-- Prepare for compute bounding box & transform point
function Transform:prepare(xo, yo)
    self.xo = xo
    self.yo = yo
    self.rxs = 1 / self.xscale
    self.rys = 1 / self.yscale
    self.st = 0
    self.ct = 1
    if self.angle ~= 0 then
        local rad = self.angle * 0.0174532925 -- 0.0174532925 <=> pi / 180
        self.st = sin(rad)
        self.ct = cos(rad)
    end
end

-- Transform a local bounding box to a global bounding box.
-- Used to compute instance bounding box
function Transform:transformRect(left, right, top, bottom)
    local l, r, t, b
    if self.angle == 0 then
        -- Simple version
        l = round(self.x + self.xscale * (left - self.xo))
        r = round(self.x + self.xscale * (right - self.xo + 1) - 1)

        if l > r then
            l, r = r, l
        end

        t = round(self.y + self.yscale * (top - self.yo))
        b = round(self.y + self.yscale * (bottom - self.yo + 1) - 1)

        if t > b then
            t, b = b, t
        end
    else
        -- Complex version
        local xmin = self.xscale * (left - self.xo)
        local xmax = self.xscale * (right - self.xo + 1) - 1


        local ymin = self.yscale * (top - self.yo)
        local ymax = self.yscale * (bottom - self.yo + 1) - 1

        local ctxmax = self.ct * xmax
        local ctxmin = self.ct * xmin
        local stymax = self.st * ymax
        local stymin = self.st * ymin

        if ctxmax < ctxmin then
            ctxmax, ctxmin = ctxmin, ctxmax
        end

        if stymax < stymin then
            stymax, stymin = stymin, stymax
        end

        l = round(self.x + ctxmin + stymin)
        r = round(self.x + ctxmax + stymax)

        local ctymax = self.ct * ymax
        local ctymin = self.ct * ymin
        local stxmax = self.st * xmax
        local stxmin = self.st * xmin
        if ctymax < ctymin then
            ctymin, ctymax = ctymax, ctymin
        end
        if stxmax < stxmin then
            stxmin, stxmax = stxmax, stxmin
        end

        t = round(self.y + ctymin - stxmax)
        b = round(self.y + ctymax - stxmin)
    end

    return l, r, t, b
end

-- Transform a local coordinate to global coordinate.
-- Doesn't seem to be very useful, since computing the bounding box uses a more efficient method.
function Transform:transformPoint(x, y)
    local xx = round(((x - self.xo) * self.ct + (y - self.yo) * self.st) * self.xs + self.x)
    local yy = round(((x - self.xo) * -self.st + (y - self.yo) * self.ct) * self.ys + self.y)
    return xx, yy
end

-- Transform global coordinate to local coordinate.
-- This is very useful for precise collision detection.
function Transform:inversePoint(x, y)
    local xx = round(((x - self.x) * self.ct - (y - self.y) * self.st) * self.rxs + self.xo)
    local yy = round(((x - self.x) * self.st + (y - self.y) * self.ct) * self.rys + self.yo)
    return xx, yy
end

-- Computes the bounding box of the instance and stores the transform state into the given transform.
REMOVE=0
function Instance:computeBoundingBox()
    REMOVE=REMOVE+1
    if not self.mask then
        return
    end

    -- Get the local bounding box of frame
    local localbbox = self.maskFrame.bbox
    if not localbbox then
        return
    end

    self.transform:prepare(localbbox.origin.x, localbbox.origin.y)

    -- Compute bounding box
    self.bbox.left, self.bbox.right, self.bbox.top, self.bbox.bottom = self.transform:transformRect(
        localbbox.left, localbbox.right, localbbox.top, localbbox.bottom)

    self.bbox.localbbox = localbbox
end

local function preciseCollision(inst1, inst2)
    if not inst1.bbox or not inst2.bbox then
        return false
    end

    local localbbox1 = inst1.bbox.localbbox
    local localbbox2 = inst2.bbox.localbbox

    if not localbbox1 or not localbbox2 then
        return false
    end

    -- Get bounding box intersection
    local l = max(inst1.bbox.left, inst2.bbox.left)
    local r = min(inst1.bbox.right, inst2.bbox.right)
    local t = max(inst1.bbox.top, inst2.bbox.top)
    local b = min(inst1.bbox.bottom, inst2.bbox.bottom)

    for j = t, b, 1 do
        for i = l, r, 1 do
            -- Check for inst1
            local xx, yy = inst1.transform:inversePoint(i, j)

            if xx < localbbox1.left or xx >= localbbox1.right + 1 then
                goto continue
            end
            if yy < localbbox1.top or yy >= localbbox1.bottom + 1 then
                goto continue
            end
            if not localbbox1.data[floor(xx + yy * localbbox1.size.width + 1)] then
                goto continue
            end

            -- Check for inst2
            xx, yy = inst2.transform:inversePoint(i, j)

            if xx < localbbox2.left or xx >= localbbox2.right + 1 then
                goto continue
            end
            if yy < localbbox2.top or yy >= localbbox2.bottom + 1 then
                goto continue
            end
            if localbbox2.data[floor(xx + yy * localbbox2.size.width + 1)] then
                return true
            end

            ::continue::
        end
    end

    return false
end

function Instance:placeMeeting(object, x, y)
    x = x or self.x
    y = y or self.y

    if not self.mask then
        return false
    end

    local oldX, oldY = self.x, self.y
    self.x, self.y = x, y

    SpatialHash:update()

    local result = false

    SpatialHash:with(self, object, function(inst)
        XXOO = XXOO + 1
        if inst ~= self then
            if preciseCollision(self, inst) then
                result = inst
                return
            end
        end
    end)

    self.x, self.y = oldX, oldY
    return result
end

function Instance:moveContact(object, dir, maxDist)
    local steps
    if maxDist <= 0 then
        steps = 1000
    else
        steps = round(maxDist)
    end

    local dx = cos(dir * pi / 180)
    local dy = -sin(dir * pi / 180)

    if self:placeMeeting(object) then
        return
    end

    local i = 1
    while i <= steps do
        if not self:placeMeeting(object, self.x + dx, self.y + dy) then
            self.x = self.x + dx
            self.y = self.y + dy
        else
            return
        end
        i = i + 1
    end
end
