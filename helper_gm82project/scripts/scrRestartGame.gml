///restarts the game

if (background_exists(global.pauseBg))
    background_delete(global.pauseBg);  //free pause background in case the game is currently paused

FMODfree();
UnloadFMOD();

game_restart();
