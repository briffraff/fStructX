macroScript Zero_Exporter
	category:"BorakaScriptPack_vol1"
	toolTip:"000 Exporter"
	buttonText:"000 Exporter"
	icon:#("BorakaIconsPackVol1",3)
	
(	
	colorMan.reiniticons()
	
	on isEnabled return selection.count == 1
	on execute do
	(	
		if doesFileExist (pathConfig.GetDir #userscripts+"\\BorakaScriptPack_vol1\\000Exporter.ms") then
			fileIn (pathConfig.GetDir #userscripts+"\\BorakaScriptPack_vol1\\000Exporter.ms")
		else
			messagebox "Can't locate the script" title:"ERROR!!!"
	)
)