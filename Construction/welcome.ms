global fstructxInstFolder = pathConfig.GetDir #userscripts + "\\BorakaScriptPack_vol1"
global tempfStructFolder = @"C:\Users\Public\Documents\fStructX\"
global licPath = @"C:\Users\riffraff\Dropbox\Scripting\maxscript\4_Final stage\Config\lic\" --UNIF
global logName = @"log.txt"
global licName = @"Licenses.ini"
global exportFilelog = tempfStructFolder + logName
global licenseFile = licPath + licName
global keyName = "__name__"
global keyRole = "__role__"
global keyLic = "__lic__"
global keyId = "__id__"
global keyReg = "__reg__"
global expresion = " !"

global isLicensed = undefined
global owner = undefined
global registeredTo = ""

isFolderExist = doesFileExist tempfStructFolder
if	( isFolderExist == false ) then
(
	makeDir tempfStructFolder all:false
)
if(doesFileExist exportFilelog == false) then
(
	cf = createFile exportfilelog
	format "FSTRUCTX SCRIPT!\n" to:cf
	close cf
)

try ( destroyDialog globalWelcome) catch ()

	rollout globalWelcome "WELCOME TO THE WORLD OF FSTRUCTX !" width:480 height:240
	(
		local dotcolor = (dotnetclass "System.Drawing.Color").FromArgb
		local bgcolor = dotcolor 68 68 68 
		local fgcolor = dotcolor 255 255 255
		local bluecolor = dotcolor 0 186 255
		local redcolor = dotcolor 255 0 0
		
		dotnetcontrol lblWelcome "Label" text:"1" width:780 height:90 pos:[20,20]
		dotnetcontrol lblProceed "Label" text:"" width:((globalWelcome.width)-40) height:24 pos:[25,95]
		dotnetcontrol lblLicense "Label" text:"2" width:235 height:24 pos:[10,200]
		dotnetcontrol lblregDate "Label" text:"" width:(((globalWelcome.width)-40)-((lblLicense.width)+20)) height:24 pos:[230,140]
		
		local labels = #(lblWelcome, lblProceed, lblLicense, lblregDate)
		local bcolors = #(bgcolor, bgcolor, bgcolor, bgcolor)
		local fcolors = #(fgcolor, bluecolor, fgcolor, bluecolor)
		local fonts = #("", "", "", "")
		local sizes = #(32, 11, 8, 12)
		
		local btnVertPos = 140
		local btnW = 130
		local btnH = 30
		local space = 146
		local btnInstallPos = 25
		local btnUninstallPos = btnInstallPos + space
		local btnInstr = btnUninstallPos + space

		checkbutton install "INSTALL" pos:[btnInstallPos,btnVertPos] width:btnW height:btnH enabled:true border:true
		checkbutton uninstall "UNINSTALL" pos:[btnUninstallPos,btnVertPos] width:btnW height:btnH enabled:true border:true
		checkbutton showInstr "INSTRUCTIONS" pos:[btnInstr,btnVertPos] width:btnW height:btnH enabled:true border:true

		-- INSTALL START
		fn installMethod = 
		(
			--------------------------------------------------------#TODO #Implement #install
			local extractDir = tempfStructFolder
			local mzpFilename = @"C:\Users\riffraff\Dropbox\Scripting\maxscript\9_Final script\fStructX_UVPrinter_000Exporter.mzp" --UNIF
			local dropFile = "welcome.ms"

			if msZip.fileInPackage mzpFilename extractDir then 
			( 
				msZip.unloadPackage mzpFilename extractDir dropFile 
				colorMan.reiniticons()
			) 
		)
		
		on install changed state do
		(
			if (state == true) then
			(
				installMethod()
				lblProceed.Text = toUpper "Installed successfully !"
			)
			install.checked = false			
		)
		--INSTALL STOP
				
		--UNINSTALL START
		fn DeleteDirAndSubDir rootDir =
		(
			try ( DOSCommand ("rmDir \"" + rootDir + "\" /s /q") ) catch (messagebox "Can't delete fStructX folders!" title:"fStructX - Uninstall")
		)
		
		fn deleteFilesRecursive root pattern =
		(	
			my_files = #()
			dir_array = GetDirectories (root+"/*")
			for d in dir_array do join dir_array (GetDirectories (d+"/*"))
			for f in dir_array do join my_files (getFiles (f + pattern))
			for del in my_files do deletefile del
			counter =  my_files.count as string
			my_files = getFiles (root + "\\" + pattern)
			for del in my_files do deletefile del
		)
		
		fn uninstallMethod =
		(
			local userscripts = @"$userScripts\BorakaScriptPack_vol1\"
			local usermacros = @"$usermacros\"
			local usericons = @"$usericons\"
			local temp = @"$temp\"
			
			-- deleting files
			deleteFilesRecursive userscripts "*.mat"
			deleteFilesRecursive userscripts "*.mtl"
			deleteFilesRecursive userscripts "*.ms"
			deleteFilesRecursive userscripts "*.mcr"
			deleteFilesRecursive userscripts "*.run"
			deleteFilesRecursive userscripts "*.py"
			deleteFilesRecursive userscripts "*.pyc"
			deleteFilesRecursive userscripts "*.qss"
			deleteFilesRecursive userscripts "*.jpg"
			deleteFilesRecursive userscripts "*.png"
			deleteFilesRecursive userscripts "*.bmp"
			deleteFilesRecursive usermacros "BorakaScriptPack_*.mcr"
			deleteFilesRecursive usericons "BorakaIconsPackVol1_*.bmp"
			deleteFilesRecursive temp "welcome.ms"
			deleteFilesRecursive temp "insComp.ms"
			
			showInstr.checked = false
			destroyDialog loadInstInfo
			
			if (fstructxInstFolder != "") then DeleteDirAndSubDir fstructxInstFolder
			colorMan.reiniticons()
			
		)
		
		on uninstall changed state do
		(
			if (state == true) then
			(
				uninstallMethod()
				lblProceed.Text = toUpper "Uninstalled successfully !"
			)
			uninstall.checked = false
		)
		--UNINSTALL STOP
		
		--INSTALATION INFO START
		fn installInfo =
		(
			rollout loadInstInfo "INSTALL INFORMATION!" width:300 height:175
			(
				label loadInfo "info" text:"" width:280 height:180 pos:[10,10]

				on loadInstInfo open do
				(
				
					insTructions = "INSTRUCTIONS : " + "\n" + "\n" + "Customize   ->  Customize User Interface   ->  Toolbars   ->  Category: BorakaScriptPack_vol1   ->" + "\n" + "\n"
					insTructions2 =	"New   - >  Set name  ->   Drag some of the scripts in the pop-up window  ->  Set the icon on the toolbar !" + "\r"
					userscriptsPath = "\r#userscripts\r" + (pathConfig.GetDir #userscripts) + "\n"
					loadInfo.text = (insTructions + insTructions2 + userscriptsPath)
				)
			)
			
			createDialog loadInstInfo pos:[(getDialogpos globalWelcome)[1]+globalWelcome.width + 9,(getDialogPos globalWelcome)[2]+globalWelcome.height - (162-18)] parent:globalWelcome.hwnd style:#()
		)
		
		on showInstr changed state do
		(
			if (state == true) then
			(
				installInfo()
			)
			else
			(
				destroydialog loadInstInfo
			)				
		)	
		--INSTALATION INFO STOP
		
		--WINDOW BEAUTY START
		
		fn initLicenseFile = 
		(
			if(doesDirectoryExist licPath == false) then
				(
					makeDir licPath all:false
				)

			if(doesFileExist licenseFile == false) then
				(
					setIniForceUTF16Default false

					--create license file
					cf = createFile licenseFile
					--format "\t" to:cf
					close cf
					
					local domainSection = "DOMAIN"
					local ownerSection = "BorisoB"
					local ownerDefault = "riffraff"
					local guestSection = "Guest"

					setINISetting licenseFile domainSection keyName

					setINISetting licenseFile ownerSection keyId "7333d458-8175-3cc3-8cee-e9975a2f6316"
					setINISetting licenseFile ownerSection keyName "Borislav" 
					setINISetting licenseFile ownerSection keyRole "owner" 
					setINISetting licenseFile ownerSection keyLic "true"
					setINISetting licenseFile ownerSection keyReg "UNLIMITED"

					setINISetting licenseFile ownerDefault keyId "62bccf11-8b58-327d-9ab7-d680cfdfb33a"
					setINISetting licenseFile ownerDefault keyName "Borislav" 
					setINISetting licenseFile ownerDefault keyRole "owner" 
					setINISetting licenseFile ownerDefault keyLic "true"
					setINISetting licenseFile ownerDefault keyReg "UNLIMITED"

					setINISetting licenseFile guestSection keyId "2fc89fea-ceb3-3c59-80d3-50f79802f5a8"
					setINISetting licenseFile guestSection keyName "Guest" 
					setINISetting licenseFile guestSection keyRole "guest" 
					setINISetting licenseFile guestSection keyLic "false"
					setINISetting licenseFile guestSection keyReg "UNREGISTERED"
				)
		)

		fn checkTheOwner = 
		(
			local pathToChekerFile = exportFilelog
			
			local guest = "Guest"
			local noreg = "UNREGISTERED"
			local nolic = false

			local owner = ""
			local license = ""
			--local unlimit = "UNLIMITED"
			--local reg = 2021
			--local lic = true
						
			local isAccount = false

			initLicenseFile()

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
				showInstr.visible = false
				install.visible = false
				uninstall.visible = false
				
				--rearange labels to fit 
				lblWelcome.Text = lblWelcome.Text

				lblProceed.Forecolor = redcolor
				
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
		
		fn DotNetFont fontname size style =
		(	
			FontStyle = dotnetclass "System.Drawing.FontStyle";
				fs = case style of
				(
					#bold: FontStyle.bold
					#italic: FontStyle.italic
					#regular: FontStyle.regular;
					default: FontStyle.condensed;
				)
			dotnetobject "System.Drawing.Font" fontname size fs;
		)
		
		fn welcome = 
		(
			lblWelcome.Text = "Welcome, " + checkTheOwner()	
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
		--WINDOW BEAUTY STOP
		
		on globalWelcome moved pos do
		(
			--LightMeter.active
			setDialogPos loadInstInfo (pos+[globalWelcome.width + 9 ,globalWelcome.height - (162-18)])
		)
		
		on globalWelcome open do
		(
			welcome()
		)

		on globalWelcome close do 
		(
			if ((isLicensed as string) == "false") then
			(
				uninstallMethod()
			)
		)
	)
	
	rollout loadInstInfo "INSTALL INFORMATION!" width:300 height:175
	(
		label loadInfo "info" text:"" width:280 height:180 pos:[10,10]

		on loadInstInfo open do
		(
			insTructions = "INSTssssssssssssRUCTIONS : " + "\n" + "\n" + "Customize   ->  Customize User Interface   ->  Toolbars   ->  Category: BorakaScriptPack_vol1   ->" + "\n" + "\n"
			insTructions2 =	"New   - >  Set name  ->   Drag some of the scripts in the pop-up window  ->  Set the icon on the toolbar !" 
			instruction3 = fstructxInstFolder + "\n"
			loadInfo.text = (insTructions + insTructions2 + instruction3)
			
		)
	)
	
	createDialog loadInstInfo pos:[(getDialogpos globalWelcome)[1]+globalWelcome.width + 9,(getDialogPos globalWelcome)[2]+globalWelcome.height - (162-18)] parent:globalWelcome.hwnd style:#()
	destroyDialog loadInstInfo
createDialog globalWelcome pos:[500,400] style:#(#style_sysmenu,#style_toolwindow) 