#define Create_0
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
//this object shows whether an item has been obtained or not

//set in creation code
if (itemNum == 0)
    itemNum = 0;
#define Other_4
/*"/*'/**//* YYD ACTION
lib_id=1
action_id=603
applies_to=self
*/
if (!global.secretItem[itemNum])    //destroy self if item has not been obtained
    instance_destroy();
