#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
//change these in creation code

if (warpX == 0)
    warpX = 0;
if (warpY == 0)
    warpY = 0;
if (roomTo == 0)
    roomTo = rTemplate;
#define Collision_Player
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (warpX == 0 && warpY == 0)
{
    with(objPlayer)
        instance_destroy();
}
else
{
    objPlayer.x = warpX;
    objPlayer.y = warpY;
}

room_goto(roomTo);
