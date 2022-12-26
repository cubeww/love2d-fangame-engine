-- input.lua
-- collect the input state of the keyboard/mouse.

-- supports both keyboard and mouse input. 
-- refer to https://love2d.org/wiki/KeyConstant for a list of keyboard keys.
-- integer 1=left mouse button, 2=right mouse button, 3=middle mouse button.


Input = {}

Input.pressedKeys = {}
Input.heldKeys = {}
Input.releasedKeys = {}


-- update methods

function Input:_pressed(key)
    if not self.heldKeys[key] then
        self.pressedKeys[key] = true
        self.heldKeys[key] = true
    end
end

function Input:_released(key)
    self.releasedKeys[key] = true
    self.heldKeys[key] = false
end

function Input:_clear()
    self.pressedKeys = {}
    self.releasedKeys = {}
end


-- check methods

function Input:pressed(key)
    return self.pressedKeys[key]
end

function Input:held(key)
    return self.heldKeys[key]
end

function Input:released(key)
    return self.releasedKeys[key]
end
