// update the joystick key state
var index, i, j;
for (j = 0; j < 2; j += 1)
{
    for (i = 1; i < 17; i += 1)
    {
        var down;
        down = joystick_get_button_down(j,i);

        if (down && !global.joystickButtonDown[j,i])
        {
            global.joystickButtonPress[j,i] = 1;
            global.joystickButtonDown[j,i] = 1;
            global.joystickButtonRelease[j,i] = 0;
        }
        else if (down)
        {
            global.joystickButtonPress[j,i] = 0;
            global.joystickButtonDown[j,i] = 1;
            global.joystickButtonRelease[j,i] = 0;
        }
        else if (!down && global.joystickButtonDown[j,i])
        {
            global.joystickButtonPress[j,i] = 0;
            global.joystickButtonDown[j,i] = 0;
            global.joystickButtonRelease[j,i] = 1;
        }
        else if (!down && global.joystickButtonRelease[j,i])
        {
            global.joystickButtonPress[j,i] = 0;
            global.joystickButtonDown[j,i] = 0;
            global.joystickButtonRelease[j,i] = 0;
        }
    }
}
