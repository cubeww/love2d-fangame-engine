local sin = math.sin
local cos = math.cos
local floor = math.floor
local round = math.round
local pi = math.pi
local max = math.max
local min = math.min

-- the transform provided by love is too slow, so I wrote a "simple" version
local Transform = {}

-- create an instance of transform
-- usually, two transforms are enough for collision detection, so you don't need to create too many of them.
function Transform:new()
    return setmetatable({}, { __index = self })
end

-- set the state of the transform
function Transform:set(x, y, xs, ys, angle, xo, yo)
    self.x = x
    self.y = y
    self.xo = xo
    self.yo = yo
    self.xs = xs
    self.ys = ys
    self.rxs = 1 / xs
    self.rys = 1 / ys
    self.angle = angle * pi / 180
    self.st = 0
    self.ct = 1
    if self.angle ~= 0 then
        self.st = sin(self.angle)
        self.ct = cos(self.angle)
    end
end

-- transform a local bounding box to a global bounding box.
-- used to compute instance bounding box
function Transform:transformRect(left, right, top, bottom)
    local l, r, t, b
    if self.angle == 0 then
        -- simple version
        l = round(self.x + self.xs * (left - self.xo))
        r = round(self.x + self.xs * (right - self.xo + 1) - 1)

        if l > r then
            l, r = r, l
        end

        t = round(self.y + self.ys * (top - self.yo))
        b = round(self.y + self.ys * (bottom - self.yo + 1) - 1)

        if t > b then
            t, b = b, t
        end
    else
        -- complex version
        local xmin = self.xs * (left - self.xo)
        local xmax = self.xs * (right - self.xo + 1) - 1


        local ymin = self.ys * (top - self.yo)
        local ymax = self.ys * (bottom - self.yo + 1) - 1

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

-- transform a local coordinate to global coordinate.
-- doesn't seem to be very useful, since computing the bounding box uses a more efficient method.
function Transform:transformPoint(x, y)
    local xx = floor(((x - self.xo) * self.ct + (y - self.yo) * self.st) * self.xs + self.x)
    local yy = floor(((x - self.xo) * -self.st + (y - self.yo) * self.ct) * self.ys + self.y)
    return xx, yy
end

-- transform global coordinate to local coordinate. 
-- this is very useful for precise collision detection.
function Transform:inversePoint(x, y)
    local xx = floor(((x - self.x) * self.ct - (y - self.y) * self.st) * self.rxs + self.xo)
    local yy = floor(((x - self.x) * self.st + (y - self.y) * self.ct) * self.rys + self.yo)
    return xx, yy
end

-- computes the bounding box of the instance and stores the transform state into the given transform.
function Inst:computeBoundingBox(transform)
    local mask = self:getCurrentMask()
    if mask == None then
        return
    end

    -- get the local bounding box of frame
    local lbbox = mask:getFrame(self.sprite.index).bbox

    -- set transform state
    transform:set(self.x, self.y, self.scale.x, self.scale.y, self.angle, lbbox.origin.x, lbbox.origin.y)
    
    -- compute bounding box
    self.bbox.left, self.bbox.right, self.bbox.top, self.bbox.bottom = transform:transformRect(
        lbbox.left, lbbox.right, lbbox.top, lbbox.bottom)
    
    self.bbox.lbbox = lbbox
end

-- to improve efficiency, we only use two transforms for collision detection
TransformA = Transform:new()
TransformB = Transform:new()

local function preciseCollision(inst1, inst2)
    -- get bounding box intersection
    local l = max(inst1.bbox.left, inst2.bbox.left)
    local r = min(inst1.bbox.right, inst2.bbox.right)
    local t = max(inst1.bbox.top, inst2.bbox.top)
    local b = min(inst1.bbox.bottom, inst2.bbox.bottom)

    local lbbox1 = inst1.bbox.lbbox
    local lbbox2 = inst2.bbox.lbbox

    for j = t, b, 1 do
        for i = l, r, 1 do
            -- check for inst1
            local xx, yy = TransformA:inversePoint(i, j)
            if xx < 0 or xx >= lbbox1.size.width then
                goto continue
            end
            if yy < 0 or yy >= lbbox1.size.height then
                goto continue
            end
            if lbbox1.data[xx + yy * lbbox1.size.width + 1] then
                -- check for inst2
                xx, yy = TransformB:inversePoint(i, j)
                if xx < 0 or xx >= lbbox2.size.width then
                    goto continue
                end
                if yy < 0 or yy >= lbbox2.size.height then
                    goto continue
                end
                if lbbox2.data[xx + yy * lbbox2.size.width + 1] then
                    return true
                end
            end
            ::continue::
        end
    end
    return false
end


function Inst:placeMeeting(objectName, x, y)
    x = x or self.x
    y = y or self.y

    local mask = self:getCurrentMask()
    if mask == None then
        return false
    end

    local obj = Objects[objectName]

    local oldX, oldY = self.x, self.y
    self.x, self.y = x or self.x, y or self.y

    self:computeBoundingBox(TransformA)

    local flag = false
    for _, inst in ipairs(obj.addlPool) do
        local imask = inst:getCurrentMask()
        if imask ~= None then
            inst:computeBoundingBox(TransformB)

            if preciseCollision(self, inst) then
                flag = true
                break
            end
        end
    end

    self.x, self.y = oldX, oldY
    return flag
end
