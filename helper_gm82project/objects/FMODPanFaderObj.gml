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
if(!isinst)
{
    if(inc<0)
    {
        curpan = max(dest,curpan+inc);
    }
    else
    {
        curpan = min(dest,curpan +inc);
    }
    curpan-=1;
    if(code <>"")
    {
        execute_string(code);
    }
    curpan+=1;
    //show_message("G:"+string(group)+"F:"+string(curpan)+"T:"+string(dest)+"I:"+string(inc)+"GOT:");

    FMODGroupSetPan(group,curpan -1);
    if(curpan = dest)
    {
        instance_destroy();
    }
    exit;
}
    if(inc<0)
    {
        curpan = max(dest,curpan +inc);
    }
    else
    {
        curpan = min(dest,curpan +inc);
    }
    curpan-=1;
    if(code <>"")
    {
        execute_string(code);
    }
    curpan+=1;
    FMODInstanceSetPan(group,curpan -1);
    if(curpan = dest)
    {
        instance_destroy();
    }
