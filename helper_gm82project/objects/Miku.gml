#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
//this boss uses its own internal timer to coordinate attacks, you could also use timelines to set attack timing instead of this method
timer = 0;
curve = false;

scrStopMusic();
scrPlayMusic(musMiku,false);    //song is "Hatsune Miku - Tho (閵夊鍎?"

global.noPause = true;  //make it so that the player can't pause during the boss
#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (instance_exists(objPlayer)) //make sure player is alive before doing attacks
{
    timer += 1; //increment the timer

    if (timer == 65){event_user(0);}          //executes a custom user event (you can check it in the object events)
    else if (timer == 80){event_user(1);}
    else if (timer == 95){event_user(0);}
    else if (timer == 103){event_user(1);}
    else if (timer == 118){event_user(0);}
    else if (timer == 133){event_user(1);}
    else if (timer == 140){event_user(0);}
    else if (timer == 147){event_user(1);}
    else if (timer == 154){event_user(0);}
    else if (timer == 169){event_user(1);}
    else if (timer == 191){event_user(0);}
    else if (timer == 206){event_user(1);}
    else if (timer == 221){event_user(0);}
    else if (timer == 228){event_user(1);}
    else if (timer == 235){event_user(0);}
    else if (timer == 243){event_user(0);}
    else if (timer == 257){event_user(1);}
    else if (timer == 266){event_user(0);}
    else if (timer == 271){event_user(1);}
    else if (timer == 278){event_user(0);}
    else if (timer > 300 && timer < 480)
    {
        if (timer mod 2 == 1)    //this makes it so that an object is only created once every 2 frames
        {
            var a;
            a = instance_create(x,y,objCherryRandomCol);
            a.direction = random_range(180,270);
            a.speed = random_range(7,9);
        }
    }
    else if (timer == 490)
    {
        with(objCherryRandomCol)
        {
            direction = 0;
            speed = 0;
        }
    }
    else if (timer == 505)
    {
        with(objCherryRandomCol)
        {
            y -= 30;
        }
    }
    else if (timer == 520)
    {
        with(objCherryRandomCol)
        {
            y -= 30;
        }
    }
    else if (timer == 528)
    {
        with(objCherryRandomCol)
        {
            vspeed = -10;
        }
    }
    else if (timer > 540 && timer < 875)
    {
        curve = true;  //make the apples curve

        if (timer mod 15 == 1)
        {
            instance_create(x,y,objCherryRandomColExplode);
        }
    }
    else if (timer > 1058 && timer < 1110)
    {
        curve = false;  //make the apples stop curving

        instance_create(random_range(0,800),random_range(0,128),objCherryRandomCol);
    }
    else if (timer == 1120)
    {
        with(objCherryRandomCol)
        {
            vspeed = 8;
        }
    }
    else if (timer > 1130 && timer < 1600)
    {
        if (timer mod 3 == 1)
        {
            var a;
            a = instance_create(random_range(0,800),0,objCherryRandomCol);
            a.vspeed = 9;
        }

        if (timer == 1234){event_user(0);}
        else if (timer == 1249){event_user(1);}
        else if (timer == 1264){event_user(0);}
        else if (timer == 1271){event_user(1);}
        else if (timer == 1286){event_user(0);}
        else if (timer == 1301){event_user(1);}
        else if (timer == 1308){event_user(0);}
        else if (timer == 1315){event_user(1);}
        else if (timer == 1322){event_user(0);}
        else if (timer == 1337){event_user(1);}
        else if (timer == 1480){event_user(0);}
        else if (timer == 1495){event_user(0);}
        else if (timer == 1510){event_user(1);}
        else if (timer == 1517){event_user(0);}
        else if (timer == 1532){event_user(1);}
        else if (timer == 1547){event_user(0);}
        else if (timer == 1554){event_user(1);}
        else if (timer == 1561){event_user(0);}
        else if (timer == 1568){event_user(1);}
        else if (timer == 1583){event_user(0);}
    }
    else if (timer > 1600 && timer < 2070)
    {
        if (timer mod 4 == 1)
        {
            var a;
            a = instance_create(800,random_range(0,608),objCherryRandomCol);
            a.hspeed = -9;
        }

        if (timer == 1726){event_user(0);}
        else if (timer == 1741){event_user(0);}
        else if (timer == 1756){event_user(1);}
        else if (timer == 1763){event_user(0);}
        else if (timer == 1778){event_user(1);}
        else if (timer == 1793){event_user(0);}
        else if (timer == 1800){event_user(1);}
        else if (timer == 1807){event_user(0);}
        else if (timer == 1814){event_user(1);}
        else if (timer == 1829){event_user(0);}
    }
    else if (timer > 2070 && timer < 2280)
    {
        if (timer mod 8 == 1)
        {
            instance_create(x,y,objCherryRandomColBounce);
        }
    }
    else if (timer == 2450)
    {
        with(objCherryRandomColBounce)
        {
            image_blend = make_color_rgb(0,0,0);   //turn the cherries black
            speedDown = 1;
        }
    }
    else if (timer == 2550)
    {
        with(objCherryRandomColBounce)
        {
            moveFromPlayer = true;
        }
    }
    else if (timer > 2675 && timer < 2950)
    {
        curve = true;
        if (timer mod 18 == 1)
        {
            scrMakeCircle(random_range(0,800),0,random(360),12,choose(6,7,8),objCherryRandomCol);
        }
    }
    else if (timer > 2950 && timer < 3200)
    {
        if (timer mod 18 == 1)
        {
            scrMakeCircle(800,random_range(0,608),random(360),12,choose(6,7,8),objCherryRandomCol);
        }
    }
    else if (timer > 3200 && timer < 3525)
    {
        if (timer mod 17 == 1)
        {
            scrMakeCircle(random_range(0,800),0,random(360),12,choose(6,7,8),objCherryRandomCol);
            scrMakeCircle(800,random_range(0,608),random(360),12,choose(6,7,8),objCherryRandomCol);
        }
    }
    else if (timer > 3684 && timer < 3750)
    {
        curve = false;

        var a;
        a = instance_create(x,y,objCherryRandomCol);
        a.direction = random_range(170,280);
        a.speed = random_range(8,10);
    }
    else if (timer == 3750)
    {
        scrStopMusic();               //stop the music
        sound_play(sndDeath);

        if (!global.bossItem[0])
        {
            //spawn boss item
            var a;
            a = instance_create(672,544,objBossItem);
            a.itemNum = 0;
        }

        instance_destroy();
    }
}
#define Other_10
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
///makes squares

scrMakeShapes(x,y,random(360),4,4,choose(6,7,8),objCherryRandomCol);
#define Other_11
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
///makes triangles

scrMakeShapes(x,y,random(360),3,5,choose(6,7,8),objCherryRandomCol);
