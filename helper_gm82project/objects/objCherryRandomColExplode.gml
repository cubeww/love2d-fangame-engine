#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
event_inherited();

image_xscale = 2;
image_yscale = 2;

direction = random_range(90,270);
speed = 3;

alarm[0] = 17;  //set an alarm to make this explode
#define Alarm_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
//explode into a circle

scrMakeCircle(x,y,random(360),12,choose(6,7,8),objCherryRandomCol);

instance_destroy();
