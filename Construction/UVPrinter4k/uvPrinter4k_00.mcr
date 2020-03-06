macroScript uvPrinter4k
	category:"BorakaScriptPack_vol1"
	toolTip:"UV Printer 4k"
	buttonText:"UV Print 4k"
	icon:#("BorakaIconsPackVol1",2) 
	
(	
	-- Avtomatichno obnovqvane na ikonite 
	colorMan.reiniticons()
	
	-- Yslovie za otkliuchvane na script-a ako ima selektiran obekt
	--on isEnabled return selection.count == 1
	on execute do
	(		--ako file-ut sushtestvuva da se izpulni ili da dade greshka
		if doesFileExist (pathConfig.GetDir #userscripts+"\\BorakaScriptPack_vol1\\uvPrinter.ms") then
			fileIn (pathConfig.GetDir #userscripts+"\\BorakaScriptPack_vol1\\uvPrinter.ms")
		else
			messagebox "Can't locate the script" title:"ERROR!!!"
	)
)