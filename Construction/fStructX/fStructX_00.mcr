macroScript fStructX
category:"BorakaScriptPack_vol1"
toolTip:"fStructX"
buttonText:"fStructX"
icon:#("BorakaIconsPackVol1",1)

(
	colorMan.reiniticons()

	on execute do
	(
		if doesFileExist (pathConfig.GetDir #userscripts+"\\BorakaScriptPack_vol1\\fStructX.ms") then
			fileIn (pathConfig.GetDir #userscripts+"\\BorakaScriptPack_vol1\\fStructX.ms")
		else
			messagebox "Can't locate the script" title:"ERROR!!!"
	)
)
