try ( destroyDialog loadInstInfo) catch ()

	rollout loadInstInfo "INSTALL INFORMATION!" width:300 height:175
	(
		label loadInfo "info" text:"" width:280 height:180 pos:[10,10]

		on loadInstInfo open do
		(
			insTructions = "INSTRUCTIONS : " + "\n" + "\n" + "Customize   ->  Customize User Interface   ->  Toolbars   ->  Category: BorakaScriptPack_vol1   ->" + "\n" + "\n"
			insTructions2 =	"New   - >  Set name  ->   Drag some of the scripts in the pop-up window  ->  Set the icon on the toolbar !" + "\r"
			loadInfo.text = (insTructions + insTructions2)
			
		)
		
	)

createDialog loadInstInfo pos:[(getDialogpos globalWelcome)[1]+globalWelcome.width + 8,(getDialogPos globalWelcome)[2]+globalWelcome.height - (162-18)] parent:globalWelcome.hwnd style:#()
