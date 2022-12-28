#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
event_inherited();
image_speed = 0;

image_blend = make_color_hsv(irandom(255),255,255); //set a random color

curve = false;

if (instance_exists(objMiku))
{
    if (objMiku.curve)
        curve = choose(-0.5,0.5);   //make this curve if it's currently supposed to
}
#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
direction += curve;
