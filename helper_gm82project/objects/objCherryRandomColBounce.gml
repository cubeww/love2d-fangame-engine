#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
event_inherited();

//bounces randomly

direction = random(360);
speed = 6;

speedDown = 0;
moveFromPlayer = 0;
#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
event_inherited();

if (speedDown)
{
    if (speed > 0)
    {
        speed -= 0.25;
    }
    else
    {
        speedDown = 0;
        speed = 0;
    }
}

if (moveFromPlayer)
{
    if (instance_exists(objPlayer))
        direction = point_direction(objPlayer.x,objPlayer.y,x,y);

    speed += 0.2;
}
else
{
    move_bounce_solid(false);
}
