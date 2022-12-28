#define Collision_Player
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
///go to the next room

with (objPlayer)
    instance_destroy();

room_goto_next();
