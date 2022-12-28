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
if(isinst)
{
    if(inc<0)
    {
        instfreq = max(dest,instfreq +inc);
    }
    else
    {
        instfreq = min(dest,instfreq +inc);
    }

    //show_message("G:"+string(group)+"F:"+string(instfreq)+"T:"+string(dest)+"I:"+string(inc));
    FMODInstanceSetFrequency(group,instfreq);

    if(instfreq = dest)
    {
        instance_destroy();
    }
    exit;
}
