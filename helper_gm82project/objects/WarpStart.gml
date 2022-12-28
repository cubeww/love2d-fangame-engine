#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
//initialize this in creation code
if (dif == 0)
    dif = 0;
if (is_real(difName))
    difName = "Load Game";
#define Collision_Player
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (dif == 4)   //load game
{
    if (file_exists("Data\save"+string(global.savenum)))
        scrLoadGame(true);
    else
        scrKillPlayer();
}
else    //start new game
{
    global.gameStarted = true; //sets game in progress (enables saving, restarting, etc.)
    global.autosave = true;

    global.difficulty = dif;

    if(file_exists("Data\save"+string(global.savenum)))
        file_delete("Data\save"+string(global.savenum));

    with (objPlayer)
        instance_destroy();

    room_goto(global.startRoom);
}
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
draw_self();

draw_set_color(c_black)
draw_set_font(fDefault12);
draw_set_halign(fa_center);

draw_text(x+16,y-16,difName);
