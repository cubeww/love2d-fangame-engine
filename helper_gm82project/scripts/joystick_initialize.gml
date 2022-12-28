// initialize the joystick key state
var i;
for (j = 0; j < 2; j += 1)
{
    for (i = 0; i < 17; i += 1)
    {
        global.joystickButtonDown[j,i] = 0;
        global.joystickButtonPress[j,i] = 0;
        global.joystickButtonRelease[j,i] = 0;
    }
}
