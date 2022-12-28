// get the down state of the joystick
var index, key;
index = argument0;
key = argument1;

if (key >= 1 && key <= 8)
{
    return joystick_check_button(index, key);
}
else
{
    // pad
    if (key == gp_padu) return joystick_pov(index) == 0 || joystick_pov(index) == 45 || joystick_pov(index) == 315;
    if (key == gp_padr) return joystick_pov(index) == 90 || joystick_pov(index) == 45 || joystick_pov(index) == 135;
    if (key == gp_padd) return joystick_pov(index) == 180 || joystick_pov(index) == 135 || joystick_pov(index) == 225;
    if (key == gp_padl) return joystick_pov(index) == 270 || joystick_pov(index) == 225 || joystick_pov(index) == 315;

    // shoulder
    if (key == gp_shoulderlb) return joystick_zpos(index) > 0;
    if (key == gp_shoulderrb) return joystick_pov(index) < 0;
}
