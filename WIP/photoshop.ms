function editBitmap jpg =
(
	local ps = getIniSetting (getMAXIniFile()) "photoshop" "path"
		
	if ps == "" do
		(
			local ps = getOpenFileName caption:"Please locate Photoshop.exe" filename:"c:/program files/Photoshop.exe" types:"Executable Files(*.exe)|*.exe"
			
			if ps != undefined do setINISetting (getMAXIniFile()) "photoshop" "path" ps
		)
				if ps != undefined AND doesFileExist ps then
				(
				--format "Opening: \"%\" in Photoshop...\n" bmp
				shellLaunch ps jpg
				)
				else
				(
				delINISetting (getMAXIniFile()) "photoshop" "path"
				messagebox "Photoshop could not be found"
				)
)

editBitmap "c:\\temp\\image.jpg"