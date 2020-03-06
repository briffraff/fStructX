rollout but "Front/Back views" width:250 height:70
(
	checkbutton showthat "show/hide" pos:[10,10] width:230 height:50 
	
	on showthat changed loadScript do
	(
		if loadScript == true then
		(
			theScript = @"C:\Users\RR\Dropbox\maxscript\10_Refs\code\loadBitmaps.ms"
			isScriptExist = doesfileExist theScript
			if (isScriptExist == true) then
				fileIn theScript
			else
				messagebox "Something go wrong"
		)
		else
		(
			destroydialog loadFrontAndBack
		)
	)
)
createDialog but