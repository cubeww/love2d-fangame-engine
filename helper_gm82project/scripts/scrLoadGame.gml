///scrLoadGame(loadfile)
///loads the game
///argument0 - sets whether or not to read the save file when loading the game

var loadFile;
loadFile = argument0;

//only load save data from the save file if the script is currently set to (we should only need to load these on first load because the game stores them afterwards)
if (loadFile)
{
    //load the save map
    var saveMap, f;

    f = file_text_open_read("Data\save"+string(global.savenum));

    saveMap = ds_map_create();
    ds_map_read(saveMap, base64_decode(file_text_read_string(f)));

    file_text_close(f);

    var saveValid;
    saveValid = true;   //keeps track of whether or not the save being loaded is valid

    if (saveMap != -1)  //check if the save map loaded correctly
    {
        global.death = ds_map_find_value(saveMap,"death");
        global.time = ds_map_find_value(saveMap,"time");
        global.timeMicro = ds_map_find_value(saveMap,"timeMicro");

        global.difficulty = ds_map_find_value(saveMap,"difficulty");
        global.saveRoom = ds_map_find_value(saveMap,"saveRoom");
        global.savePlayerX = ds_map_find_value(saveMap,"savePlayerX");
        global.savePlayerY = ds_map_find_value(saveMap,"savePlayerY");
        global.saveGrav = ds_map_find_value(saveMap,"saveGrav");

        if (is_string(global.saveRoom))   //check if the saved room loaded properly
        {
            //check if the room index in the save is valid
            execute_string("
            if (!room_exists("+global.saveRoom+"))  
                saveValid = false;
                ");
        }
        else
        {
            saveValid = false;
        }

        var i;
        for (i = 0; i < global.secretItemTotal; i+=1)
        {
            global.saveSecretItem[i] = ds_map_find_value(saveMap,"saveSecretItem["+string(i)+"]");
        }

        for (i = 0; i < global.bossItemTotal; i+=1)
        {
            global.saveBossItem[i] = ds_map_find_value(saveMap,"saveBossItem["+string(i)+"]");
        }

        global.saveGameClear = ds_map_find_value(saveMap,"saveGameClear");

        //load md5 string from the save map
        var mapMd5;
        mapMd5 = ds_map_find_value(saveMap,"mapMd5");

        //check if md5 is not a string in case the save was messed with or got corrupted
        if (!is_string(mapMd5))
            mapMd5 = "";   //make it a string for the md5 comparison

        //generate md5 string to compare with
        ds_map_delete(saveMap,"mapMd5");
        var genMd5;
        genMd5 = md5(ds_map_write(saveMap)+global.md5StrAdd);

        if (mapMd5 != genMd5)   //check if md5 hash is invalid
            saveValid = false;

        //destroy the map
        ds_map_destroy(saveMap);
    }
    else
    {
        //save map didn't load correctly, set the save to invalid
        saveValid = false;
    }
    
    if (!saveValid) //check if the save is invalid
    {
        //save is invalid, restart the game
        
        show_message("Save invalid!");
        
        scrRestartGame();
        
        exit;
    }
}

//set game variables and set the player's position

with (objPlayer) //destroy player if it exists
    instance_destroy();

global.gameStarted = true;  //sets game in progress (enables saving, restarting, etc.)
global.noPause = false;     //disable no pause mode
global.autosave = false;    //disable autosaving since we're loading the game

global.grav = global.saveGrav;

for (i = 0; i < global.secretItemTotal; i+=1)
{
    global.secretItem[i] = global.saveSecretItem[i];
}

for (i = 0; i < global.bossItemTotal; i+=1)
{
    global.bossItem[i] = global.saveBossItem[i];
}

global.gameClear = global.saveGameClear;

instance_create(global.savePlayerX,global.savePlayerY,objPlayer);

execute_string("room_goto("+global.saveRoom+");");
