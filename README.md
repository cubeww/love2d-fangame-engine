# Love2D Fangame Engine (Alpha)

An experimental **IWBTG Fangame engine**, aimed to be an alternative to gamemaker.

The engine is still under development, so there may be some bugs.

## Project structure

+ engine: Some scripts to maintain the running of the game (object-instance system, sprite, room...)
+ game: Elements used in the IWBTG fangame (World, Player, Levels...)
+ libs: Some third-party lua script libraries used by engine or game.
+ main.lua: Program entry
+ conf.lua: Additional configuration for the game window
+ helper_gm82lovetool: A small tool to convert gm82room to lua room
+ helper_gm82project: Helper project for game room editing only

## Develop (Windows)

1. Clone / download the repository
2. Install love2d runner [LÖVE - Free 2D Game Engine (love2d.org)](https://love2d.org/)
3. (Recommend) Set the love2d installation path as an **environment variable**
4. (Recommend) Download and install vscode, and install the "**Lua Language Server (sumneko)**" extension 
5. Open the **repository folder** with vscode and start developing.
6. Run '**lovec .**' in the terminal to test the engine/game.

## Publish

To publish your game, you need to follow these steps:

1. Zip the "**engine**" folder, the "**game**" folder, the "**libs**" folder, the "**main.lua**" file, and the "**conf.lua**" file into **yourgamename.zip** (note that it must be a **zip** only).

2. Rename **yourgamename.zip** to **yourgamename.love**. At this point, if the player has already installed love2d, they can simply double-click it to run the game.

3. If you want to further package the game, go to your **love2d installation path**, copy "**love.exe**" and all the **.dll files** in this directory to a new folder "**publish**", then copy **yourgamename.love** into the **publish** folder, and finally open the **CMD window** in the **publish** folder, enter: 

   ```CMD
   copy /b love.exe+yourgamename.love yourgamename.exe
   ```

    You should see a newly created "**yourgamename.exe**" file. Now you can safely **delete "yourgamename.love" and "love.exe"** in the publish folder, and package the entire publish folder for sharing. Note that **all .dll files are essential**, otherwise the player will not be able to enter the game!

## Special  Thanks

+ omicronrex - awesome gm82room editor 

+ YoYoYoDude - awesome studio fangame engine reference

## License

This repository is under the **MIT license**, but the love2d portion is subject to its original license.