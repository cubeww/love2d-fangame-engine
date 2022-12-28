#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
isinst = false;
#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/

if(inc<0)
{
    instpitch= max(dest,instpitch+inc);
}
else
{
    instpitch= min(dest,instpitch+inc);
}

//show_message("G:"+string(group)+"F:"+string(instpitch)+"T:"+string(dest)+"I:"+string(inc));

FMODGroupSetPitch(group,instpitch);

if(instpitch= dest)
{
    instance_destroy();
}
