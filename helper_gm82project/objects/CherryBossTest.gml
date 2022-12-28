#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
event_inherited();

hspeed = choose(-2,2);

currentHP = 20;

alarm[0] = 45;

global.noPause = true;  //make it so that the player can't pause during the boss
#define Alarm_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (instance_exists(objPlayer))
{
    var a;
    a = instance_create(x,y,objCherry);
    a.speed = 5;
    a.direction = point_direction(x,y,objPlayer.x,objPlayer.y);

    alarm[0] = 45;
}
#define Collision_Bullet
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
sound_play(sndBossHit);

with (other)
    instance_destroy();

currentHP -= 1;

if (currentHP <= 0)
{
    with (objBlockInvis)
        instance_destroy();

    global.noPause = false;

    instance_destroy();
}
