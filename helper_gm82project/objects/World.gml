#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
//make sure we never have more than one world object

if (instance_number(object_index) > 1)
    instance_destroy();
#define Alarm_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
///pause current music when it's done fading out

sound_pause(global.currentMusic);
#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=World
*/
///game checks


//set linear interpolation depending on what the current smoothing setting is
texture_set_interpolation(global.smoothingMode);

//controller checks
if (global.controllerEnabled && global.controllerIndex != -1)
{
    if (!global.controllerMode)  //check if we should switch to controller mode
    {
        if (keyboard_check_pressed(vk_anykey))
        {
            global.controllerDelay = -1;
        }
        else if (scrAnyControllerButton() != -1)
        {
            if (global.controllerDelay == -1)
                global.controllerDelay = global.controllerDelayLength;
        }
    }
    else    //check if we should switch to keyboard mode
    {
        if (keyboard_check_pressed(vk_anykey))
        {
            if (global.controllerDelay == -1)
                global.controllerDelay = global.controllerDelayLength;
        }
        else if (scrAnyControllerButton() != -1)
        {
            global.controllerDelay = -1;
        }
    }

    if (global.controllerDelay != -1)   //check delay for switching between keyboard/controller
    {
        if (global.controllerDelay == 0)    //delay over, toggle controller mode
        {
            global.controllerMode = !global.controllerMode;
            global.controllerDelay = -1;
        }
        else
        {
            global.controllerDelay -= 1;
        }
    }
}

if (global.gameStarted)
{
    //handle pausing
    if (global.pauseDelay <= 0) //check if pause delay is active
    {
        if (scrButtonCheckPressed("pauseButton"))
        {
            if (!global.gamePaused)  //game currently not paused, pause the game
            {
                if (!global.noPause)
                {
                    global.gamePaused = true;  //set the game to paused
                    global.pauseDelay = global.pauseDelayLength; //set pause delay

                    instance_deactivate_all(true);  //deactivate everything

                    global.pauseBg = background_create_from_screen(0,0,800,608,0,0);    //create new background
                }
            }
            else    //game currently paused, unpause the game
            {
                global.gamePaused = false;  //set the game to unpaused
                global.pauseDelay = global.pauseDelayLength;     //set pause delay

                instance_activate_all();    //reactivate objects

                if (background_exists(global.pauseBg))
                    background_delete(global.pauseBg);         //delete the background

                scrSaveConfig();    //save config in case volume levels were changed

                io_clear(); //clear input states to prevent possible pause strats/exploits
            }
        }
    }
    else
    {
        global.pauseDelay -= 1;
    }

    if (!global.gamePaused) //check if the game is currently paused
    {
        if (scrButtonCheckPressed("restartButton"))
        {
            //stop death sound/music
            sound_stop(global.deathSound);
            sound_stop(global.gameOverMusic);

            //resume room music
            sound_resume(global.currentMusic);

            ///return to old gain if music is being faded out
            if (global.musicFading)
            {
                global.musicFading = false;
                sound_fade(global.currentMusic,global.currentGain,0);
                alarm[0] = -1;   //reset alarm that pauses music
            }

            scrSaveGame(false); //save death/time
            scrLoadGame(false); //load the game
        }

        if (global.timeWhenDead || instance_exists(objPlayer))  //increment timer
        {
            global.time += 1 / 50;
        }
    }
    else    //game is paused, check for volume controls
    {
        if (scrButtonCheck("upButton"))
        {
            if (global.volumeLevel < 100)
                global.volumeLevel += 1;
        }
        else if (scrButtonCheck("downButton"))
        {
            if (global.volumeLevel > 0)
                global.volumeLevel -= 1;
        }

        sound_global_volume(global.volumeLevel/100);  //set master gain
    }

    scrSetRoomCaption();    //keep caption updated
}
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
///debug keys

if (global.debugMode && global.gameStarted && !global.gamePaused)
{
    if (keyboard_check(vk_tab))             //drags player with mouse
    {
        with (objPlayer)
        {
            x = mouse_x;
            y = mouse_y;
        }
    }
    if (keyboard_check_pressed(vk_backspace))   //toggles debug overlay
    {
        global.debugOverlay = !global.debugOverlay;
    }
    if (keyboard_check_pressed(vk_insert))  //saves game
    {
        with (objPlayer)
        {
            scrSaveGame(true);
            sound_play(sndItem);
        }
    }
    if (keyboard_check_pressed(vk_delete))  //toggles showing the hitbox
    {
        global.debugShowHitbox = !global.debugShowHitbox;
    }
    if (keyboard_check_pressed(vk_home))    //toggles god mode
    {
        global.debugNoDeath = !global.debugNoDeath;
    }
    if (keyboard_check_pressed(vk_end))     //toggles infinite jump
    {
        global.debugInfJump = !global.debugInfJump;
    }
    if (keyboard_check_pressed(vk_pageup) && room != room_last)  //goes to next room
    {
        with (objPlayer)
            instance_destroy();

        room_goto_next();
    }
    if (keyboard_check_pressed(vk_pagedown) && room != room_first)    //goes to previous room
    {
        with (objPlayer)
            instance_destroy();

        room_goto_previous();
    }
}

