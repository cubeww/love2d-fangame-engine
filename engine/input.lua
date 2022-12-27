-- input.lua
-- Collect the input state of the keyboard/mouse.

-- Supports both keyboard and mouse input. 
-- Refer to https://love2d.org/wiki/KeyConstant for a list of keyboard keys.
-- Integer 1=left mouse button, 2=right mouse button, 3=middle mouse button.


Input = {}

Input.pressedKeys = {}
Input.heldKeys = {}
Input.releasedKeys = {}


-- Update methods

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


-- Check methods

function Input:pressed(key)
    return self.pressedKeys[key]
end

function Input:held(key)
    return self.heldKeys[key]
end

function Input:released(key)
    return self.releasedKeys[key]
end
