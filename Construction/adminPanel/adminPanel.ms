global fstructxInstFolder = pathConfig.GetDir #userscripts + "\\BorakaScriptPack_vol1"
global tempfStructFolder = @"C:\Users\Public\Documents\fStructX\"
global licPath = @"C:\Users\riffraff\Dropbox\Scripting\maxscript\4_Final stage\Config\lic\"
global logName = @"log.txt"
global licName = @"Licenses.ini"
global exportFilelog = tempfStructFolder + logName
global licenseFile = licPath + licName
global keyName = "__name__"
global keyRole = "__role__"
global keyLic = "__lic__"
global keyReg = "__reg__"
global expresion = " !"

global isLicensed = undefined
global owner = undefined
global role = undefined
global registeredTo = ""

try ( destroyDialog adminPanel) catch ()

	rollout adminPanel "ADMIN PANEL" width:480 height:240
	(
		local dotcolor = (dotnetclass "System.Drawing.Color").FromArgb
		local bgcolor = dotcolor 68 68 68
		local fgcolor = dotcolor 255 255 255
		local bluecolor = dotcolor 0 186 255
		local redcolor = dotcolor 255 0 0
		
		dotnetcontrol lblAdminPanel "Label" text:"Admin Panel" width:(adminPanel.width) height:48 pos:[0,0]
		dotnetcontrol lblWelcome "Label" text:"1" width:((lblAdminPanel.width/2)-70) height:(lblAdminPanel.height/2) pos:[((lblAdminPanel.width/2)+70),(lblAdminPanel.pos.y) + 6]
		dotnetcontrol lblRole "Label" text:"-> admin" width:((lblAdminPanel.width/2)-160) height:((lblAdminPanel.height/2)-10) pos:[((lblAdminPanel.width/2)+160),(lblWelcome.pos.y + (lblAdminPanel.height/2) - 4)]

		dotnetcontrol lblLicense "Label" text:"2" width:235 height:24 pos:[10,200]
		dotnetcontrol lblregDate "Label" text:"" width:(((adminPanel.width)-40)-((lblLicense.width)+20)) height:24 pos:[230,140]
		
		local labels = #(lblAdminPanel, lblWelcome, lblRole, lblLicense, lblregDate)
		local bcolors = #(bluecolor, bluecolor, bluecolor, bgcolor, bgcolor)
		local fcolors = #(fgcolor, fgcolor, bgcolor, fgcolor, bluecolor)
		local fonts = #("", "", "", "", "")
		local sizes = #(28, 12, 8, 8, 12)
		
		local btnVertPos = 120
		local btnW = 60
		local btnH = 20
		local space = 80
		local btnRemoveLicPos = 25
		local btnDeleteUserPos = btnRemoveLicPos + space

		checkbutton removeLic "Remove Lic" pos:[btnRemoveLicPos,btnVertPos] width:btnW height:btnH enabled:true border:true
		checkbutton deleteUser "Delete User" pos:[btnDeleteUserPos,btnVertPos] width:btnW height:btnH enabled:true border:true

		fn checkWhoIs = 
		(
			local pathToChekerFile = exportFilelog
			
			local guest = "Guest"
			local noreg = "UNREGISTERED"
			local nolic = false

			local owner = ""
						
			local isAccount = false

			if(doesFileExist pathToChekerFile == true) then
				(
					-- get user name
					fileInfo = dotNetObject "System.IO.FileInfo" pathToChekerFile
					fileAccessControl = fileInfo.getAccessControl()
					NTAccountType = dotNetClass "System.Security.Principal.NTAccount"
					fileOwner = fileAccessControl.getOwner NTAccountType
					format "AUTHOR : '%' \n" fileOwner.value
					ownerPersonFull = fileOwner.value
					ownerPersonSplit = FilterString ownerPersonFull "\\"
					ownerPerson = ownerPersonSplit[ownerPersonSplit.count]

					-- check if user exists into the license file
					if(ownerPersonFull == (getINISetting licenseFile "DOMAIN" keyName) + ownerPerson) then
					(
						local isAccount = hasINISetting licenseFile ownerPerson
						if(isAccount == true) then
						(
							owner = (getINISetting licenseFile ownerPerson keyName) + expresion
							role = (getINISetting licenseFile ownerPerson keyRole)
							isLicensed = getINISetting licenseFile ownerPerson keyLic
							getRegDate = getINISetting licenseFile ownerPerson keyReg
							registeredTo = if isLicensed == (nolic as string) then noreg else getRegDate
						)
						else
						(
							owner = (getINISetting licenseFile guest keyName) + expresion
							isLicensed = getINISetting licenseFile guest keyLic
							registeredTo = getINISetting licenseFile guest keyReg
						)
					)
					else
					(
						owner = (getINISetting licenseFile guest keyName) + expresion
						isLicensed = getINISetting licenseFile guest keyLic
						registeredTo = getINISetting licenseFile guest keyReg
					)
				)
				
			return owner as string
		)
		
		fn additonalSettings = 
		(
			--IF THE USER IS  REGISTERED 
			if(isLicensed == "true") then
			(
				lblregDate.pos = [(lblLicense.width),(lblLicense.pos[2]-4)]
				lblregDate.Forecolor = bluecolor
				lblregDate.Backcolor = bgcolor
			)
			
			--IF THE USER IS NOT REGISTERED -- INSTALATION IS CANCELED AND DISABLED
			if(isLicensed == "false") then
			(
				--hide the buttons
				removeLic.visible = false
				deleteUser.visible = false
				
				--rearange labels to fit 
				lblWelcome.Text = lblWelcome.Text

				lblRole.Forecolor = redcolor
				
				lblLicense.width = (lblLicense.width) + 30

				lblregDate.pos = [(lblLicense.width),(lblLicense.pos[2]-4)]
				lblregDate.Forecolor = redcolor
			)
		)
		
		fn checkLicense = 
		(
			license = ""
			if(isLicensed == "true") then
			(
				license = toUpper "Licensed"
			)
			else
			(
				license = toUpper "Non-Licensed"
			)
			
			return license as string
		)
		
		fn checkRegistrationDate =
		(
			register = ""
			if(isLicensed == "true") then
			(
				register = registeredTo
			)
			if(isLicensed == "false") then
			(
				register = registeredTo
			)
			
			return register as string
		)
				
		fn welcome = 
		(
			lblWelcome.Text = "Welcome, " + checkWhoIs()
			lblRole.Text = "-> " + role
			lblLicense.Text = "     " + checkLicense() + " USER" + "   |   REGISTERED TO :  "
			lblregDate.Text = checkRegistrationDate()
			
			for k=1 to labels.count do 
			(
				labels[k].Backcolor = bcolors[k]
				labels[k].Forecolor = fcolors[k]
				labels[k].font = dotnetobject "System.Drawing.Font" fonts[k] sizes[k]
			)
			
			additonalSettings()
		)
			
		on adminPanel open do
		(
			welcome() 
		)
	)

createDialog adminPanel pos:[500,400] style:#(#style_sysmenu,#style_toolwindow) 