if (global.debugVisuals)
{
    with (objPlayer)    //sets appearance of the player to show god mode/infinite jump
    {
        if (global.debugNoDeath)     //makes player slightly transparent when god mode is on
            image_alpha = 0.7;
        else
            image_alpha = 1;

        if (global.debugInfJump)     //makes player turn blue when infinite jump is on
            image_blend = c_blue;
        else
            image_blend = c_white;
    }
}
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
///function keys

if (keyboard_check_pressed(vk_escape))
{
    game_end();
}

if (keyboard_check_pressed(vk_f2))
{
    scrRestartGame();
    exit;
}

if (keyboard_check_pressed(vk_f4) && !global.gamePaused)    //toggle fullscreen mode
{
    global.fullscreenMode = !global.fullscreenMode;

    window_set_fullscreen(global.fullscreenMode);

    scrSaveConfig();    //save fullscreen setting
}

if (keyboard_check_pressed(vk_f5) && !global.gamePaused)    //reset window size
{
    scrResetWindowSize();
}

if (keyboard_check(vk_control) && keyboard_check_pressed(ord("M")) && !global.gamePaused)
{
    //toggle mute music setting
    scrToggleMusic();

    scrSaveConfig();    //save mute setting
}
#define Step_1
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
///update joystick button states

if (global.controllerEnabled)
    joystick_update();
#define Step_2
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
///update fmod
FMODUpdate();
#define Other_2
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
///initialize everything

//initialize all variables
scrInitializeGlobals();

//load the current config file, sets default config if it doesn't exist
scrLoadConfig();

room_goto_next();
#define Other_4
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
///room checks

if (!instance_exists(objPlayMusic))  //make sure the play music object isn't in the current room
    scrGetMusic();  //find and play the proper music for the current room

room_speed = 50;    //make sure game is running at the correct frame rate
scrSetRoomCaption();    //make sure window caption stays updated
#define Other_10
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
///fade current music out
global.musicFading = true;
global.currentGain = sound_get_volume(global.currentMusic);     //get current gain
sound_fade(global.currentMusic,0,1000);                       //fade out music over 1 second

alarm[0] = 50;  //pause music when it's done fading
#define Draw_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
///draw debug overlay

if (global.debugOverlay)
{
    draw_set_color(c_black);
    draw_set_halign(fa_left);
    draw_set_font(fDefault12);

    var drawX, drawY, drawAlign;
    drawX = 0;
    drawY = 0;
    drawAlign = 0;
    if (instance_exists(objPlayer))
    {
        drawX = objPlayer.x;
        drawY = objPlayer.y;
        drawAlign = objPlayer.x mod 3;
    }

    scrDrawTextOutline(view_xview[0]+20,view_yview[0]+20,"X: "+string(drawX),c_black,c_white);
    scrDrawTextOutline(view_xview[0]+20,view_yview[0]+40,"Y: "+string(drawY),c_black,c_white);
    scrDrawTextOutline(view_xview[0]+20,view_yview[0]+60,"Align: "+string(drawAlign),c_black,c_white);
    scrDrawTextOutline(view_xview[0]+20,view_yview[0]+80,"Room name: "+room_get_name(room),c_black,c_white);
    scrDrawTextOutline(view_xview[0]+20,view_yview[0]+100,"Room number: "+string(room),c_black,c_white);
    scrDrawTextOutline(view_xview[0]+20,view_yview[0]+120,"God mode: "+string(global.debugNoDeath),c_black,c_white);
    scrDrawTextOutline(view_xview[0]+20,view_yview[0]+140,"Infinite jump: "+string(global.debugInfJump),c_black,c_white);
    scrDrawTextOutline(view_xview[0]+20,view_yview[0]+160,"FPS: "+string(fps),c_black,c_white);
}
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
///draw pause screen

if (global.gamePaused)  //check if game is paused to draw the pause screen
{
    draw_clear(c_black);

    if (background_exists(global.pauseBg))       //check if background exists before drawing it
        draw_background(global.pauseBg,view_xview[0],view_yview[0]);

    draw_set_color(c_black);
    draw_set_alpha(0.4);

    draw_rectangle(view_xview[0]-1,view_yview[0]-1,view_xview[0]+view_wview[0],view_yview[0]+view_hview[0],0);    //darken the paused screen

    draw_set_alpha(1);

    draw_set_color(c_white);

    draw_set_halign(fa_center);
    draw_set_font(fDefault30);

    draw_text(view_xview[0]+view_wview[0]/2,view_yview[0]+view_hview[0]/2 - 24,"PAUSE");

    draw_set_halign(fa_left);
    draw_set_font(fDefault18);

    var t, timeText;
    t = global.time;
    timeText = string(t div 3600) + ":";
    t = t mod 3600;
    timeText += string(t div 600);
    t = t mod 600;
    timeText += string(t div 60) + ":";
    t = t mod 60;
    timeText += string(t div 10);
    t = t mod 10;
    timeText += string(floor(t));

    draw_text(view_xview[0]+20,view_yview[0]+516,"Volume: " + string(global.volumeLevel) + "%");
    draw_text(view_xview[0]+20,view_yview[0]+541,"Deaths: " + string(global.death));
    draw_text(view_xview[0]+20,view_yview[0]+566,"Time: " + timeText);
}
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
///draw debug mode text when we're on the title screen

if (global.debugMode && room == rTitle)
{
    draw_set_color(c_red);
    draw_set_font(fDefault12);
    draw_set_halign(fa_left);
    
    draw_text(view_xview[0]+34,view_yview[0]+34,"Debug mode");
}
