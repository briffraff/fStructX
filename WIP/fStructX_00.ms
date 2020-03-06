--===============================================================================================================================--
-- This script will create the full folder structure accordingly to MD Workflow ;
-- Also will add a Max file with proper name and geometries of the mannies you need.

-- author: Riff-Raff
--===============================================================================================================================--

-- Free flow process - creating temp folder for future purposes
tempfStructFolder = "C:\Users\Public\Documents\fStructX\\"
		isFolderExist = doesFileExist tempfStructFolder
			if	( isFolderExist == false ) then
			makeDir tempfStructFolder all:false
			
--=============
--UI
--=============
			
try ( destroyDialog fStruct) catch () --destroys previous dialog if one is open

rollout fStruct "folderStructure" width:288 height:424
(
--	Header
	local img_header = @"$userScripts\BorakaScriptPack_vol1\imgs\fstructox_header.bmp"
	local img_header_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\fstructox_header_mask.bmp"
	button header "" pos:[0,0] width:288 height:37 align:#left enabled:false border:false images:#(img_header, img_header_mask, 1, 1, 1, 1, 1)
--	pick a location
	GroupBox 'grpPick' "* Pick the new garment folder :" pos:[8,44] width:272 height:64 align:#left
	local img_pick = @"$userScripts\BorakaScriptPack_vol1\imgs\pickButton.bmp"
	local img_pick_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\pickButton_mask.bmp"
	button 'pickLocation' "" pos:[25,71] width:64 height:24 align:#left border:false images:#(img_pick, img_pick_mask, 1, 1, 1, 1, 1)
	edittext 'editLocation' "" pos:[95,71] width:177 height:24 readOnly:false text:"..please set a path" align:#left
-- chose a mannequins file
	GroupBox 'groupMannies' "* Choose a max file you need" pos:[8,122] width:272 height:157 align:#left
	checkbox 'checkMans' "" pos:[24,142] width:16 height:24 align:#left enabled:false tooltip: "*This will create a max file with full range of male mannequins"
	checkbox 'checkWomens' "" pos:[24,166] width:16 height:24 align:#left enabled:false tooltip: "*This will create a max file with full range of female mannequins"
	checkbox 'checkBoysAndGirls' "" pos:[24,192] width:16 height:24 align:#left enabled:false tooltip: "*This will create a max file with full range of Young athlethes mannequins"

	label 'lblM' "M - Mannequins file" pos:[44,147] width:98 height:16 align:#left enabled:false
	label 'lblW' "W - Mannequins file" pos:[44,171] width:98 height:16 align:#left enabled:false
	label 'lblGB' "G/B - Mannequins file" pos:[45,196] width:114 height:16 align:#left enabled:false
--	max file correct name
	label 'lblMaxName' "max file name :" pos:[21,229] width:139 height:16 align:#left
	edittext 'showMaxName' "" pos:[16,246] width:248 height:24 readOnly:true align:#left
--	create button
	local img_create = @"$userScripts\BorakaScriptPack_vol1\imgs\createButton.bmp"
	local img_create_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\createButton_mask.bmp"
	local img_create_disable = @"$userScripts\BorakaScriptPack_vol1\imgs\createButton_disable.bmp"
	local buttonCrtfStrctsToolTip =  "1. LMB = Create folders,max or both" + "\n" + "2. RMB = Open location"
	button 'createfStruct' "" pos:[10,289] width:240 height:40 align:#left border:false images:#(img_create, img_create_mask, 1, 1, 1, 1, 1) tooltip: buttonCrtfStrctsToolTip 
	colorPicker 'cp1' "" pos:[255,289] width:24 height:40 enabled:false color:[255,0,0] title:"" align:#left
-- 	legend
	GroupBox 'grpLegend' "* Info" pos:[8,336] width:272 height:48 align:#left
	label 'legendInfo' "M - Men  ::  W - Women  ::  B - Boys  ::  G - Girls" pos:[30,358] width:239 height:18 align:#left
--	author
	local img_footer = @"$userScripts\BorakaScriptPack_vol1\imgs\fstructox_footer.bmp"
	local img_footer_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\fstructox_footer_mask.bmp"
	button footer "" pos:[0,394] width:288 height:30 align:#left enabled:false border:false images:#(img_footer, img_footer_mask, 1, 1, 1, 1, 1) tooltip: "Created by : riff raff - Borislav Borisov"

--=============
-- FUNCTIONS
--=============

fn createObjFolder =
	(
		objFolder = maxFilePath + "\\Obj\\MD\\"
		isFolderExist = doesFileExist objFolder
			if	( isFolderExist == false ) then
			makeDir objFolder all:true
	)

fn createMapsFolder =
	(
		mapsFolder = maxFilePath + "\\Maps\\"
		isFolderExist = doesFileExist mapsFolder
			if	( isFolderExist == false ) then
			makeDir mapsFolder all:false
	)

fn createRefFolder =
	(
		refFolder = maxFilePath + "\\Ref\\"
		isFolderExist = doesFileExist refFolder
			if	( isFolderExist == false ) then
			makeDir refFolder all:false
	)

fn createGarmentsFolder =
	(
		garmentsFolder = maxFilePath + "\\Garments\\"
		isFolderExist = doesFileExist garmentsFolder
			if	( isFolderExist == false ) then
			makeDir garmentsFolder all:false
	)

fn createRendersFolder =
	(
		rendersFolder = maxFilePath + "\\Renders\\"
		isFolderExist = doesFileExist rendersFolder
			if	( isFolderExist == false ) then
			makeDir rendersFolder all:false
	)
	
fn showMe = 
	(
		elements = filterstring editLocation.text "\\"
		maxPathLastitem = elements[elements.count] + ".max"
		showMaxName.text = maxPathLastitem
	)

fn HideMe =
(
	showMaxName.text = ""
)

fn wrongPath =
(
	if (editLocation.text == "")then
		(
		editLocation.text = "wrong or missing Path"
		messagebox "* Please , DON'T leave the path field empty !!!"
		lblM.enabled = false
		lblW.enabled = false
		lblGB.enabled = false
		checkMans.enabled = false
		checkWomens.enabled = false
		checkBoysAndGirls.enabled = false
		createfStruct.enabled = false
		createfStruct.images = #(img_create_disable, img_create_mask, 1, 1, 1, 1, 1)
		)
)

fn idleLights =
(
	cp1.color = [255,0,0]
)

fn fLights =
(
	cp1.color = [255,216,0]
)

fn fmLights =
(
	cp1.color = [0,186,255]
)

--rightclick on Create button
fn rightClickOpenLocation =
(
	NewGarmentPath = editLocation.text
	if ( NewGarmentPath == "..please set a path" or NewGarmentPath == "") then
			(
				messagebox "The path is still not defined ! Please ,set a path first." beep:true title:"f-StructX warning message"
			
			)
	else
			(
				shellLaunch "explorer.exe" NewGarmentPath
			)
)

--=====================
-- MAIN
--=====================

-- get a path where to save folders and a max file
	on pickLocation pressed do
	(
		NewGarmentPath = getSavePath caption:"*** SELECT a folder where to generate MD folder structure - fStruct" initialdir:tempfStructFolder 
		if ( NewGarmentPath != undefined ) then
				(
					editLocation.text = NewGarmentPath
					lblM.enabled = true
					lblW.enabled = true
					lblGB.enabled = true
					checkMans.enabled = true
					checkWomens.enabled = true
					checkBoysAndGirls.enabled = true
					createfStruct.enabled = true
					createfStruct.images = #(img_create, img_create_mask, 1, 1, 1, 1, 1)
				)
	)

-- Select which mannequins file

	on checkMans changed theState do
	(
		idleLights()
		HideMe()
		wrongPath()
		if (checkMans.state == true )	then
		(
		checkWomens.state = false
		checkBoysAndGirls.state = false
		showMe()
		)
	)

	on checkWomens changed theState do
	(
		idleLights()
		HideMe()
		wrongPath()
		if (checkWomens.state == true)	then
		(
		checkMans.state = false
		checkBoysAndGirls.state = false
		showMe()
		)
	)

	on checkBoysAndGirls changed theState do
	(
		idleLights()
		HideMe()
		wrongPath()
		if (checkBoysAndGirls.state == true)	then
		(
		checkMans.state = false
		checkWomens.state = false
		showMe()
		)
	)

-- CREATING FOLDERS AND MAX

	-- just do it button
		on createfStruct pressed do
		(
			clearlistener()
			NewGarmentPath = editLocation.text
			maxPathLastitem = showMaxName.text
			newMaxFileSavePath = NewGarmentPath + "\\" + maxPathLastitem

				if (NewGarmentPath == editLocation.text) then
					(
						if (editLocation.text == "..please set a path" or editLocation.text == "") then
							(
								messagebox "The path is still not defined ! Please ,set a path first." beep:true title:"f-StructX warning message"
							)
							else
							(
								if (checkMans.state == true or checkWomens.state == true or checkBoysAndGirls.state == true)then
									(
										-- load existing max files
										if (checkMans.state == true) then
											(
												loadMaxfile "M:\MD_N\Garments\00_MD Garment Folder Structure\ST_MENS_Mannequins_Low.max" quiet:true
											)
										if (checkWomens.state == true) then
											(
												loadMaxfile "M:\MD_N\Garments\00_MD Garment Folder Structure\ST_WOMENS_Mannequins_Low.max" quiet:true
											)
										if (checkBoysAndGirls.state == true) then
											(
												loadMaxfile "M:\MD_N\Garments\00_MD Garment Folder Structure\ST_YOUNG_ATHLETES_Mannequins_Low.max" quiet:true
											)
												-- save  max file
												newMaxFileSavePath = editLocation.text + "\\" + maxPathLastitem 
												isMaxFileExist = doesFileExist newMaxFileSavePath
													if ( isMaxFileExist == false) then 
														(
															if (showMaxName.text != editLocation.text ) then
																(
																	newMaxFileSavePath = editLocation.text + "\\" + maxPathLastitem 
																	isMaxFileExist = doesFileExist newMaxFileSavePath
																	if ( isMaxFileExist == true) then 
																		(
																				messageExist = "* Max file with this name already exists ! Can't be overwritten! "
																			messagebox messageExist beep:true title:"f-StructX warning message"
																			idleLights()
																	
																		)
																	else
																		(
																			showMaxName.text = showMe()
																		--messagebox "* Wrong maxfile name detected! Its corrected now ! " beep:true
																		-- save  max file
																		correctedNameSaveFile = NewGarmentPath + "\\" + showMaxName.text
																		saveMaxfile correctedNameSaveFile
																		message = " * Executed processes = 2 / 2 : " + "\n" + "\n" + "      Folders -- DONE" + "\n" + "\n"+ "      Max file -- DONE"
																		messagebox message beep:false title:"f-StructX statistics"
																		fmLights()
																		)
																		
																)	
																else
																(
																	saveMaxfile newMaxFileSavePath
																	message = " * Executed processes = 2 / 2 : " + "\n" + "\n" + "      Folders -- DONE" + "\n" + "\n"+ "      Max file -- DONE"
																	messagebox message beep:false title:"f-StructX statistics"
																	fmLights()
																)
														)
													else
													(
														messageExist = "* Max file with this name already exists ! Can't be overwritten! "
														messagebox messageExist beep:true title:"f-StructX warning message"
														idleLights()
													)
											
									)
								else
									(
										-- message only for folder creation
										message = " * Executed processes = 1 / 2 : " + "\n" + "\n" + "      Folders -- DONE" + "\n" + "\n"+ "      Max file -- FAILED"
										messagebox message beep:false title:"f-StructX statistics"
										fLights()
									)

								--creating folder structure if the folders doesn't exist
							createGarmentsFolder()
							createObjFolder()
							createMapsFolder()
							createRefFolder()
							createRendersFolder()

								-- printing some info
							foldersCreated = "The fStruct generated in: " + NewGarmentPath
							print foldersCreated
							maxfilesCreated = "New .max file created: " + maxPathLastitem
							print maxfilesCreated
							printMaxfiles = getFiles (NewGarmentPath + "\\*.max")
							print "Existing max files :"
							print printMaxfiles
						)
					)
		)
		
		on createfStruct rightClick do
		(
			rightClickOpenLocation()
		)
	)
createDialog fStruct
