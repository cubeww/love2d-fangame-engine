#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
//set song to play in creation code
if (BGM == 0)
    BGM = -2;
#define Other_4
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (BGM != -2)
    scrPlayMusic(BGM,true);
