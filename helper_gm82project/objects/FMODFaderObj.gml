#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
isinst = false
#define Step_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if(isinst)
{
    if(inc<0)
    {
        instvol = max(dest,instvol+inc);
    }
    else
    {
        instvol = min(dest,instvol+inc);
    }
    if(code <>"")
    {
        execute_string(code);
    }

    FMODInstanceSetVolume(group,instvol);
    if(instvol = dest)
    {
        instance_destroy();
    }
    exit;
}
    //show_message("G:"+string(group)+"F:"+string(instvol)+"T:"+string(dest)+"I:"+string(inc)+"GOT:"+string(FMODGroupGetVolume(group)));

    if(inc<0)
    {
        instvol = max(dest,instvol+inc);
    }
    else
    {
        instvol = min(dest,instvol+inc);
    }
    FMODGroupSetVolume(group,instvol);
    if(instvol = dest)
    {
        instance_destroy();
    }
