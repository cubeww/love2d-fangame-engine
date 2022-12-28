///scrButtonCheckPressed(buttonArray)
///checks whether a button is being pressed this frame
///argument0 - array containing the keyboard button in index 0 and the controller button in index 1

var buttonIn;
buttonIn = argument0;

if (!global.controllerMode)
{
    return (keyboard_check_pressed(variable_global_array_get(buttonIn,0)));
}
else
{
    return (joystick_check_button_pressed(global.controllerIndex,variable_global_array_get(buttonIn,1)));
}
