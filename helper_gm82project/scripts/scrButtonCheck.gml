///scrButtonCheck(buttonArray)
///checks whether a button is currently being pressed
///argument0 - array containing the keyboard button in index 0 and the controller button in index 1

var buttonIn;
buttonIn = argument0;

if (!global.controllerMode)
{
    keyboard_check_direct(variable_global_array_get(buttonIn,0)); //perform a pre-check to prevent strange input BUG

    return (keyboard_check_direct(variable_global_array_get(buttonIn,0)));
}
else
{
    return (joystick_check_button_down(global.controllerIndex,variable_global_array_get(buttonIn,1)));
}
