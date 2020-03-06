tempfStructFolder = "C:\Users\Public\Documents\fStructX\\"
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

destroyDialog loadInstInfo
try ( destroyDialog globalWelcome) catch ()
	
global isLicensed = undefined
global owner = undefined
global registeredTo = 2020
global loadInstInfo

	rollout globalWelcome "WELCOME TO THE WORLD OF FSTRUCTX !" width:800 height:200
	(
		dotnetcontrol lblWelcome "label" text:"Welcome to the fStructX !" width:780 height:90 pos:[10,20]
		label lblLicense "license" text:"" width:220 height:60 pos:[10,142]
		
		label lblProceed "" text:"" width:260 height:24 pos:[25,110]

		local bgcolor = (dotnetclass "System.Drawing.Color").FromArgb 68 68 68 
		local fgcolor = (dotnetclass "System.Drawing.Color").FromArgb 255 255 255
		
		checkbutton showInfo "INSTALL INFORMATION" pos:[630,125] width:140 height:35 enabled:true border:true
		checkbutton install "INSTALL" pos:[320,125] width:140 height:35 enabled:true border:true
		checkbutton uninstall "UNINSTALL" pos:[475,125] width:140 height:35 enabled:true border:true

		
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
		
		fn checkTheOwner = 
		(
			pathToChekerFile = exportFilelog
			fileInfo = dotNetObject "System.IO.FileInfo" pathToChekerFile
			fileAccessControl = fileInfo.getAccessControl()
			NTAccountType = dotNetClass "System.Security.Principal.NTAccount"
			fileOwner = fileAccessControl.getOwner NTAccountType
			--format "AUTHOR : '%' \n" fileOwner.value
			
			 owner = ""
			 license = ""
			
				if(doesFileExist exportFilelog == true) then
				(
					if(fileOwner.value == "RR-PC\RR")then
					(
						owner = "Borislav !"
						isLicensed = true
					)
					else if(fileOwner.value == "[PC NAME]")then
					(
						owner = "[REAL NAME]"
					)
					else
					(
						owner = "Guest !"
						isLicensed = false
					)
				)
				
			return owner as string
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
				register = 0
			)
			
			return register as string
		)
		
		fn welcome = 
		(
			lblWelcome.Text = "Welcome, " + checkTheOwner()
			lblWelcome.Backcolor = bgcolor
			lblWelcome.Forecolor = fgcolor
			lblWelcome.Font = DotNetFont "Verdana" 40 #regular
			
			lblLicense.text = "     " + checkLicense() + " USER" + "  |  REGISTERED TO: " + checkRegistrationDate()
		)
		
		fn installInfo =
		(
			insComp = @"C:\Users\RR\Dropbox\Scripting\maxscript\2_Constructions\insComp.ms"
			isScriptExist = doesfileExist insComp
			if (isScriptExist == true) then
				fileIn insComp
			else
				messagebox "Instalation info is missing !"
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
			getFilesRecursive @"$usermacros\" "BorakaIconsPackVol1_*.mcr"
			getFilesRecursive @"$temp\" "welcome.ms"
			getFilesRecursive @"$temp\" "insComp.ms"
			colorMan.reiniticons()
		)
		
		fn installMethod = 
		(
			
			local extractDir = @"C:\Users\Public\Documents\fStructX"
			local mzpFilename = @"C:\Users\RR\Dropbox\Scripting\maxscript\9_Final scripts\BorakaScriptPack_vol1.mzp"
			local dropFile = "welcome.ms"
			if msZip.fileInPackage mzpFilename extractDir then 
			( 
				
			) 
			msZip.unloadPackage mzpFilename extractDir dropFile 
			colorMan.reiniticons()
			
		)
		
		on globalWelcome moved pos do
		(
			setDialogPos loadInstInfo (pos+[globalWelcome.width + 9 ,globalWelcome.height - 162])
		)
		
		on globalWelcome open do
		(
			welcome()			
		)
		
		on uninstall changed state do
		(
			if state == true then
			(
				uninstallMethod()
				lblProceed.text = toUpper "fStructX_vol.1 - uninstalled successfully !"
			)
			uninstall.checked = false
		)
		
		on install changed state do
		(
			if state == true then
			(
				installMethod()
				lblProceed.text = toUpper "fStructX_vol.1 - installed successfully !"
			)
			install.checked = false
		)
		
		on showInfo changed state do
		(
			
			if state == true then
			(
				installInfo()
			)
			else
			(
				destroydialog loadInstInfo
			)				
		)	
	)
	
	createDialog loadInstInfo pos:[(getDialogpos globalWelcome)[1]+globalWelcome.width + 9,(getDialogPos globalWelcome)[2]+globalWelcome.height - 162] parent:globalWelcome.hwnd style:#()

createDialog globalWelcome pos:[500,400] style:#(#style_sysmenu,#style_toolwindow) 