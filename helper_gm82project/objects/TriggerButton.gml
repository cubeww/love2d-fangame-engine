#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
//set trg in creation code

if (trg == 0)
    trg = 0;

image_speed = 0;
#define Collision_Bullet
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (image_index == 0)   //sets trigger when shot
{
    image_index = 1;
    global.trigger[trg] = true;
}
#define Other_4
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
global.trigger[trg] = false;    //reset the trigger
