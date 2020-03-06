tempfStructFolder = @"C:\Users\Public\Documents\fStructX\"
exportFilelog = @"C:\Users\Public\Documents\fStructX\log.txt" 

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
	
global isLicensed = undefined
global owner = undefined
global registeredTo = ""

	rollout globalWelcome "WELCOME TO THE WORLD OF FSTRUCTX !" width:800 height:175
	(
		--local tempFstructxAssistFolder = pathConfig.GetDir #temp + "\\tempFstructxAssistFolder"
		local fstructxInstFolder = pathConfig.GetDir #userscripts + "\\BorakaScriptPack_vol1"

		local dotcolor = (dotnetclass "System.Drawing.Color").FromArgb
		local bgcolor = dotcolor 68 68 68 
		local fgcolor = dotcolor 255 255 255
		local bluecolor = dotcolor 0 186 255
		local redcolor = dotcolor 255 0 0
		

		dotnetcontrol lblWelcome "Label" text:"1" width:780 height:90 pos:[10,20]
		dotnetcontrol lblProceed "Label" text:"" width:360 height:24 pos:[25,95]
		dotnetcontrol lblLicense "Label" text:"2" width:280 height:60 pos:[10,142]
		dotnetcontrol lblregDate "Label" text:"" width:90 height:24 pos:[230,138]
		
		local labels = #(lblWelcome, lblProceed, lblLicense, lblregDate)
		local bcolors = #(bgcolor, bgcolor, bgcolor, bgcolor)
		local fcolors = #(fgcolor, bluecolor, fgcolor, bluecolor)
		local fonts = #("", "", "", "")
		local sizes = #(40, 11, 9, 12)
		
		checkbutton showInfo "INSTALL INFORMATION" pos:[630,125] width:140 height:35 enabled:true border:true
		checkbutton install "INSTALL" pos:[320,125] width:140 height:35 enabled:true border:true
		checkbutton uninstall "UNINSTALL" pos:[475,125] width:140 height:35 enabled:true border:true

		-- INSTALL START
		fn installMethod = 
		(
			--------------------------------------------------------#TODO #Implement #install
			local extractDir = @"C:\Users\Public\Documents\fStructX"
			local mzpFilename = @"M:\Z_Software Assets\3ds Max\BorakaScriptPack_vol1\BorakaScriptPack_vol1.mzp"
			local dropFile = "welcome.ms"
			if msZip.fileInPackage mzpFilename extractDir then 
			( 
				
			) 
			msZip.unloadPackage mzpFilename extractDir dropFile 
			colorMan.reiniticons()
		)
		
		
		on install changed state do
		(
			if (state == true) then
			(
				installMethod()
				lblProceed.Text = toUpper "fStructX_vol.1 - installed successfully !"
			)
			install.checked = false			
		)
		--INSTALL STOP
				
		--UNINSTALL START
		fn DeleteDirAndSubDir rootDir =
		(
			try ( DOSCommand ("rmDir \"" + rootDir + "\" /s /q") ) catch (messagebox "Can't delete fStructX folders!" title:"fStructX uninstall message!!!")
		)
		
		fn getFilesRecursive root pattern =
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
			-- deleting files
			getFilesRecursive @"$userScripts\BorakaScriptPack_vol1\" "*.mat"
			getFilesRecursive @"$userScripts\BorakaScriptPack_vol1\" "*.mtl"
			getFilesRecursive @"$userScripts\BorakaScriptPack_vol1\" "*.ms"
			getFilesRecursive @"$userScripts\BorakaScriptPack_vol1\" "*.jpg"
			getFilesRecursive @"$userScripts\BorakaScriptPack_vol1\" "*.mcr"
			getFilesRecursive @"$userScripts\BorakaScriptPack_vol1\" "*.run"
			getFilesRecursive @"$userScripts\BorakaScriptPack_vol1\" "*.bmp"
			getFilesRecursive @"$usericons\" "BorakaIconsPackVol1_*.bmp"
			getFilesRecursive @"$usermacros\" "BorakaScriptPack_*.mcr"
			getFilesRecursive @"$temp\" "welcome.ms"
			getFilesRecursive @"$temp\" "insComp.ms"
			
			showInfo.checked = false
			--destroyDialog loadInstInfo
			
			if (fstructxInstFolder != "") then DeleteDirAndSubDir fstructxInstFolder
			colorMan.reiniticons()
		)
		
		on uninstall changed state do
		(
			if (state == true) then
			(
				uninstallMethod()
				lblProceed.Text = toUpper "fStructX_vol.1 - uninstalled successfully !"
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
					loadInfo.text = (insTructions + insTructions2)
				)
			)
			
			createDialog loadInstInfo pos:[(getDialogpos globalWelcome)[1]+globalWelcome.width + 9,(getDialogPos globalWelcome)[2]+globalWelcome.height - (162-18)] parent:globalWelcome.hwnd style:#()

		)
		
		on showInfo changed state do
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
		
		fn checkTheOwner = 
		(
			pathToChekerFile = exportFilelog
			fileInfo = dotNetObject "System.IO.FileInfo" pathToChekerFile
			fileAccessControl = fileInfo.getAccessControl()
			NTAccountType = dotNetClass "System.Security.Principal.NTAccount"
			fileOwner = fileAccessControl.getOwner NTAccountType
			format "AUTHOR : '%' \n" fileOwner.value
			ownerPerson = fileOwner.value
			
			if (ownerPerson == "RIFFRAFF\riffraff") then
			(
				messagebox "kur" beep:false
			)

			
			 owner = ""
			 license = ""
			
				if(doesFileExist pathToChekerFile == true) then
				(
					if(fileOwner.value == "PIXELPOOL\BorisoB")then
					(
						owner = "Borislav !"
						isLicensed = true
						registeredTo = "UNLIMIT"
					)
					else if(fileOwner.value == "PIXELPOOL\Ana.Nedyalkova")then
					(
						owner = "Ana !"
						isLicensed = true
						registeredTo = 2020
					)
					else if(fileOwner.value == "PIXELPOOL\DimovD")then
					(
						owner = "Didara !"
						isLicensed = true
						registeredTo = 2020
					)
					else if(fileOwner.value == "PIXELPOOL\MincheM")then
					(
						owner = "Marina !"
						isLicensed = true
						registeredTo = 2020
					)
					else if(fileOwner.value == "PIXELPOOL\GaidarH")then
					(
						owner = "Hristiyana !"
						isLicensed = true
						registeredTo = 2020
					)
					else if(fileOwner.value == "PIXELPOOL\GetzovP")then
					(
						owner = "Petya !"
						isLicensed = true
						registeredTo = 2020
					)
					else if(fileOwner.value == "PIXELPOOL\YankovM")then
					(
						owner = "Mariya !"
						isLicensed = true
						registerTo = 2020
					)
					else if(fileOwner.value == "PIXELPOOL\KurtevZ")then
					(
						owner = "Zara !"
						isLicensed = true
						registeredTo = 2020
					)
					else if(fileOwner.value == "PIXELPOOL\NenkovE")then
					(
						owner = "Mims !"
						isLicensed = true
						registeredTo = 2020
					)
					else if(fileOwner.value == "PIXELPOOL\DancheM")then
					(
						owner = "Margarita !"
						isLicensed = true
						registeredTo = 2020
					)
					else if(fileOwner.value == "PIXELPOOL\GoncheM")then
					(
						owner = "Mariya !"
						isLicensed = true
						registeredTo = 2020
					)
					else
					(
						owner = "Guest !"
						isLicensed = true
						registeredTo = "UNREG."
					)
				)
				
			return owner as string
		)
		
		fn additonalSettings = 
		(
			--IF THE USER IS  REGISTERED 
			if(isLicensed == true) then
			(
				lblregDate.pos = [200,138]
				lblregDate.Forecolor = bluecolor
				lblregDate.Backcolor = bgcolor
			)
			
			
			--IF THE USER IS NOT REGISTERED -- INSTALATION IS CANCELED AND DISABLED
			if(isLicensed == false) then
			(
				space = "                                                             "
				space2 = "               "
				--hide the buttons
				showInfo.visible = false
				install.visible = false
				uninstall.visible = false
				
				--rearange labels to fit 
				lblWelcome.Text = lblWelcome.Text
				lblProceed.width = 600
				--lblProceed.Text = toUpper (space + "Sorry  !  instalation is canceled and disabled !")
				lblLicense.pos = [5,142]
				lblregDate.pos = [220,138]
				
				--set reg color to red
				lblregDate.Forecolor = redcolor
				lblProceed.Forecolor = redcolor
			)
		)
		
		fn checkLicense = 
		(
			license = ""
			if(isLicensed == true) then
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
			if(isLicensed == true) then
			(
				register = registeredTo
			)
			if(isLicensed == false) then
			(
				register = "UNREG."
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
			setDialogPos loadInstInfo (pos+[globalWelcome.width + 9 ,globalWelcome.height - (162-18)])
		)
		
		on globalWelcome open do
		(
			welcome()
			if checkTheOwner == "Guest !" then
				uninstallMethod()
		)
	)
	
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
	
	createDialog loadInstInfo pos:[(getDialogpos globalWelcome)[1]+globalWelcome.width + 9,(getDialogPos globalWelcome)[2]+globalWelcome.height - (162-18)] parent:globalWelcome.hwnd style:#()
	destroyDialog loadInstInfo
createDialog globalWelcome pos:[500,400] style:#(#style_sysmenu,#style_toolwindow) 