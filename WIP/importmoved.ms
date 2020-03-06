global fStruct
global fStructImporter
global fStructShellTimer
	
try ( destroyDialog fStruct) catch ()
	
	global baseValue = 9
	global sysBarH = 31
	global freeSpaceH = 1
	global freeSpaceW = 2
	global winW = 150
	global winH = 2*winW/2
	global pdHeight = sysBarH - winH
	global pdWidth1 = baseValue + freeSpaceW
	global pdWidth2 = baseValue + 2*freeSpaceW + winW
	global pdWidth3 = baseValue + 3*freeSpaceW + 2*winW
	global pdHeight3 = sysBarH + 2*freeSpaceH

rollout fStruct "1 window" width:winW height:winH --define a rollout 
(
	label lbl_test "fStruct"
	on fStruct close do print "fStruct closed!"

	on fStruct moved pos do 
	(
		setDialogPos fStructImporter (pos+[fStruct.width + pdWidth1 ,fStruct.height + pdHeight])
		setDialogPos fStructShellTimer (pos+[fStruct.width + pdWidth1 ,fStruct.height + pdHeight3])
	)

	on fStruct open do 
	(
		rollout fStructImporter "2 window" width:winW height:winH--define another rollout
		(
			--tuk shte e importera
			label lbl_test "fStructImporter"
		)
		
		rollout fStructShellTimer "3 window" width: winW height:winH --define another rollout
		(
			--tuk shte sa ostanalite neshta
			label lbl_test3 "fStructShellTimer"
		)
						
		--Create a dialog from the second rollout and pass the .HWND 
		createDialog fStructImporter pos:[(getDialogpos fStruct)[1]+fStruct.width + pdWidth1,(getDialogPos fStruct)[2]+fStruct.height + pdHeight] parent:fStruct.hwnd style:#()
		createDialog fStructShellTimer pos:[(getDialogpos fStruct)[1]+fStruct.width + pdWidth1,(getDialogPos fStruct)[2]+fStruct.height + pdHeight3] parent:fStruct.hwnd style:#()
	)

)
createDialog fStruct pos:[200,200] style:#(#style_sysmenu,#style_toolwindow)