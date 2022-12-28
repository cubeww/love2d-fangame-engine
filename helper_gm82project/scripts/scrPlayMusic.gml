///scrPlayMusic(soundid,loops)
///plays a song if it's not already playing
///argument0 - song to play (-1 plays nothing and stops anything currently playing)
///argument1 - whether or not to loop the song

var songID, loopSong;
songID = argument0;
loopSong = argument1;

if (!global.muteMusic)  //check if music is supposed to be muted
{
    if (global.currentMusicID != songID)  //checks if the song to play is already playing
    {
        global.currentMusicID = songID;
        
        sound_stop(global.currentMusic);
        
        if (songID != -1)
        {
            if (loopSong)
                global.currentMusic = sound_loop(global.currentMusicID);
            else
                global.currentMusic = sound_play(global.currentMusicID);
        }
    }
}
