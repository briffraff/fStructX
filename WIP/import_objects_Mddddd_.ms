filesmix = files[1]
thePTh = "C:\Users\RR\Dropbox\maxscript\0_Root\Obj\MD"
objPath = (thePTh + "\\*.obj" ) as string
files = getFiles objPath	

rollout Referencer "Referencer" width:394 height:426
	
(

label 'lbl9' "Reference Assets" pos:[157,17] width:93 height:39 align:#left

listbox objectToKill "Objects:" items:(for i in files collect i) pos:[31,61] width:330 height:20 align:#left
button 'refBtn' "Reference" pos:[119,358] width:139 height:40 align:#left
--to fill list box
on Referencer  open do 
(
    objectToKill.items=files 
)
--to get listbox name
on refBtn pressed do
(
importFile objecttoKill.selected #noprompt
local txt= objectToKill.selected  
if txt!=undefined do messagebox txt --txt here is your file full path
)

--you can replace messagebox with any function you have
)
createDialog referencer