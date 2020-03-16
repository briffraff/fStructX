--===============================================================================================================================--

--==f-structX v0.1 - 20/03/2018
-----------------------............................
--  This script will create the whole folder structure according to MD Workflow ;
--  Also will add a .max file with proper name and geometries of the mannies you need.
--  right click on 'create' will take you in the garment root.

--==f-structX v0.2 , fStructImporter v0.1 , fStructShell v0.1 , fStructTimer v0.1 - 28/04/2018
-----------------------*****************************************************................................
-- it has a function to read two folders , where you can find OBJ and MD objects.
-- counter of objs - t:total s:selected
-- switch to fbx reading 
-- counter of fbx's
-- has a import function - multiimport of objs.
--  set imported objects to the right layer - '4_Product'.
-- move objects with 100mm next to each other.
--  refresh the lists - right click on 'import'.
-- search engine - highlight the found objects.
-- generate a statistic - txt file with statistic of full range of objs ,date and garment root path and last author name
-- automatic material generator . - diffuse ,normal maps-NH-0,NH-1,NH-2,NH-3,Dri-fit,Normal-blank ,Opacity
-- time execution - calculate import timing + time to add material. 
-- right click menu.
-- execute poly reduce program - Balancer .
-- execute Photoshop and load Uv map of the garment into it.
-- shell system - set inner amount ,delete the polys ,arrange the uv elements and finish it.
-- timer - you are able to calculate working time.
-- search for variation normal - add variation to the material name also
-- fix the Smoothing groups of imported object
-- fix the freespaces chars
-- search for the last updated obj and lighten it
-- falloff mixcurve
-- diffuse instances slots
-- normal maps override:1.0
-- copy name from the list - RC menu
-- copy the root path - right click on pick button

--==f-structX v0.2 , fStructImporter v0.1 , fStructShell v0.1 , fStructTimer v0.1 - 07/07/2018
-----------------------*****************************************************................................
--open button - open the max file according working path
--validation sensor - if max file exist
--lastOne button highlighted
--garment number dynamic label 

--==f-structX v0.2 , fStructImporter v0.1 , fStructShell v0.1 , fStructTimer v0.1 - 10/10/2018
-----------------------*****************************************************................................
-- auto renaming of the files that contains _normals - while generate material

--==  fStructShell v0.2- 2019-12-01
-----------------------*****************************************************................................
-- update the crew members
-- Enable-Disable option for hint messages during the shell process - checkbutton
-- maximum zooming of thumbnails - width*x3(clicks)

--==  fStructShell v0.3- 2019-19-01
-----------------------*****************************************************................................
-- validation for NH Simulations and Normal Maps - Review
-- create UE folder
-- installator

--==f-structX v0.2 , fStructImporter v0.1 , 
-----------------------*****************************************************................................
-- mass importer mode button- you can import multiple object with proper materials which are already collected in a folder and also folder with a psd`s
-- dtail start up scene
-- creating dxf folder
-- add Levis functionalities


-- author // Riff-Raff: : Borislav Borisov
--last mod date: 2020-16-01 / 23:15

--===============================================================================================================================--

global tempfStructFolder = @"C:\Users\Public\Documents\fStructX\"
global exportFilelog = @"C:\Users\Public\Documents\fStructX\log.txt"
global fstructxIniFile = @"C:\Users\Public\Documents\fStructX\fstructXIni.ini"
global version = "v3.02.7"
global lastModification = "12 March 2020 by RiffRaff"
global currentYear = "2020"
global theCrew = "Borko,Ana,Dido,Mariq,Petya,Zara,Hristiyana,Marina,Mims,Margi,MimiG,Sasho,Andji,Iliqna,Lybomira"
global aboutInfoAuthorVersion = ""
global iniSectionDates = "Dates"
global iniSectionInfo = "Info"
global iniSectionUsedGarments = "LastUsedGarments"
global scriptName = "fStructX"
global author = "RiffRaff"
global creationDate = "10 Feb 2018"
global cleanAll = "/ CLEAN ALL"
global errorMessageTitle = "Something went wrong ! Try again!"
global okMessage = "Process completed !"
global fTitle = "fStructX | Importer"
global cleanMessage = "Paths wouldn't be available yet! Do you want to continue ?"
global forbidenPath = "Sorry, forbidden path!"
global checkYourFolderName = "Check your folder name! [ex: g.code_g.name]"
global pleaseSetPath = "..please set a path"
global baseValue = 9
global sysBarH = 31
global freeSpaceH = 1
global freeSpaceW = 1
global winW = 150
global winH = 2*winW/2
global pdHeight = sysBarH - winH - 274
global pdWidth1 = baseValue + freeSpaceW
global pdWidth2 = baseValue + 2*freeSpaceW + winW
global pdWidth3 = baseValue + 3*freeSpaceW + 2*winW
global pdHeight3 = sysBarH + 2*freeSpaceH 
global fStruct
global fStructShellTimer	
global fStructImporter
global loadFrontAndBack
global enableMassImporter
global newGarmentPath = undefined
global theUVpath = undefined
global theLastObjectName = undefined
global extObj = "\\*.obj"
global extFbx = "\\*.fbx"
global filesObjArr = undefined
global mtl = "\\*.mtl"
		
try ( destroyDialog fStruct) catch ()
	
-- Free flow code which functions is to generate temp folder called fStructX
isFolderExist = doesFileExist tempfStructFolder
if	( isFolderExist == false ) then
(
	makeDir tempfStructFolder all:false	
)

if(doesFileExist fstructxIniFile == false) then
(
	--create initial file
	iniCreate = createFile fstructxIniFile
	format "\t" to:iniCreate
	close iniCreate

	--put initial sections,keys,values
	-- Dates
	setIniSetting fstructxIniFile iniSectionDates "creationDate" creationDate
	setIniSetting fstructxIniFile iniSectionDates "lastModification" lastModification
	setIniSetting fstructxIniFile iniSectionDates "currentYear" currentYear
	
	-- Info
	setIniSetting fstructxIniFile iniSectionInfo "scriptName" scriptName
	setIniSetting fstructxIniFile iniSectionInfo "version" version
	setIniSetting fstructxIniFile iniSectionInfo "author" author
	setIniSetting fstructxIniFile iniSectionInfo "marvCrew" theCrew
	
	-- Used Garments
	setIniSetting fstructxIniFile iniSectionUsedGarments cleanAll cleanMessage
)
	
if(doesFileExist exportFilelog == false) then
(
	cf = createFile exportfilelog
	format "FSTRUCTX SCRIPT!\n" to:cf
	close cf
)
	
--==========
--FN in rightclick menu
--==========
	
--Function for Photoshop
fn LocatePSAndLoadUVmap =
(
	local ps = getIniSetting (getMAXIniFile()) "photoshop" "path"
	
	if ps == "" do
	(
		messagebox "Please locate Photoshop.exe file ! -> " beep:false

		local ps = getOpenFileName caption:"Please locate 'Photoshop.exe' file" filename:"C:/Program files/Adobe Photoshop CC 2015/Photoshop.exe" types:"Executable Files(*.exe)|*.exe"
		
		if (ps != undefined) do 
			(
				setINISetting (getMAXIniFile()) "photoshop" "path" ps
			)
	)
	
	if ps != undefined AND doesFileExist ps then
			(
				--Filter and get the name of UV map
				theUVpath = fStruct.editLocation.text
				theUVpathIdx = filterstring theUVpath "\\:"
				theUVpathLastIdx = theUVpathIdx[theUVpathIdx.count]
				filterTheLastIdx = filterstring theUVpathLastIdx "_"
				getTheFirstString = filterTheLastIdx[1]
				firstIdxUV = getTheFirstString
				uvMapName = firstIdxUV + "_UV.jpg"
				format "-> Photoshop : % is opening\n" uvMapName
				
				--set the path to UV map
				uvmapPath = theUVpath + "\\Maps\\" + uvMapName
				print uvmapPath
				
				--launch Photoshop with the picked uv
				shellLaunch ps uvmapPath
			)
	else
			(
			delINISetting (getMAXIniFile()) "photoshop" "path"
			messagebox "Photoshop could not be found !Try again"
			)
)

--function for Balancer
fn executeBalancerReduce = 
(
	
local balnsr = getIniSetting (getMAXIniFile()) "balancer" "path"
	
	if balnsr == "" do
	(
		messagebox "Please locate Balancer64.exe file ! -> " beep:false

		local balnsr = getOpenFileName caption:"Please locate 'Balancer64.exe' file" filename:"C:\Program Files (x86)\Atangeo\Balancer nPro and Decimon\BalancerNPro64.exe" types:"Executable Files(*.exe)|*.exe"
		
		if (balnsr != undefined) do 
			(
				setINISetting (getMAXIniFile()) "balancer" "path" balnsr
			)
	)
	
	if balnsr != undefined AND doesFileExist balnsr then
			(
				--on OBJ folder
				itemsObjNames = fStructImporter.listObj.items
				itemObjIdx = fStructImporter.listObj.selection
				--on MD folder
				itemsMdNames = fStructImporter.listObjMd.items
				itemMdIdx = fStructImporter.listObjMd.selection
		
				if (itemObjIdx != 0)do
				(					
					for a in itemObjIdx do
						(
							--launch Atangeo Balancer 
							theItem = "\"" + newGarmentPath + "/Obj/" + itemsObjNames[a] + "\"" -- path with whitespaces should be double quoted to be used by 'shelllaunch'
							shelllaunch balnsr theItem
							format "-> BALANCER : %\n" itemsObjNames[a]							
						)
						format "\n"
				)
					
				if (itemMdIdx != 0)do 
				(	
					for a in itemMdIdx do
						(
							--launch Atangeo Balancer
							theItem = "\"" + newGarmentPath + "/Obj/MD/" + itemsMdNames[a] + "\""
							shelllaunch balnsr theItem						
							format "-> BALANCER : %\n" itemsMdNames[a]
						)
						format "\n"
				)
			)
	else
			(
			delINISetting (getMAXIniFile()) "balancer" "path"
			messagebox "Balancer could not be found !Try again"
			)
)
	
fn copyThatName =
(
	--on OBJ folder
	itemsObjNames = fStructImporter.listObj.items
	itemObjIdx = fStructImporter.listObj.selection
	
	--on MD folder
	itemsMdNames = fStructImporter.listObjMd.items
	itemMdIdx = fStructImporter.listObjMd.selection

	if (itemObjIdx != 0)do
	(	
		for a in itemObjIdx do
		(
			--copy name 
			selectedName = filterstring itemsObjNames[a] "."
			selectedNameTrimed = setClipBoardText selectedName[1]	
			format "% copied\n" selectedNameTrimed
		)		
		format "\n"
	)
		
	if (itemMdIdx != 0)do 
	(	
		for a in itemMdIdx do
		(
			--copy name
			selectedName = filterstring itemsMdNames[a] "."
			selectedNameTrimed = setClipBoardText selectedName[1]	
			format "% copied\n" selectedNameTrimed
		)
		format "\n"
	)
)

--=====
--RCMenu
--=====
rcmenu fStructRightClickMenuBalancer
(
	menuItem executeBalancer "Execute Balancer" checked:false 
	menuItem uvToPs "UVmap to Photoshop" checked:false
	menuItem copyThat "!Copy" checked:false

	on fStructRightClickMenuBalancer open do
		(
			print "Right click menu : OPEN"
		)
		
	--when copythat is picked
	on copyThat picked do 
		(
			copyThatName()
		)
	
	--when uvToPs - photoshop is picked 	
	on uvToPs picked do 
		(
			LocatePSAndLoadUVmap()
		)
	
	--when executeBalancer is picked
	on executeBalancer picked do 
		(
			executeBalancerReduce()
		)
)

fn collectionReversed = 
(
	--get keys
	local sectionKeys = getIniSetting fstructxIniFile iniSectionUsedGarments
	--get values
	local sectionKeysValues = for i in sectionKeys collect (getIniSetting fstructxIniFile iniSectionUsedGarments i)
	-- reverse collection
	local reverseCollection = for i = sectionKeys.count to 1 by -1 collect sectionKeys[i]
)

fn versionInfo = 
(
	local getAuthor = getIniSetting fstructxIniFile iniSectionInfo "author"
	local getVersion = getIniSetting fstructxIniFile iniSectionInfo "version"
	
	if(getVersion != version) then
	(
		setIniSetting fstructxIniFile iniSectionInfo "version" version
		local msgFeaturesUpdated = "New features activate - " + version
		messagebox msgFeaturesUpdated beep:false title:(scriptName + " | " + version)
	)
	
	local aboutInfoAuthorVersion = getVersion + " | " + getAuthor
)

--F-STRUCTx ROLLOUT START --
rollout fStruct "folderStructure" width:288 height:424 --define a rollout 
(
	local collection = collectionReversed()
	local version = versionInfo()
	
--	Header
	local img_header = @"$userScripts\BorakaScriptPack_vol1\imgs\fstructox_header.bmp"
	local img_header_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\fstructox_header_mask.bmp"
	button header "" pos:[0,0] width:288 height:37 align:#left enabled:false border:false images:#(img_header, img_header_mask, 1, 1, 1, 1, 1)
--	pick a location
	GroupBox grpPick "* Pick the new garment folder :" pos:[8,42] width:272 height:74 align:#left
	local img_pick = @"$userScripts\BorakaScriptPack_vol1\imgs\pickButton.bmp"
	local img_pick_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\pickButton_mask.bmp"
	button pickLocation "" pos:[20,63] width:64 height:24 align:#left border:false images:#(img_pick, img_pick_mask, 1, 1, 1, 1, 1)
	edittext editLocation "" pos:[90,63] width:180 height:24 readOnly:false text:pleaseSetPath align:#left
	dropdownlist choseGarment pos:[20,91] width:251 height:10 items:collection selection:0 tooltip:"List of used garments"

-- chose a mannequins file
	GroupBox groupMannies "* Choose a max file you need" pos:[8,122] width:272 height:157 align:#left
	checkbox checkMans "" pos:[24,142-5] width:16 height:24 align:#left enabled:false tooltip: "*This will create a max file with full range of male mannequins"
	checkbox checkWomens "" pos:[24,162-5] width:16 height:24 align:#left enabled:false tooltip: "*This will create a max file with full range of female mannequins"
	checkbox checkBoysAndGirls "" pos:[24,182-5] width:16 height:24 align:#left enabled:false tooltip: "*This will create a max file with full range of Young athlethes mannequins"
	checkbox checkDtail "" pos:[24,202-5] width:16 height:24 align:#left enabled:false tooltip: "*This will create a max file with Dtail mannequins"

	label lblM "M - Mannequins file" pos:[44,142] width:98 height:16 align:#left enabled:false
	label lblW "W - Mannequins file" pos:[44,162] width:98 height:16 align:#left enabled:false
	label lblGB "G/B - Mannequins file" pos:[45,182] width:114 height:16 align:#left enabled:false
	label lblDtail "Dtail - Mannequins file" pos:[45,202] width:114 height:16 align:#left enabled:false
		
	button openMax "OpenMax" pos:[210,135] width:64 height:24 border:true enabled:false tooltip: "*Open the .max file"
	colorPicker valMax "" pos:[198,135] width:12 height:24 enabled:false color:[255,0,0] title:""
	
	label lblHanger "Hangers" pos:[218,172] width:60 height:16 align:#left enabled:false tooltip: "Check Hanging Simulation"
	colorPicker valHanger "" pos:[198,165] width:12 height:24 enabled:false color:[255,0,0] title:""

--	max file correct name
	label lblMaxName ".max file name :" pos:[21,229] width:139 height:16 align:#left
	edittext showMaxName "" pos:[16,246] width:248 height:24 readOnly:true align:#left
	
--	create button
	local img_create = @"$userScripts\BorakaScriptPack_vol1\imgs\createButton.bmp"
	local img_create_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\createButton_mask.bmp"
	local img_create_disable = @"$userScripts\BorakaScriptPack_vol1\imgs\createButton_disable.bmp"
	local buttonCrtfStrctsToolTip =  "1. LMB = Create folders,max or both" + "\n" + "2. RMB = Open location"
	button createfStruct "" pos:[10,289] width:240 height:40 align:#left border:false images:#(img_create, img_create_mask, 1, 1, 1, 1, 1) tooltip: buttonCrtfStrctsToolTip 
	colorPicker cp1 "" pos:[255,289] width:24 height:40 enabled:false color:[255,0,0] title:"" align:#left
-- 	legend
	GroupBox grpLegend "* Info" pos:[8,336] width:272 height:48 align:#left
	label legendInfo "M - Men  ::  W - Women  ::  B - Boys  ::  G - Girls" pos:[30,358] width:239 height:18 align:#left
--	author
	local img_footer = @"$userScripts\BorakaScriptPack_vol1\imgs\fstructox_footer.bmp"
	local img_footer_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\fstructox_footer_mask.bmp"
	button footer "" pos:[0,394] width:288 height:30 align:#left enabled:false border:false images:#(img_footer, img_footer_mask, 1, 1, 1, 1, 1) tooltip:version
	

--=============
-- FUNCTIONS
--=============
	
fn rearangeIniFileAndDropDownUsedGarments =
(
	--split the string path
	local fltr = filterstring NewGarmentPath "\:"
	local fltrLastIdx = fltr[fltr.count]
	
	--get current kvp
	local currentKey = fltrLastIdx
	local currentValue = NewGarmentPath
	
	--make the current key more beauty
	local beautifyKey = (": [ " + currentKey as string + " ]")
	
	--check if exist at ini file
	isExists = hasIniSetting fstructxIniFile iniSectionUsedGarments beautifyKey
	
	if (isExists == true) then
	(
		--del
		delIniSetting fstructxIniFile iniSectionUsedGarments beautifyKey
	)
	
	--write
	setIniSetting fstructxIniFile iniSectionUsedGarments beautifyKey (currentValue as string)
)

fn refreshDropDownUsedGarments = 
(
	--refresh dropdown list
	local collection = collectionReversed()
	choseGarment.items = collection
	choseGarment.selection = 1
)

fn createObjFolder =
	(
		objFolder = editLocation.text + "\\Obj\\MD\\"
		isFolderExist = doesFileExist objFolder
			if	( isFolderExist == false ) then
			makeDir objFolder all:true
	)

fn createUEFolder =
	(
		ueFolder = editLocation.text + "\\Obj\\UE\\"
		isFolderExist = doesFileExist ueFolder
			if	( isFolderExist == false ) then
			makeDir ueFolder all:true
	)
	
fn createDxfFolder =
(
	dxfFolder = editLocation.text + "\\DXF\\"
	isFolderExist = doesFileExist dxfFolder
		if	( isFolderExist == false ) then
		makeDir dxfFolder all:true
)

fn createMapsFolder =
	(
		mapsFolder = editLocation.text + "\\Maps\\"
		isFolderExist = doesFileExist mapsFolder
			if	( isFolderExist == false ) then
			makeDir mapsFolder all:false
	)

fn createRefFolder =
	(
		refFolder = editLocation.text + "\\Ref\\"
		isFolderExist = doesFileExist refFolder
			if	( isFolderExist == false ) then
			makeDir refFolder all:false
	)

fn createGarmentsFolder =
	(
		garmentsFolder = editLocation.text + "\\Garments\\"
		isFolderExist = doesFileExist garmentsFolder
			if	( isFolderExist == false ) then
			makeDir garmentsFolder all:false
	)

fn createRendersFolder =
	(
		rendersFolder = editLocation.text + "\\Renders\\"
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
			lblDtail.enabled = false
			checkMans.enabled = false
			checkWomens.enabled = false
			checkBoysAndGirls.enabled = false
			checkDtail.enabled = false
			openMax.enabled = false
			valMax.enabled = false
			valMax.color = [255,0,0]
			lblHanger.enabled = false
-- 			lblHanger.color = [255,0,0]
			createfStruct.enabled = false
			createfStruct.images = #(img_create_disable, img_create_mask, 1, 1, 1, 1, 1)
			fStructImporter.listObj.items = #()
			fStructImporter.listObjMd.items = #()
			fStructImporter.searchtxt.text = "...search here"
			fStructImporter.enableImport.checked = false
			fStructImporter.importBtn.enabled = false
			fStructImporter.importBtn.text = "Import - locked"
			fStructImporter.chkBox_showFullPath.enabled = false		
			fStructImporter.enableImport.enabled = false
			fStructImporter.searchbtn.checked = false
			fStructImporter.searchbtn.enabled = false
			fStructImporter.searchtxt.enabled = false
			fStructShellTimer.showHideThumbs.checked = false
			fStructShellTimer.enableMassImporter.checked = false
		)
)

fn getFilesRecursive root pattern =
(	
	my_files = #()

	dir_array = GetDirectories (root+"/*")
	for d in dir_array do join dir_array (GetDirectories (d+"/*"))
	for f in dir_array do join my_files (getFiles (f + pattern))
	for del in my_files do deletefile del
-- 	counter =  my_files.count as string
-- 	txt = ".MTL files found : " + counter + "\n" + ".MTL files deleted : " + counter
-- 	messagebox txt
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
	if ( NewGarmentPath == pleaseSetPath or NewGarmentPath == "") then
			(
				messagebox "The path is still not defined ! Please ,set a path first." beep:true title:"f-StructX warning message"
			)
	else
			(
				shellLaunch "explorer.exe" NewGarmentPath
			)
)

--open the max file 
fn OpenDaMax = 
(
	maxpath = editLocation.text
	splitPath = filterstring maxpath "\\"
	lastElementOfPath = splitPath[splitPath.count] + ".max"
	maxExist = doesFileExist (maxpath + "\\" + lastElementOfPath)
	
	if	( maxExist == true ) then
	(
		valMax.color = [0,186,255]
		loadmaxfile (maxpath + "\\" + lastElementOfPath)
	)
	else
	(
		valMax.color = [255,0,0]
		msgNotExist = "' " + lastElementOfPath + "' " + "does not exist!"
		messagebox msgNotExist beep:true title:"fStruct message - error "
	)
)

--validate max file 
fn validateMax = 
(
	if ( editlocation.text != ""  ) then
	(
		maxpath = editLocation.text
		splitPath = filterstring maxpath "\\"
		lastElementOfPath = splitPath[splitPath.count] + ".max"
		maxExist = doesFileExist (maxpath + "\\" + lastElementOfPath)
		
		if	( maxExist == true ) then
		(
			valMax.color = [0,186,255]
		)
		else
		(
			valMax.color = [255,0,0]
		)
	)
)

--validate Hanger Simulations and Maps
fn validateHangingMsgs =
(
	if( editlocation.text != "" ) then 
	(
		--check for nh obj simulations
		objFolder = editlocation.text + "\\Obj\\"
		NhSimulationsPattern = "SM_N??????_NH-?_?_Reduced.obj"
		NhFoundedSimulations = getFiles (objFolder + NhSimulationsPattern)
		simFiles = for s in NhFoundedSimulations collect (filenameFromPath s)
		
		--check for nh maps
		mapsFolder = editlocation.text + "\\Maps\\"
		NhMapsPattern = "T_N??????_NH-?_?_N.jpg"
		NhFoundedMaps = getFiles (mapsFolder + NhMapsPattern)
		mapsFiles = for m in NhFoundedMaps collect (filenameFromPath m)
		
		--if simulations found
		if(NhFoundedSimulations.count != 0) then
		(
			--if maps found
			if(NhFoundedMaps.count != 0) then
			(
				-- if simulations and maps are equal (if not then check the review)
				if(NhFoundedSimulations.count == NhFoundedMaps.count) then
				(
					valHanger.color = [0,186,255]
				)
				else
				(
					s = "	"
					simulationsCount = s + "Simulations :" + s + "[ " + NhFoundedSimulations.count as string + " ]"
					normalMapsCount = s + "Normal maps :" + s + "[ " + NhFoundedMaps.count as string + " ]"
					differenceInCountText = (toUpper "Please review the simulations and normal maps count!")
					
					--concat the objects in a string
					simFilesList = ""
					for sim in simFiles do append simFilesList (s + s + sim + "\n")
					mapsFilesList =""
					for map in mapsFiles do append mapsFilesList (s + s + map + "\n")
					
					--print this concat
					validationToPrint = (differenceInCountText) + 
										("\n\n") + 
										(simulationsCount + "\n\n" + simFilesList) +
										("\n\n") + 
										(normalMapsCount +  "\n\n" + mapsFilesList)
					
					messagebox validationToPrint beep:false title:"f-StructX warning message"
				)
			)
			else
			(
				messagebox (toUpper "Normal maps for hanging simulations are missing!") title:"f-StructX warning message"		
			)
		)
		else
		(
			messagebox (toUpper "Hanging simulations are missing!") title:"f-StructX warning message"
		)
	)
)


fn validateHanging =
(
	if( editlocation.text != "" ) then 
	(
		--check for nh obj simulations
		objFolder = editlocation.text + "\\Obj\\"
		NhSimulationsPattern = "SM_N??????_NH-?_?_Reduced.obj"
		NhFoundedSimulations = getFiles (objFolder + NhSimulationsPattern)
		simFiles = for s in NhFoundedSimulations collect (filenameFromPath s)
		
		--check for nh maps
		mapsFolder = editlocation.text + "\\Maps\\"
		NhMapsPattern = "T_N??????_NH-?_?_N.jpg"
		NhFoundedMaps = getFiles (mapsFolder + NhMapsPattern)
		mapsFiles = for m in NhFoundedMaps collect (filenameFromPath m)
		
		--if simulations found
		if(NhFoundedSimulations.count != 0) then
		(
			--if maps found
			if(NhFoundedMaps.count != 0) then
			(
				-- if simulations and maps are equal (if not then check the review)
				if(NhFoundedSimulations.count == NhFoundedMaps.count) then
				(
					valHanger.color = [0,186,255]
				)
				else
				(
					valHanger.color = [255,0,0]
				)
			)
			else
			(
				valHanger.color = [255,0,0]
			)
		)
		else
		(
			valHanger.color = [255,0,0]
		)
	)
)

fn openProperties = 
(
	lblM.enabled = true
	lblW.enabled = true
	lblGB.enabled = true
	lblDtail.enabled = true
	checkMans.enabled = true
	checkWomens.enabled = true
	checkBoysAndGirls.enabled = true
	checkDtail.enabled = true
	openMax.enabled = true
	lblHanger.enabled = true
	createfStruct.enabled = true
	createfStruct.images = #(img_create, img_create_mask, 1, 1, 1, 1, 1)
	fStructImporter.FillListboxes newGarmentPath extObj
	fStructImporter.searchtxt.text = "...search here"
	fStructImporter.searchtxt.text = ""
	fStructImporter.creatingLog()
	fStructImporter.listObj.selection = 0
	fStructImporter.listObjMD.selection = 0
	fStructImporter.enableImport.enabled = true
	fStructImporter.chkBox_showFullPath.enabled = true
	-- delete the .mtl
	getFilesRecursive NewGarmentPath mtl
	
	--mass importer mode
	fStructShellTimer.enableMassImporter.checked = false
	
	--thumbs
	fStructShellTimer.showHideThumbs.checked = true
	theThumbsScript = @"$userScripts\BorakaScriptPack_vol1\loadThumbs.ms"
	isScriptExist = doesfileExist theThumbsScript
	if (isScriptExist == true) then
	fileIn theThumbsScript
	
	--max file
	validateMax()
	validateHanging()
	
	-- garment number label
	fStructImporter.garmentNumberLabel()
)

fn closeProperties = 
(
	editLocation.text = "wrong or missing Path"
	messagebox "* Please , DON'T leave the path field empty !!!"
	lblM.enabled = false
	lblW.enabled = false
	lblGB.enabled = false
	lblDtail.enabled = false
	checkMans.enabled = false
	checkWomens.enabled = false
	checkBoysAndGirls.enabled = false
	checkDtail.enabled = false
	openMax.enabled = false
	valMax.enabled = false
	valMax.color = [255,0,0]
	lblHanger.enabled = false
-- 			lblHanger.color = [255,0,0]
	createfStruct.enabled = false
	createfStruct.images = #(img_create_disable, img_create_mask, 1, 1, 1, 1, 1)
	fStructImporter.listObj.items = #()
	fStructImporter.listObjMd.items = #()
	fStructImporter.searchtxt.text = "...search here"
	fStructImporter.enableImport.checked = false
	fStructImporter.importBtn.enabled = false
	fStructImporter.importBtn.text = "Import - locked"
	fStructImporter.chkBox_showFullPath.enabled = false		
	fStructImporter.enableImport.enabled = false
	fStructImporter.searchbtn.checked = false
	fStructImporter.searchbtn.enabled = false
	fStructImporter.searchtxt.enabled = false
	fStructShellTimer.showHideThumbs.checked = false
	fStructShellTimer.enableMassImporter.checked = false
)


fn checkForCorrectInput workPath lastElement= 
(
	isEmptyPath = (workPath != "")
	isNotSet = (workPath !=pleaseSetPath)
	isFolder = (lastElement != "Obj" and lastElement != "Maps" and lastElement != "Garments" and lastElement != "Renders" and lastElement != "FBX" and lastElement != "Ref")
	
	print ("is path result : " + isFolders as string + "|" +isEmptyPath as string +"|"+ isNotSet as string) 
	
	local result = (isEmptyPath and isNotSet and isFolder)
)
--=====================
-- MAIN
--=====================


-- get a path where to save folders and a max file
on pickLocation pressed do
(
	NewGarmentPath = getSavePath caption:"*** SELECT a folder where to generate MD folder structure - fStruct" initialdir:tempfStructFolder 
	
	if (NewGarmentPath != "") then
	(
		local input = filterstring NewGarmentPath "\:"
		local lastelement = input[input.count]
		local lastElementParts = (filterstring lastelement "_").count
	)
	
	result = checkForCorrectInput NewGarmentPath lastelement
	isInitialFolder = (lastelement == "fStructX")
	
	if ( NewGarmentPath != undefined ) then
	(
		if (result) then 
		(
			if(lastElementParts == 2 or isInitialFolder) then
			(
				editLocation.text = NewGarmentPath
			
				openProperties()
				rearangeIniFileAndDropDownUsedGarments()
				refreshDropDownUsedGarments()
			)
			else if(lastElementParts > 2) then
			(
				editLocation.text = checkYourFolderName
			)
		)
		else
		(
			editLocation.text = forbidenPath
		)
	)
)
	
on pickLocation rightclick do
(
	if ( NewGarmentPath != undefined ) then
		(
			setClipBoardText NewGarmentPath
		)
	else
		(
			toppie = "###- TOPPIE JOPPIE by marvCrew -###\n"
			bgMarvCrew = "[ " + (getIniSetting fstructxIniFile iniSectionInfo "marvCrew") + " ]" + "\n"
			year = "=> " + (getIniSetting fstructxIniFile iniSectionDates "currentYear") + "\n"
			local concatElements = toppie + bgMarvCrew + year
			setClipBoardText concatElements
		)
)
	
on editLocation entered txtPathInput do
(
	wrongPath()
	
	if (txtPathInput != "") then
	(
		local input = filterstring txtPathInput "\:"
		local lastelement = input[input.count]
		local lastElementParts = (filterstring lastelement "_").count
	)
		
	result = checkForCorrectInput txtPathInput lastelement
	isInitialFolder = (lastelement == "fStructX")
	
	if (result) then 
	(
		if(lastElementParts == 2 or isInitialFolder) then
		(
			NewGarmentPath = editLocation.text
	
			openProperties()
			rearangeIniFileAndDropDownUsedGarments()
			refreshDropDownUsedGarments()
		)
		else if(lastElementParts > 2) then
		(
			editLocation.text = checkYourFolderName
		)
	)
	else
	(
		editLocation.text = forbidenPath
	)
)

on choseGarment selected i do 
(
	--get current kvp
	local currentSelection = choseGarment.items[i]
	local currentValue = (getIniSetting fstructxIniFile iniSectionUsedGarments currentSelection)
	format "You selected '%' - '%'!\n" currentSelection currentValue

	if(currentSelection != undefined and currentSelection != cleanAll) then
	(			
		--attach new name
		NewGarmentPath = currentValue
		editLocation.text = NewGarmentPath
		
		openProperties()
					
		--check if exist at ini file
		isExists = hasIniSetting fstructxIniFile iniSectionUsedGarments (currentSelection as string)
		
		if (isExists == true) then
		(
			--del
			delIniSetting fstructxIniFile iniSectionUsedGarments (currentSelection as string)
		)
		--write
		setIniSetting fstructxIniFile iniSectionUsedGarments (currentSelection as string) (currentValue as string)
		
		refreshDropDownUsedGarments()
	)
	else
	(
		IsCleanExist = hasIniSetting fstructxIniFile iniSectionUsedGarments cleanAll
		keysCollect = getIniSetting fstructxIniFile iniSectionUsedGarments
		
		cleanYesNo = queryBox cleanMessage title:fTitle beep:false
		if (cleanYesNo) then
		(			
			--check if click event is clean all
			if(IsCleanExist == true and currentSelection == cleanAll) then
			(
				--del all
				for key in keysCollect do
				(
					delIniSetting fstructxIniFile iniSectionUsedGarments key
				)
				
				-- Used Garments
				setIniSetting fstructxIniFile iniSectionUsedGarments cleanAll cleanMessage
				
				--restart text field
				editLocation.text = pleaseSetPath
				NewGarmentPath = undefined
				closeProperties()
			)
			
			--refresh dropdown list
			local collection = collectionReversed()
			choseGarment.items = collection
		)
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
	checkDtail.state = false
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
	checkDtail.state = false
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
	checkDtail.state = false
	showMe()
	)
)
	
on checkDtail changed theState do
(
	idleLights()
	HideMe()
	wrongPath()
	if (checkDtail.state == true)	then
	(
	checkMans.state = false
	checkWomens.state = false
	checkBoysAndGirls.state = false
	showMe()
	)
)
	
-- open the max file 
on openMax pressed do 
(
	OpenDaMax() -- function
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
						if (editLocation.text == pleaseSetPath or editLocation.text == "") then
							(
								messagebox "The path is still not defined ! Please ,set a path first." beep:true title:"f-StructX warning message"
							)
						else
							(
									if (checkMans.state == true or checkWomens.state == true or checkBoysAndGirls.state == true or checkDtail.state == true)then
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
											if (checkDtail.state == true) then
											(
												
												loadMaxfile "M:\MD_PP\Garments\00_MD Garment Folder Structure\P01M0001_GARMENT-NAME.max" quiet:true
											)
											if (showMaxName.text != showme() ) then
																(
																	showMaxName.text = showMe()
																	correctedNameSaveFile = NewGarmentPath + "\\" + showMaxName.text 
																	maxPathLastitem = showMe()
																	newMaxFileSavePath = editLocation.text + "\\" + maxPathLastitem 
																	messagebox "* Wrong maxfile name detected! Its corrected now !  " beep:true
																)
											if (showMaxName.text == showme() ) then
												(
													newMaxFileSavePath = editLocation.text + "\\" + maxPathLastitem 
													isMaxFileExist = doesFileExist newMaxFileSavePath
														if ( isMaxFileExist == false) then 
															(
														
															-- save  max file
															saveMaxfile newMaxFileSavePath
															message = " * Executed processes = 2 / 2 : " + "\n" + "\n" + "      Folders -- DONE" + "\n" + "\n"+ "      Max file -- DONE"
															messagebox message beep:false title:"f-StructX statistics"
															fmLights()
															)
															else
															(
															messageExist = "* Max file with this name already exists ! Can't be overwritten! "
															messagebox messageExist beep:true title:"f-StructX warning message"
															idleLights()
															)
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
								createUEFolder()
								createDxfFolder()
								createMapsFolder()
								createRefFolder()
								createRendersFolder()
										
									-- printing some info
								foldersCreated = "The fStruct generated in: " + NewGarmentPath
								print foldersCreated
								maxfilesCreated = "New .max file created: " + maxPathLastitem
								print maxfilesCreated
								printMaxfiles = getFiles (NewGarmentPath + "\\*.max")
								print "Existing max files :                       "
								print printMaxfiles
							)
					)
					validateMax()
					validateHanging()
					
					
		)
		on createfStruct rightClick do
		(
			rightClickOpenLocation()
		)

		on fStruct moved pos do 
		(
			validateHanging()
			setDialogPos fStructImporter (pos+[fStruct.width + pdWidth1 ,fStruct.height + pdHeight])
			setDialogPos fStructShellTimer (pos+[fStruct.width + pdWidth1 ,fStruct.height + pdHeight3])
			setDialogPos loadFrontAndBack (pos+[fStruct.width + 373 ,fStruct.height + pdHeight])
		)
		
	on fStruct close do 
	(
		validateHangingMsgs()
		print "fStructX closed! Hubav den!"
	)
	
	on fStruct open do 
	(
		--START IMPORTER ROLLOUT--
		rollout fStructImporter "fStructImporter" width:362 height:424 --define another rollout
		(
			local filesObjArr = #()
			local fileObjNamesArr = #()
			local filesMdArr = #()
			local fileMdNamesArr = #()
			local selectedFileIdx = 0
			local txtInput = undefined
			local sel = 0
			
			local importBtnTooltip =  "1. LMB = Import selected object" + "\n" + "2. RMB = Refresh list"
			local enableDisableTooltip = "* Enable/Disable the object's lists" 
		--===============--
		-- UI
		--===============--
			
			--Header
			local import_header = @"$userScripts\BorakaScriptPack_vol1\imgs\Importer_header.jpg"
			local import_header_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\Importer_header_mask.jpg"
			button ImportHeader "" pos:[0,0] width:(362-80) height:37 enabled:false border:false images:#(import_header, import_header_mask, 1, 1, 1, 1, 1)
			dotnetcontrol lb_0 "Label" text:"N" width:130 height:24 pos:[120,8]

			--searchpanel text
			local import_sp = @"$userScripts\BorakaScriptPack_vol1\imgs\Importer_sp.jpg"
			local import_sp_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\Importer_sp_mask.jpg"
			button searchP "" pos:[282,25] width:72 height:15 enabled:false border:false images:#(import_sp, import_sp_mask, 1, 1, 1, 1, 1)
			
			--pick location
			button pickLocation "Browse" pos:[25,10] width:64 height:24 border:true visible:false
			edittext editLocation "" pos:[95,10] width:177 height:24 readOnly:false visible:false
			
			--search
			edittext searchtxt "" pos:[180,46] width:130 height:22 enabled:false text:"...search here"
			local img_search = @"$userScripts\BorakaScriptPack_vol1\imgs\importer_search.jpg"
			local img_search_chd = @"$userScripts\BorakaScriptPack_vol1\imgs\importer_search_chd.jpg"
			local img_search_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\importer_search_mask.jpg"
			checkbutton searchbtn "search" pos:[314,46] width:40 height:24 enabled:false border:false checked: false images:#(img_search, img_search_mask, 1, 1, 1, 1, 1)
			
			--enable button
			local img_enable = @"$userScripts\BorakaScriptPack_vol1\imgs\importer_enable.jpg"
			local img_enable_chd = @"$userScripts\BorakaScriptPack_vol1\imgs\importer_enable_chd.jpg"
			local img_enable_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\importer_enable_mask.jpg"
			checkbutton enableImport "Enable import" pos:[10,45] width:125 height:24 enabled:false tooltip: enableDisableTooltip images:#(img_enable, img_enable_mask, 1, 1, 1, 1, 1)
			
			local hobjInfo = 76
			GroupBox objLists "" pos:[8,hobjInfo] width:346 height:132
			label OBJfolder "  OBJ folder / " pos:[20,hobjInfo]
			label objtotal "  t :      " pos:[250,hobjInfo]
			label objtotalcount "0" pos:[270,hobjInfo]
			--label obsjsel "   s :      " pos:[294,hobjInfo]
			--label objselcount "0" pos:[318,hobjInfo]
			multilistbox listObj "" items:#() selection:#() pos:[18,91] width:327 height:8 selection:0 enabled:false 
			
			local hmdInfo = 214
			GroupBox mdLists "" pos:[8,hmdInfo] width:346 height:132
			label MDfolder "  MD folder / " pos:[20,hmdInfo]
			label mdtotal "  t :      " pos:[250,hmdInfo]
			label mdtotalcount "0" pos:[270,hmdInfo]
			label mdsel "   s :      " pos:[294,hmdInfo]
			label mdselcount "0" pos:[318,hmdInfo]
			multilistbox listObjMD "" items:#() selection:#() pos:[18,229] width:327 height:8 selection:0 enabled:false
			
			--import button
			local img_importbtn_locked = @"$userScripts\BorakaScriptPack_vol1\imgs\Importer_btn_locked.jpg"
			local img_importbtn = @"$userScripts\BorakaScriptPack_vol1\imgs\Importer_btn.jpg"
			local img_importbtn_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\Importer_btn_mask.jpg"
			button importBtn "Locked - Import" pos:[10,354] width:240 height:36 border:false enabled:false tooltip:importBtnTooltip images:#(img_importbtn_locked, img_importbtn_mask, 1, 1, 1, 1, 1)
			
			--material check
			checkBox setMaterial "" pos:[265,354] tristate:2 tooltip:"Set material to imported objects! "
			local img_matinfo = @"$userScripts\BorakaScriptPack_vol1\imgs\importer_mat.jpg"
			local img_matinfo_chd = @"$userScripts\BorakaScriptPack_vol1\imgs\importer_mat_chd.jpg"
			local img_matinfo_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\importer_mat_mask.jpg"
			button matinfo "" pos:[288,354] width:80 height:16 border:false enabled:false images:#(img_matinfo_chd, img_matinfo_mask, 1, 1, 1, 1, 1)
			
			--full path check
			checkBox chkBox_showFullPath "" pos:[265,374]			
			local img_chkBoxinfo = @"$userScripts\BorakaScriptPack_vol1\imgs\importer_path.jpg"
			local img_chkBoxinfo_chd = @"$userScripts\BorakaScriptPack_vol1\imgs\importer_path_chd.jpg"
			local img_chkBoxinfo_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\importer_path_mask.jpg"
			button chkBoxinfo "" pos:[288,374] width:80 height:16 border:false enabled:false images:#(img_chkBoxinfo, img_chkBoxinfo_mask, 1, 1, 1, 1, 1)
			--footer
			local img_Importfooter = @"$userScripts\BorakaScriptPack_vol1\imgs\importer_footer.jpg"
			local img_Importfooter_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\importer_footer_mask.jpg"
			button Importfooter "" pos:[0,394] width:362 height:30 enabled:false border:false images:#(img_Importfooter, img_Importfooter_mask, 1, 1, 1, 1, 1)
			--fbx
			checkBox checkFbx "" pos:[287,6]
			local img_fbx = @"$userScripts\BorakaScriptPack_vol1\imgs\importer_fbx.jpg"
			local img_fbx_chd = @"$userScripts\BorakaScriptPack_vol1\imgs\importer_fbx_chd.jpg"
			button checkFbxbtn "" pos:[310,6] width:80 height:16 border:false enabled:false images:#(img_fbx, img_chkBoxinfo_mask, 1, 1, 1, 1, 1)
			
			checkBox theLastCr "" pos:[284,75] 
			hyperlink thelastcrText "LASTone" pos:[308,75] enabled:false
			
			local maxuibg = (colorman.getcolor #background) * 255
			local bgcolor = (dotnetclass "System.Drawing.Color").FromArgb 82 82 82 --maxuibg[1] maxuibg[2] maxuibg[3]
			local fgcolor = (dotnetclass "System.Drawing.Color").FromArgb 255 255 255
			
		--==================--
		-- FUNCTIONS
		--==================--
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

fn renameNormals = 
(
	--searching for the wrong names : _normals
	my_files = #()
	
	dir_array = GetDirectories (newGarmentPath + "/*" )
	for d in dir_array do join dir_array (GetDirectories (d+"/*"))
	for f in dir_array do join my_files (getFiles (f + "*_normals*"))
	print my_files

	if newGarmentPath != undefined then
		(
			renameCount = 0
			
			--JPG files
			jpgFiles = getFiles (newGarmentPath + "\\Maps\\" + "*.jpg")

			for file in jpgFiles do
				(
					normalsCheck = matchPattern file pattern:"*_normals*"
					
					if normalsCheck == true then
						(
							newFileName = (substring file 1 (file.count - 12)) + ".jpg"
							renameFile file newFileName
							renameCount = renameCount + 1
						)
				)
				
			--PNG files
			pngFiles = getFiles (newGarmentPath + "\\Maps\\" + "*.png")

			for file in pngFiles do
				(
					normalsCheck = matchPattern file pattern:"*_normals*"
					
					if normalsCheck == true then
						(
							newFileName = (substring file 1 (file.count - 12)) + ".png"
							renameFile file newFileName
							renameCount = renameCount + 1
						)
				)
			
			if renameCount != 0 then
				(
					renamedMessage = "'_normals' removed : "  + (renameCount as string) 
					print renamedMessage
					--messageBox renamedMessage title:"Files Successully Renamed:"
				)
			else
				(
					renamedMessage = "No files were renamed."
					print renamedMessage
					--messageBox renamedMessage title:"No Files Renamed:"
				)
		)
)

fn garmentNumberLabel = 
(
	local cnt = fstruct.editLocation.text.count >= 20 and fstruct.editLocation.text != pleaseSetPath
	
	if( cnt == true ) then
	(
		maxpath = fstruct.editLocation.text
		splitPath = filterstring maxpath "\\"
		lastElementOfPathSplit = filterstring splitPath[splitPath.count] "_"
		garmentNum = lastElementOfPathSplit[1];
		
		lb_0.Text = "| " + garmentNum + " |"
		lb_0.Backcolor = bgcolor
		lb_0.Forecolor = fgcolor
		lb_0.Font = DotNetFont "Verdana" 10 #regular
	)
	else
	(
		lb_0.Text = "N******"
		lb_0.Backcolor = bgcolor
		lb_0.Forecolor = fgcolor
		lb_0.Font = DotNetFont "Verdana" 10 #regular
	)
)

fn infoCount = 
(
 objtotalcount.text = fileObjNamesArr.count as string
 mdtotalcount.text = fileMdNamesArr.count as string 
)

			
fn mat = 
(
			--load the .mat file 
	local matPath = @"$userScripts\BorakaScriptPack_vol1\files\"
	local matName = "fstruct_materials.mat"
	local matlibrary = matPath + matName
	tmp = loadTempMaterialLibrary matlibrary
	local matMaterials = #()
	for i=1 to tmp.count do append matMaterials tmp[i]
		
			--generate material
	for i = 1 to selection.count do
	(
		--filter the path ;get the last idx; filter na lst idx ; get first idx - example : N**M**
		fltr = filterstring newGarmentPath "\:"
		fltrLastIdx = fltr[fltr.count]
		fltr2 = filterstring fltrLastIdx "_"
		local garmentMatName = fltr2[1]
		local brandSignature = garmentMatName[1] -- exam: N 
		
		--filter and compare 3-th index of selection to its own hanger name
		local impSel = selection[i]
		fltrSel = filterstring impSel.name "_"
		local fltrThirdIdx = fltrSel[3]
		local fltrVariation = fltrSel[4]
		
-- 		--if massimport check  is true
		if (fStructShellTimer.enableMassImporter.checked == true) then 
		(
			garmentMatName = fltrSel[2]
		)
		
		meditMaterials[6] = VrayMtl()
		local newmat = meditmaterials[6]
		Diff = Falloff()
		Normalmap = VRayNormalMap ()
		CompMap = CompositeTexturemap ()
		local allTheNormals = #("normalWrinkles","normalWrinklesNh0","normalWrinklesNh1","normalWrinklesNh2","normalWrinklesNh3","normalSeams","normalFabric")
		
		--material name
		--NIKE
		if (fltrThirdIdx == "NH-0" or fltrThirdIdx == "NH-1" or fltrThirdIdx == "NH-2" or fltrThirdIdx == "NH-3") then
		(
			newmat.name = garmentMatName + "_" + fltrThirdIdx + "_" + fltrVariation
		)
		--LEVIS
		else if (fltrThirdIdx == "SF00" or fltrThirdIdx == "HF00" or fltrThirdIdx == "VHFL" or fltrThirdIdx == "VHFR" or fltrThirdIdx == "LD00" or fltrThirdIdx == "HFF0" or fltrThirdIdx == "HFB0" or fltrThirdIdx == "LFF0" or fltrThirdIdx == "LFB0" or fltrThirdIdx == "TF00" or fltrThirdIdx == "LH-0" or fltrThirdIdx == "NH-1") then
		(
			newmat.name = garmentMatName + "_" + fltrThirdIdx + "_" + fltrVariation
		)
		else if (fltrSel[1] == "SM" and impSel.name.count >= 17)then 
		(
			newmat.name = garmentMatName + "_"
		)
		else
		(
			newmat.name = "Wrong_mesh_name_material"
		)
		
		-- DIFFUSE
			-- falloff		
		local skuCode = "000000-000"
		local psd = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_SE00_CA_" + skuCode + "_D.psd" 
		local psdNoSeason = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_" + skuCode + "_D.psd" 
		local blankPsdPath = @"M:\MD_N\Garments\00_MD Garment Folder Structure\Maps\"
		local blankPsd = blankPsdPath + "T_N01M001_SE00_CA_" + skuCode + "_D.psd"
		
	--Basic parameters
		-- fixing the falloff mixcurve
		newmat.texmap_diffuse = copy matMaterials[1].texmap_diffuse
		newmat.texmap_diffuse.name = "DIFF"
		newmat.texmap_diffuse.map2Amount = 95
		newmat.Diffuse = color 128 128 128
		newmat.Reflection = color 128 128 128
		newmat.reflection_glossiness = 0.44
		newmat.refraction_ior = 1.16
		newmat.selfIllumination_gi = true
	--Options
		newmat.option_traceReflection = false
		newmat.option_traceRefraction = false
		newmat.option_glossyFresnel = false
	--BRDF
		newmat.gtr_gamma = 1

		isPsdFileExist = doesFileExist psd 
		isPsdWithNoSeasonExist = doesFileExist psdNoSeason
				if ( isPsdFileExist == true) then 
				(
					newmat.texmap_diffuse.map1 = Bitmaptexture filename:psd 
					newmat.texmap_diffuse.map2 = newmat.texmap_diffuse.map1  
				)
				else if (isPsdWithNoSeasonExist == true) then	
				(	
					newmat.texmap_diffuse.map1 = Bitmaptexture filename:psdNoSeason	
					newmat.texmap_diffuse.map2 = newmat.texmap_diffuse.map1  	
				)
				else
				(
					newmat.texmap_diffuse.map1 = Bitmaptexture filename:blankPsd
					newmat.texmap_diffuse.map2 = newmat.texmap_diffuse.map1 
				)
					newmat.texmap_diffuse.map1.name = "DIFF_map1"
					newmat.texmap_diffuse.map1.coords.realWorldScale = false
					newmat.texmap_diffuse.map1.coords.U_Tiling = 1
					newmat.texmap_diffuse.map1.coords.V_Tiling = 1
					newmat.texmap_diffuse.map1.alphaSource = 2
			
					newmat.texmap_diffuse.map2.name = "DIFF_map2"
					newmat.texmap_diffuse.map2.coords.realWorldScale = false
					newmat.texmap_diffuse.map2.coords.U_Tiling = 1
					newmat.texmap_diffuse.map2.coords.V_Tiling = 1
					newmat.texmap_diffuse.map2.alphaSource = 2
		
		--NORMALS
		newmat.texmap_bump_multiplier = 100
		--vray normal 
		newmat.texmap_bump = copy matMaterials[1].texmap_bump
		newmat.texmap_bump.name = "NORMALS"
				-- composite
		newmat.texmap_bump.normal_map = CompMap
		newmat.texmap_bump.normal_map.name = "Normal_maps"
			newmat.texmap_bump.normal_map.mapEnabled.count = 3
			newmat.texmap_bump.normal_map.layername[3] = "FABRIC"
			newmat.texmap_bump.normal_map.layername[2] = "SEAMS"
			newmat.texmap_bump.normal_map.layername[1] = "WRINKLES"
			  
-- 			local myGamma = 1.0
		--local imagePath = @"C:\Users\RR\Dropbox\maxscript\0_Root\N05M034_Hot-Sauce\Maps\gamma_test.jpg"
-- 			local bmpDisk = openbitmap imagePath gamma:1.0 --open the bitmap from disk
-- 			local bmpCorrectGamma = bitmap bmpDisk.width bmpDisk.height inputGamma:&gma --make a new bitmap with the same size but with the prper gamma settings
-- 			pastebitmap bmpDisk bmpCorrectGamma [0,0] [0,0] --paste the bitmap from disk into the gamma-bitmap. this essentially adjusts the gamma
							--wrinkles
			--fileingamma = 1.0
-- 		if (IDisplayGamma.colorCorrectionMode != #gamma) then 
-- 				(
--  					IDisplayGamma.colorCorrectionMode = #gamma --enable Gamma
--  					IDisplayGamma.gamma = 2.2
-- 					fileingamma = 2.2
-- 					fileoutgamma = 2.2
-- 					case of
-- 					(
-- 						((maxVersion())[1] <= 14000): myGamma = fileInGamma --max 2012 reacts differently than max 2013 and up
-- 						default: myGamma = fileInGamma/displayGamma --this calculation results in the correct gamma for the banner in max 2013 and up
-- 					)
-- 				)

		-- Removing the _normals part from normalmaps
		renameNormals()
		
		local blankWrinklesPath = @"L:\Textures\Z_Standard_Do_Not_Modify\FABRIC\"
		local normalWrinkles =  blankWrinklesPath + "ST_MD_NormalBump_Blank.jpg"	
		
		--NIKE
		local normalWrinklesNh0 = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_NH-0_"+ fltrVariation +"_N.jpg"
		local normalWrinklesNh1 = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_NH-1_"+ fltrVariation +"_N.jpg"
		local normalWrinklesNh2 = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_NH-2_"+ fltrVariation +"_N.jpg"
		local normalWrinklesNh3 = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_NH-3_"+ fltrVariation +"_N.jpg"
		local isNh0FileExist = doesFileExist normalWrinklesNh0
		local isNh1FileExist = doesFileExist normalWrinklesNh1
		local isNh2FileExist = doesFileExist normalWrinklesNh2
		local isNh3FileExist = doesFileExist normalWrinklesNh3
		
		--LEVIS
		local normalWrinklesLh0 = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_LH-0_"+ fltrVariation +"_N.jpg"
		local normalWrinklesLh1 = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_LH-1_"+ fltrVariation +"_N.jpg"
		
		local normalWrinklesSF00 = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_SF00_"+ fltrVariation +"_N.jpg"
		local normalWrinklesHF00 = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_HF00_"+ fltrVariation +"_N.jpg"
		local normalWrinklesVHFR = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_VHFR_"+ fltrVariation +"_N.jpg"
		local normalWrinklesVHFL= newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_VHFL_"+ fltrVariation +"_N.jpg"
		local normalWrinklesLD00= newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_LD00_"+ fltrVariation +"_N.jpg"
		local normalWrinklesHFF0= newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_HFF0_"+ fltrVariation +"_N.jpg"
		local normalWrinklesHFB0= newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_HFB0_"+ fltrVariation +"_N.jpg"
		local normalWrinklesLFF0= newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_LFF0_"+ fltrVariation +"_N.jpg"
		local normalWrinklesLFB0= newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_LFB0_"+ fltrVariation +"_N.jpg"
		local normalWrinklesTF00= newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_TF00_"+ fltrVariation +"_N.jpg"
	
		local isLh0FileExist = doesFileExist normalWrinklesLh0
		local isLh1FileExist = doesFileExist normalWrinklesLh1
		
		local isSF00FileExist = doesFileExist normalWrinklesSF00
		local isHF00FileExist = doesFileExist normalWrinklesHF00
		local isVHFRFileExist = doesFileExist normalWrinklesVHFR
		local isVHFLFileExist = doesFileExist normalWrinklesVHFL
		local isLD00FileExist = doesFileExist normalWrinklesLD00		
		local isHFF0FileExist = doesFileExist normalWrinklesHFF0
		local isHFB0FileExist = doesFileExist normalWrinklesHFB0
		local isLFF0FileExist = doesFileExist normalWrinklesLFF0
		local isLFB0FileExist = doesFileExist normalWrinklesLFB0
		local isTF00FileExist = doesFileExist normalWrinklesTF00

		
		--NIKE
		--if the file exists and selection name - 3-th index are the same
		if(brandSignature == "N") then
		(
			if ( isNh0FileExist == true and fltrThirdIdx == "NH-0") then 
				(
					newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesNh0 
				)
			else
				(
					if ( isNh1FileExist == true and fltrThirdIdx == "NH-1")then
						(
							newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesNh1 
						)
					else
						(
							if ( isNh2FileExist == true and fltrThirdIdx == "NH-2")then
								(
									newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesNh2 
								)
							else
								(
									if ( isNh3FileExist == true and fltrThirdIdx == "NH-3")then
										(
											newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesNh3 
										)
									else
										(
											newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinkles 
										)
									
								)
						)
				)
		)
			
			--LEVIS
			--if the file exists and selection name - 3-th index are the same
		if ( brandSignature == "L") then
		(
			if ( isLh0FileExist == true and fltrThirdIdx == "LH-0") then 
				(
					newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesLh0 
				)
			else
				(
					if ( isLh1FileExist == true and fltrThirdIdx == "LH-1")then
						(
							newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesLh1 
						)
					else
						(
							if ( isSF00FileExist == true and fltrThirdIdx == "SF00")then
								(
									newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesSF00 
								)
							else
								(
									if ( isHF00FileExist == true and fltrThirdIdx == "HF00")then
										(
											newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesHF00 
										)
									else
										(
											if ( isVHFRFileExist == true and fltrThirdIdx == "VHFR")then
												(
													newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesVHFR 
												)
											else
												(
													if ( isVHFLFileExist == true and fltrThirdIdx == "VHFL")then
														(
															newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesVHFL 
														)
													else
														(
															if ( isLD00FileExist == true and fltrThirdIdx == "LD00")then
																(
																	newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesLD00 
																)
															else
																(
																	if ( isHFF0FileExist == true and fltrThirdIdx == "HFF0")then
																		(
																			newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesHFF0 
																		)
																	else
																		(
																			
																			if ( isHFB0FileExist == true and fltrThirdIdx == "HFB0")then
																				(
																					newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesHFB0 
																				)
																			else
																				(
																					if ( isLFF0FileExist == true and fltrThirdIdx == "LFF0")then
																						(
																							newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesLFF0 
																						)
																					else
																						(
																							if ( isLFB0FileExist == true and fltrThirdIdx == "LFB0")then
																								(
																									newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesLFB0 
																								)
																							else
																								(
																									if ( isTF00FileExist == true and fltrThirdIdx == "TFB0")then
																										(
																											newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesTF00
																										)
																										else
																										(
																											newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinkles
																										)
																								)
																						)
																				)
																		)
																)
														)
												)
										)
								)
						)
				)
		)
			
			newmat.texmap_bump.normal_map.maplist[1].name = "Wrinkles"
			newmat.texmap_bump.normal_map.maplist[1].coords.realWorldScale = false
			newmat.texmap_bump.normal_map.maplist[1].coords.U_Tiling = 1
			newmat.texmap_bump.normal_map.maplist[1].coords.V_Tiling = 1
			newmat.texmap_bump.normal_map.maplist[1].alphaSource = 2
			newmat.texmap_bump.normal_map.opacity[1] = 100
			newmat.texmap_bump.normal_map.blendMode[1] = 0
							--Seams
						
			local normalSeams = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_N.jpg"
			isNormalSeamsExist = doesFileExist normalSeams
			if (isNormalSeamsExist == true)then
			(
				newmat.texmap_bump.normal_map.mapList[2] = Bitmaptexture filename:normalSeams
			)
			else
			(
				newmat.texmap_bump.normal_map.mapList[2] = Bitmaptexture filename:normalWrinkles 
			)
				newmat.texmap_bump.normal_map.maplist[2].name = "Seams"
				newmat.texmap_bump.normal_map.maplist[2].coords.realWorldScale = false
				newmat.texmap_bump.normal_map.maplist[2].coords.U_Tiling = 1
				newmat.texmap_bump.normal_map.maplist[2].coords.V_Tiling = 1
				newmat.texmap_bump.normal_map.maplist[2].alphaSource = 2
				newmat.texmap_bump.normal_map.opacity[2] = 100
				newmat.texmap_bump.normal_map.blendMode[2] = 14

							
				--Fabric
			local drifitPath = @"L:\Textures\Z_Standard_Do_Not_Modify\FABRIC\"
			local normalFabric = drifitPath + "Dri-Fit_N.jpg"
			isDrifitFileExist = doesFileExist normalFabric
			if (isDrifitFileExist == true)then
			(
				newmat.texmap_bump.normal_map.mapList[3] = Bitmaptexture filename:normalFabric 
			)
			else
			(
				newmat.texmap_bump.normal_map.mapList[3] = Bitmaptexture filename:normalWrinkles 
			)
				newmat.texmap_bump.normal_map.maplist[3].name = "Fabric"
				newmat.texmap_bump.normal_map.maplist[3].coords.realWorldScale = false
				newmat.texmap_bump.normal_map.maplist[3].coords.U_Tiling = 1
				newmat.texmap_bump.normal_map.maplist[3].coords.V_Tiling = 1
				newmat.texmap_bump.normal_map.maplist[3].alphaSource = 2
				newmat.texmap_bump.normal_map.opacity[3] = 100
				newmat.texmap_bump.normal_map.blendMode[3] = 14

			--fileingamma = 2.2
			
		--OPACITY
		local opacPath = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_O.jpg"
		isOpacFileExist = doesFileExist opacPath
		if ( isOpacFileExist == true) then 
			(
				Opac = opacPath
				newmat.texmap_opacity = Bitmaptexture filename: Opac 
				newmat.texmap_opacity.name = "OPAC"
				newmat.texmap_opacity.coords.realWorldScale = false
				newmat.texmap_opacity.coords.U_Tiling = 1
				newmat.texmap_opacity.coords.V_Tiling = 1
				newmat.texmap_opacity.alphaSource = 2
			)

		selection[i].material = newmat
			--meditMaterial[1] = newmat

			--show vray textures in viewport
		for mat in (getClassInstances vrayMtl processAllAnimatables:true) do showTextureMap mat on
			--clear materials slots
--		macros.run "Medit Tools" "clear_medit_slots"
			--FIXING THE MAPS
			--copy matslot 6 to 12 
	meditMaterials[12] = copy newmat
	meditMaterials[12].name = meditMaterials[12].name + "_copy"
		
			--copy normal map slot from matMaterials to newmat to get proper 'overide' - now the maps are overided
	newmat.texmap_bump = copy matMaterials[1].texmap_bump
	newmat.texmap_bump.name = "NORMALS"

			-- transfering normal maps back from matslot 12 to 6 
	newmat.texmap_bump.normal_map.mapList[3].filename = copy meditMaterials[12].texmap_bump.normal_map.mapList[3].filename
	newmat.texmap_bump.normal_map.mapList[2].filename = copy meditMaterials[12].texmap_bump.normal_map.mapList[2].filename
	newmat.texmap_bump.normal_map.mapList[1].filename = copy meditMaterials[12].texmap_bump.normal_map.mapList[1].filename
	
			-- clear slot 12 and get the default material back
	meditMaterials[12] = Standardmaterial()
	meditMaterials[12].name = "12 - Default"
			)
)
--create and import to 4_Product layer
fn createImportObjectsInLayer = 
(
	layerName = "4_Product"
	LayerManager.newLayerFromName layerName
	newLayer = layermanager.getLayerFromName layerName
	--allNodes = select Objects
	for obj in selection do newLayer.addNode obj
)

--Fill the lists
fn FillListboxes thePath theExtension =
(
	if ( NewGarmentPath != undefined ) then
		(
		filesObjArr =sort(getFiles (thePath +"\\Obj"+  theExtension))
		fileObjNamesArr = sort(for f in filesObjArr collect (filenameFromPath f))
		filesMdArr = sort(getFiles (thePath +"\\Obj\\MD"+ theExtension )) 
		fileMdNamesArr = sort(for f in filesMdArr collect (filenameFromPath f))
			
		listObj.items = fileObjNamesArr 
		listObjMD.items = fileMdNamesArr 
		)
)
			
fn theLastCreated  = 
(
	if ( NewGarmentPath != undefined) then
	(
		if(listObj.items.count == 0)then
		(
			listObj.items = fileObjNamesArr
		)
		else
		(
			thePath = NewGarmentPath
			theExtension = "\\*.obj"

			myfiles = #()
			myfilesNames = #()
			myfilesDates = #()

			myfiles = sort(getFiles (thePath + "\\Obj" + theExtension))
			myfilesNames = sort(for f in myfiles collect (filenameFromPath f))
			myfilesDates = sort(for d in myfiles collect (getFilemodDate d)) -- sorting to get the max item as string

			theLastDate = amax myfilesDates --the latest date item
			indx = findItem myfilesDates theLastDate --index of that newest date
			date = theLastDate -- save date in new variable
			theLastObjectName = myfilesNames[indx] as string --get the name of item

			--revert
			myfilesDates = (for d in myfiles collect (getFilemodDate d)) -- without sorting
				
				for i =1 to myfiles.count do
				(
				format "% - % - % \n" i myfilesNames[i] myfilesDates[i]
				)

			newIndex = finditem myfilesDates date --new index -- right index
			theLastNewObjectName = myfilesNames[newIndex] as string --get the name of item
			theLastObj = myfiles[newIndex]
				
				format "The last date : % \n" theLastDate
				format "The last date index : %\n" newIndex
				--format "The last name : %\n" theLastNewObjectName
			
			listObj.selection = newIndex
			--searchtxt.text = theLastNewObjectName
				
				--size-
			mbd = getFileSize theLastObj/1000000 -- mb(decimal)
			mbb = getFileSize theLastObj*0.00000095367432 -- mb(binary)
			format "The last created item : % - % mb\n" theLastNewObjectName mbb
				--some attributes
			getFileAttribute theLastObj #hidden
			setFileAttribute theLastObj #hidden false
		)
	)
)
			
-- Search for word 
fn SearchForWordInArray theArray theWord caseSensitive:true =
(
	pattern = "*" + theWord + "*"
	for j = 1 to theArray.count where matchpattern theArray[j] pattern:pattern ignoreCase:caseSensitive collect j
)

fn creatingLog = 
(
	local cnt = fstruct.editLocation.text.count >= 30 and fstruct.editLocation.text != pleaseSetPath

	if (cnt == true ) then
	(
		local ArrIdx = SearchForWordInArray fileObjNamesArr searchtxt.text ignoreCase:true
		listObj.selection = ArrIdx
		local ArrNames = for n in fileObjNamesArr collect n
		
		local ArrMdIdx = SearchForWordInArray fileMdNamesArr searchtxt.text ignoreCase:true
		listObjMd.selection = ArrMdIdx
		local ArrMdNames = for n in fileMdNamesArr collect n
		
		thePath = fStruct.editLocation.text
		filterName = filterstring thePath "\\:"
		filterIdx = filterName[filterName.count]
		local exportFileLog = thePath + "\\" + filterIdx + "_Statistics.txt"
		print exportFilelog
		
		--Deleting logfile
		df = deleteFile exportfilelog
		
		--Creating logfile
		if (doesFileExist exportFilelog == false )then 
			(
				t = localtime	
				cf = createFile exportfilelog
				
				--get the author info
				local fileInfo = dotNetObject "System.IO.FileInfo" exportFileLog
				local fileAccessControl = fileInfo.getAccessControl()
				local NTAccountType = dotNetClass "System.Security.Principal.NTAccount"
				local fileOwner = fileAccessControl.getOwner NTAccountType

				format "---------- STATISTICS for % ----------\n\n" filterIdx to:cf
				format"LAST MODIFICATION - AUTHOR : '%'\n" fileOwner.value to:cf
				format "DATE : % \n" t to:cf
				format "GARMENT root : % \n"thePath to:cf
				format  "\n--------------------\n" to:cf
				format "TOTAL OBJs COUNT : % \n" fileObjNamesArr.count to:cf
				format "TOTAL MDs COUNT : % \n" fileMdNamesArr.count to:cf
				format "---------------------\n" to:cf

				format "ROW |  NAME \n" to:cf
				format "\n   --[ OBJ folder ]-- \n" to:cf
				for i in ArrIdx do
				(
					format "#%  -  % \n" i ArrNames[i] to:cf
				)
				format "\n   --[ MD folder ]-- \n" to:cf
					for i in ArrMdIdx do
				(
					format "#%  -  % \n" i ArrMdNames[i] to:cf
				)
				format "\n" to:cf					
				close cf
			)
	)
)

fn printSome = 
(
		local ArrIdx = SearchForWordInArray fileObjNamesArr searchtxt.text ignoreCase:true
		listObj.selection = ArrIdx
		local ArrNames = for n in fileObjNamesArr collect n
		
		local ArrMdIdx = SearchForWordInArray fileMdNamesArr searchtxt.text ignoreCase:true
		listObjMd.selection = ArrMdIdx
		local ArrMdNames = for n in fileMdNamesArr collect n
		
		infoCount()
		--objselcount.text = ArrIdx.count as string
		mdselcount.text = ArrMdIdx.count as string
		
		-- print some info
			format "-----------------------------------------------------------------------\n"
			print "*** STATISTICS ***"
			format  "--------------------\n" 
			format "TOTAL OBJs COUNT : % \n" fileObjNamesArr.count 
			format "[ OBJs SELECTED ]: % \n" ArrIdx.count 
			format "---------------------\n"
			format "TOTAL MDs COUNT : % \n" fileMdNamesArr.count 
			format "[ MDs SELECTED ]: % \n" ArrMdIdx.count 
			format "---------------------\n"

			format "ROW |  NAME \n" 
			format "\n   --[ OBJ folder ]-- \n"
			for i in ArrIdx do
			(
				format "#%  -  % \n" i ArrNames[i] 
			)
			format "\n   --[ MD folder ]-- \n"
				for i in ArrMdIdx do
			(
				format "#%  -  % \n" i ArrMdNames[i] 
			)
			format "\n"
			-- end print
)

				
--==================--
-- MAIN
--==================--
	
--===== SEARCHBOX=====--
--when select item
on listObj selectionEnd do
(
	selIdx = listObj.selection
	selArrName = for n in selIdx collect format "You select : %  \n" fileObjNamesArr[n]
		format "\n"
)
on listObjMd selectionEnd do
(
	selIdx = listObjMd.selection
	selArrName = for n in selIdx collect format "You select : %  \n" fileMdNamesArr[n]
		format "\n"
)
	
--when open	
on fStructImporter open do
(
	garmentNumberLabel()
	
	listObj.items = sort fileObjNamesArr
	listObj.selection = 0
	
	listObjMd.items = sort fileMdNamesArr
	listObjMd.selection = 0
)
	
-- when enter text in the searchbox
on searchtxt changed txtInput do
(
	if txtInput != "" then 
	(
		infoCount()
		printSome()
		searchbtn.checked = true
		searchbtn.images = #(img_search_chd, img_search_mask, 1, 1, 1, 1, 1)
		theLastCr.checked = false

	)
	else 
	(
		--objselcount.text = "0"
		mdselcount.text = "0"
		listObjMd.selection = 0
		listObj.selection = 0
		theLastCr.checked = false
		searchbtn.checked = false
		searchbtn.images = #(img_search, img_search_mask, 1, 1, 1, 1, 1)
	)
)
	
on searchbtn changed searchState do
(
	if searchState then
	(
		ArrIdx = SearchForWordInArray fileObjNamesArr searchtxt.text ignoreCase:true
		listObj.selection = ArrIdx
		
		ArrMdIdx = SearchForWordInArray fileMdNamesArr searchtxt.text ignoreCase:true
		listObjMd.selection = ArrMdIdx
		
		listObj.selection = 0
		listObjMd.selection = 0
		searchtxt.text = ""
		searchtxt.enabled = true
		searchbtn.images = #(img_search_chd, img_search_mask, 1, 1, 1, 1, 1)
	)
	else
	(
		--objselcount.text = "0"
		mdselcount.text = "0"
		listObj.selection = 0
		listObjMd.selection = 0
		searchtxt.text = "...search here"
		searchtxt.enabled = false
		searchbtn.images = #(img_search, img_search_mask, 1, 1, 1, 1, 1)
	)
)
--=======END SEARCHBOX ========--
	
--=======START RCMENU=========--
on listObj rightClick val do
	(
		popUpMenu fStructRightClickMenuBalancer
	)
	
on listObjMd rightClick val do
	(
		popUpMenu fStructRightClickMenuBalancer
	)
--=======END RCMENU==========-				

--=======START IMPORTER========--
-- pick location 
-- 	on pickLocation pressed do
-- 	(
-- 		newGarmentPath = getSavePath()
-- 		if ( newGarmentPath != undefined ) then
-- 		(
-- 			
-- 		)
-- 		else
-- 			newGarmentPath = undefined
-- 	)

-- refresh the database list 
on chkBox_showFullPath changed state do
(
	if state then
	(
		listObj.items = filesObjArr
		listObjMD.items = filesMdArr
		chkBoxinfo.images = #(img_chkBoxinfo_chd, img_chkBoxinfo_mask, 1, 1, 1, 1, 1)
	)
	else
	(
		listObj.items = fileObjNamesArr
		listObjMD.items = fileMdNamesArr
		chkBoxinfo.images = #(img_chkBoxinfo, img_chkBoxinfo_mask, 1, 1, 1, 1, 1)
	)
)
	
on setMaterial changed state do
(
	if state then
	(
		matinfo.images = #(img_matinfo_chd, img_matinfo_mask, 1, 1, 1, 1, 1)
	)
	else
	(
		matinfo.images = #(img_matinfo, img_matinfo_mask, 1, 1, 1, 1, 1)
	)
)
	
on theLastCr changed state do
(
	if state then
	(	
		theLastCreated()
		thelastcrText.color = [0,150,255]
	)
	else
	(
		thelastcrText.color = [235,235,235]
		searchtxt.text = ""
		listObj.selection = 0
		listObjMD.selection = 0
	)
)
	
on checkFbx changed state do
(
	if state then
	(
		chkBox_showFullPath.checked = false
		theLastCr.checked = false
		chkBoxinfo.images = #(img_chkBoxinfo, img_chkBoxinfo_mask, 1, 1, 1, 1, 1)
		checkFbxbtn.images = #(img_fbx_chd, img_matinfo_mask, 1, 1, 1, 1, 1)
		FillListBoxes newGarmentPath extFbx
	)
	else
	(
		chkBox_showFullPath.checked = false
		theLastCr.checked = false
		chkBoxinfo.images = #(img_chkBoxinfo, img_chkBoxinfo_mask, 1, 1, 1, 1, 1)
		checkFbxbtn.images = #(img_fbx, img_matinfo_mask, 1, 1, 1, 1, 1)
		FillListboxes newGarmentPath extObj
	)
	searchtxt.text = ""
	infoCount()
	--objselcount.text = "0"
	mdselcount.text = "0"
	listObj.selection = 0
	listObjMD.selection = 0
)
	
on importbtn rightclick do
(
	clearlistener()
	if newGarmentPath != undefined do
	(
		if chkBox_showFullPath.checked == true then
		(
			if(checkFbx.checked == true) then
			(
				FillListboxes newGarmentPath extFbx
				listObj.items = filesObjArr
				listObjMD.items = filesMdArr
			)
			else
			(
				FillListboxes newGarmentPath extObj
				listObj.items = filesObjArr
				listObjMD.items = filesMdArr
			)
		)
		else
		(
			if(checkFbx.checked == true) then
			(
				FillListboxes newGarmentPath extFbx
			)
			else
			(
				FillListboxes newGarmentPath extObj
			)
		)
	)
	
	fstruct.validateHanging()
	fstruct.validateMax()
	getFilesRecursive NewGarmentPath mtl
	searchtxt.text = ""
	creatingLog()
	infoCount()
	--objselcount.text = "0"
	mdselcount.text = "0"
	listObj.selection = 0
	listObjMD.selection = 0
)

	
--Enable button
on enableImport changed theState do
(
	if theState then
	(
		if (searchtxt.text == "") then
		(
			--objselcount.text = "0"
			mdselcount.text = "0"
			listObj.selection = 0
			listObjMd.selection = 0
		)
		else
		(
			ArrIdx = SearchForWordInArray fileObjNamesArr searchtxt.text ignoreCase:true
			listObj.selection = ArrIdx
			
			ArrMdIdx = SearchForWordInArray fileMdNamesArr searchtxt.text ignoreCase:true
			listObjMd.selection = ArrMdIdx
		)
		infoCount()
		theLastCr.enabled = true 
		listObj.enabled = true
		listObjMD.enabled = true
		importBtn.caption = "Import"
		importBtn.enabled = true
		searchtxt.enabled = true
		searchbtn.checked = true
		searchbtn.enabled = true
		importBtn.images = #(img_importbtn, img_importbtn_mask, 1, 1, 1, 1, 1)
		searchbtn.images = #(img_search_chd, img_search_mask, 1, 1, 1, 1, 1)
		enableImport.images = #(img_enable_chd, img_enable_mask, 1, 1, 1, 1, 1)
	)
	else
	(
		theLastCr.enabled = false
		--objselcount.text = "0"
		mdselcount.text = "0"
		listObj.enabled = false
		listObjMD.enabled = false
		listObj.selection = 0
		listObjMd.selection = 0
		importBtn.caption = "Import - Locked"
		importBtn.enabled = false
		searchtxt.enabled = false
		searchbtn.checked = false
		searchbtn.enabled = false
		importBtn.images = #(img_importbtn_locked, img_importbtn_mask, 1, 1, 1, 1, 1)
		searchbtn.images = #(img_search, img_search_mask, 1, 1, 1, 1, 1)
		enableImport.images = #(img_enable, img_enable_mask, 1, 1, 1, 1, 1)
	)
)
	
--swap selection list
on listObj selected items do
(
	--objselcount.text = "1"
	mdselcount.text = "0"
	listObjMd.selection = 0
)

on listObjMD selected items do
(
	mdselcount.text = "1"
	--objselcount.text = "0"
	listObj.selection = 0
)

-- import selected object
on importBtn pressed do
(
	clearlistener()
	
	if (newGarmentPath == undefined) then
	(
		msgNothingSelected = "* There is any selected object to import!"
		messagebox msgNothingSelected title:"fStructX importer message "
	)
	else
	(
		if (listObj.selection == 0 and listObjMD.selection == 0) then
		(
			msgNothingSelected = "* There is any selected object to import!"
			messagebox msgNothingSelected title:"fStructX importer message "
		)
		else
		(
			startImport = timeStamp()
			local txt = "Imported object: " 
			
			if (listObj.selection != 0)do 
			(	
				--obj import
				local selectedFileIdx = listObj.selection
				local counter = 0
					for a in selectedFileIdx do
					(
						if (checkfbx.checked == true) then
						(
							importFile filesObjArr[a] 
							
						)
						else
						(
							importFile filesObjArr[a] #noprompt
						)
						
						if (selection[1] != undefined) then
						(
						local importedObject = txt + fileObjNamesArr[a]
						
						--move objects with 100mm next to each other
						counterOne = a/a
						counter += counterOne
						local obj = selection[1]
						x = (-100*counter)+100
						y = 0
						z = 0
						move obj [x,y,z]
							
							-- set SG
							select obj
							max modify mode
							subobjectlevel = 4
							max select all
							convertToPoly obj
							$.autoSmoothThreshold = 59
							$.EditablePoly.autosmooth ()
							max create mode
							
						print importedObject
					
						--set mat							
						if(setMaterial.state == true ) then (mat())else(format "Imported object without material !\n")

						--create and import to 4_Product layer
						createImportObjectsInLayer()
						)
					)
			)	
				
			if (listObjMD.selection != 0)do 
			(	
				--md import
				local selectedFileIdx = listObjMD.selection
				local counter = 0
					for a in selectedFileIdx do
					(
						if (checkfbx.checked == true) then
						(
							importFile filesMdArr[a] 
						)
						else
						(
							importFile filesMdArr[a] #noprompt
						)
						
						if (selection[1] != undefined) then
						(
						local importedObjectmd = txt + fileMdNamesArr[a]

						--move objects with 100mm next to each other
						counterOne = a/a
						counter += counterOne
						local obj = selection[1]
						x = (-100*counter)+100
						y = 0
						z = 0
						move obj [x,y,z]
						
							-- set SG
							select obj
							max modify mode
							subobjectlevel = 4
							max select all
							convertToPoly obj
							$.autoSmoothThreshold = 59
							$.EditablePoly.autosmooth ()
							max create mode
							
						print importedObjectmd
						
						--set mat
						if(setMaterial.state == true ) then (mat())else(format "Imported object without material !\n")
							
						--create and import to 4_Product layer
						createImportObjectsInLayer() 
						)
					)
			)	
			endImport = timeStamp()
			format "Processing took % seconds\n" ((endImport - startImport) / 1000.0)
		)	
	)
)
--========END IMPORTER========--
			
		)
		--END IMPORTER ROLLOUT--
		
		--START SHELLTIMER ROLLOUT--
		rollout fStructShellTimer "Set the 'Shell' " width: 362 height:65  --define another rollout 
		(
		-- SHELL SHELL SHELL SHELL SHELL--------------------------------------------------------------------------------------------------------------------------
				--label innerLbl "Inner Amount :" pos:[10,10] width:75 height:24 readOnly:false 
				local innerLbl = @"$userScripts\BorakaScriptPack_vol1\imgs\inneram.jpg"
				local innerLbl_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\inneram_mask.jpg"
				button innerLblbtn "" pos:[-1,9] width:80 height:16 border:false enabled:false images:#(innerLbl, innerLbl_mask, 1, 1, 1, 1, 1)
				spinner innerValue "" range:[0.1,10,0.15] type:#worldunits pos:[85,9] fieldwidth:60 height:18 readOnly:false enabled:true tooltip:"The InnerAmount value of Shell"
				local shell_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\shell_mask.jpg"
				local shell_1 = @"$userScripts\BorakaScriptPack_vol1\imgs\shell_1.jpg"
				button createShell "create Shell" pos:[10,34] width:148 height:20 border:true	 visible:true images:#(shell_1, shell_mask, 1, 1, 1, 1, 1)
				local shell_2 = @"$userScripts\BorakaScriptPack_vol1\imgs\shell_2.jpg"
				button nextStep "Continue" pos:[10,34] width:148 height:20 border:true visible:false images:#(shell_2, shell_mask, 1, 1, 1, 1, 1)	
				local shell_3 = @"$userScripts\BorakaScriptPack_vol1\imgs\shell_3.jpg"
				button nextStep2 "Continue.." pos:[10,34] width:148 height:20 border:true visible:false images:#(shell_3, shell_mask, 1, 1, 1, 1, 1)	
				local shell_4 = @"$userScripts\BorakaScriptPack_vol1\imgs\shell_4.jpg"
				button orderUv "Finalizing" pos:[10,34] width:148 height:20 border:true visible:false images:#(shell_4, shell_mask, 1, 1, 1, 1, 1)	
			
				checkbutton showHideMessages "h" pos:[160,35] width:20 height:20 tooltip:"s-Show | h-Hide shell hints"
				checkbutton showHideThumbs "T" pos:[330,35] width:20 height:20 tooltip:"t-Show | T-Hide Thumbs"	
				checkbutton enableMassImporter "M" pos:[305,35] width:20 height:20 tooltip:"Enable Mass Importer mode"	
			
				local theShell = Shell()
				local theUnwrap = Unwrap_UVW()
				local thePoly = Edit_poly()
				local selObj = undefined
			
				--FUNCTIONS 
				fn createShellfunction = 
				(
					if (selection.count == 0) then
					(
						messagebox "No object selected ! Please select object and try again!"
					)
					else
					(
						selObj = selection[1]
						select selObj
						convertToPoly selObj
						max modify mode
						modpanel.addmodtoselection theShell
						theShell.innerAmount = innerValue.value 
						theShell.outerAmount = 0.0
						theShell.overrideInnerMatID  = true
						theShell.matInnerID  = 1
						theShell.overrideOuterMatID = true
						theShell.matOuterID  = 2
						theShell.overrideMatID = true
						theShell.MatId = 3
						theShell.autosmooth = true
						theShell.autoSmoothAngle = 45
						theShell.selectInnerFaces = true
						convertToPoly selObj
						max modify mode
						subobjectlevel = 4 
						modpanel.addmodtoselection theUnwrap
						--theUnwrap.edit()
						subobjectlevel = 3
						max select all
						theUnwrap.breakSelected()
						pointA = theUnwrap.getSelCenter() 
						theUnwrap.moveSelected [1,0,0]
						convertToPoly selObj
						max modify mode
						subobjectlevel = 4
						$.selectByMaterial 3
						modpanel.addmodtoselection theUnwrap
						subobjectlevel = 3
						max select all
						theUnwrap.breakSelected()
						pointB = theUnwrap.getSelCenter() 
						theUnwrap.moveSelected [2,0,0]
						convertToPoly selObj
						modpanel.addmodtoselection theUnwrap
						subobjectlevel = 3
						theUnwrap.unwrap2.setGeomSelectElementMode false
						theUnwrap.unwrap2.setTVSubObjectMode(3)
						theUnwrap.setIgnoreBackFaceCull false					
						theUnwrap.edit()
						theUnwrap.unwrap.fit()
						$.selectByMaterial 1
						createShell.visible = false
						nextStep.visible = true
						
						if showHideMessages.checked == true then
						(
							messagebox "Deselect the parts you want to keep and press 'Continue' !" beep:false
						)
					)
				)

				fn ContinueTo = 
				(
					nextStep.visible = false
					modpanel.addmodtoselection thePoly
					subobjectlevel = 4
					nextStep2.visible = true
					
					if showHideMessages.checked == true then
					(
						messagebox "Just delete the selected polygons ,then press 'Continue..' again!" beep:false
					)
				)

				fn OrderTheUv =
				(
					nextStep2.visible = false
					convertToPoly selObj
					max modify mode
					modpanel.addmodtoselection theUnwrap
					subobjectlevel = 3
					theUnwrap.selectByMatID 3
					theUnwrap.freeze()
					theUnwrap.selectByMatID 2
					theUnwrap.freeze()
					theUnwrap.unwrap2.setGeomSelectElementMode false
					theUnwrap.unwrap2.setTVElementMode true
					theUnwrap.edit()
					orderUv.visible = true
					
					if showHideMessages.checked == true then
					(
						messagebox "Put the inner parts in the Uv and press 'Finalizing' " beep:false
					)
				)

				fn FinalizingUvShell =
				(
					orderUv.visible = false
					theUnwrap.unwrap2.setTVElementMode false
					convertToPoly selObj
					max create mode
					clearSelection()
					messagebox "DONE !"
					createShell.visible = true
				)
				
				fn checkWhatIsHappenWithUV =
				(
					nextStep.visible = false
					nextStep2.visible = false
					orderUv.visible = false
					createShell.visible = true
					
					if (selection[1] != undefined) then
					(
						selObj = selection[1]
						convertToPoly selObj
						max modify mode
						modpanel.addmodtoselection theUnwrap
						theUnwrap.edit()
					)
					else
					(
						messagebox "Selection not detected ! Select object first !" beep:false
					)
				)
				
				--MAIN
				
				on fStructShellTimer open do 
				(
					fStructShellTimer.showHideThumbs.checked = true
					fStructShellTimer.showHideMessages.checked = true
					fStructShellTimer.enableMassImporter.checked = false

				)
					
					-- right click pressed
					on showHideMessages rightclick do
					(
						if showHideMessages.state == true then 
						(
							messagebox "Hints are ON" beep:false title:"fStructX messages"
						)
						else
						(
							messagebox "Hints are OFF" beep:false title:"fStructX messages"
						)
					)
					
					on createShell rightclick do 
					(
						checkWhatIsHappenWithUV()
					)
					on nextStep rightclick do
					(
						checkWhatIsHappenWithUV()
					)
					
					on nextStep2 rightclick do 
					(
						checkWhatIsHappenWithUV()
					)
					
					on orderUv rightclick do
					(
						checkWhatIsHappenWithUV()
					)
					
					--left button pressed
					on showHideMessages changed HintsState do
					(
						if HintsState == true then
						(
							showHideMessages.text = "h"
						)
						else
						(
							showHideMessages.text = "s"
						)
					)
									
					on createShell pressed do
					(
						createShellfunction()
					)
					
					on nextStep pressed do
					(
						Continueto()
					)
					
					on nextStep2 pressed do 
					(
						OrderTheUv()
					)
					
					on orderUv pressed do
					(
						FinalizingUvShell()
					)
										
				--END SHELL--

		--TIMER TIMER TIMER TIMER TIMER ----------------------------------------------------------------------------------------------------------------------
				Timer clock "seconds" pos:[70,4] width:24 height:24 interval:1000 active:false  --tick once a second 
				local playbtn = @"$userScripts\BorakaScriptPack_vol1\imgs\shell_play.jpg"
				local stopbtn = @"$userScripts\BorakaScriptPack_vol1\imgs\shell_stop.jpg"
				local playstop_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\shell_play_mask.jpg"
				button btnStartStop "play" pos:[205,5] width:70 height:18 enabled:true  border:true images:#(playbtn, playstop_mask, 1, 1, 1, 1, 1)
				colorPicker timerColour "" pos:[201,23] width:74 height:6 enabled:false border:false color:[255,0,0]
				label counterSec "00" pos:[340,7] tooltip:"seconds"
				label separator1 ":" pos:[332,7] tooltip:""
				label counterMin "00" pos:[315,7] tooltip:"minutes"
				label separator2 ":" pos:[307,7] tooltip:""
				label counterHours "00" pos:[290,7] tooltip:"hours"
				
				local sec = 0
				local min = 0
				local hours = 0
			
			fn ticktackhaha = 
			(
				--change minutes
				if (clock.ticks == (sec+60)) then 
				(
					sec += 60	
					min += 1
					
					if(min < 10 ) then
					(
						format "Total time : 0%h : 0%m : 0%s\n" hours min (sec-sec)
					)
					else
					(
						format "Total time : 0%h : %m : 0%s\n" hours min (sec-sec)
					)
					
					counterMin.text =((counterMin.text as integer) + 1)as string 
					counterSec.text = "00"
				)
				--change hours
				if (clock.ticks == (hours+1)*3600) then
				(		
					hours += 1
						
					if(hours < 10 ) then
					(
						format "Total time : 0%h : 0%m : 0%s\n" hours min (sec-sec)
					)
					else
					(
						format "Total time : %h : 0%m : 0%s\n" hours min (sec-sec)
					)
						
					counterHours.text =((counterHours.text as integer) + 1)as string
					counterMin.text = "00"
				)
						
				--change seconds
				counterSec.text =((counterSec.text as integer) + 1) as string			
			)
			
			on clock tick do
			(
				ticktackhaha()
			)
			
			on btnStartStop rightclick do
			(	
				sec = 0
				min = 0
				hours = 0
				clock.ticks = 0
				ticktackhaha()
				counterSec.text = "00"
				counterMin.text = "00"
				counterHours.text = "00"
			)
			
			on btnStartStop pressed do
			(
				if (clock.active == false) then
				(
					clock.active = true
					timerColour.color = [0,150,220]
					btnStartStop.images = #(stopbtn, playstop_mask, 1, 1, 1, 1, 1)
				)
				else
				(
					clock.active = false
					timerColour.color = [255,0,0]
					btnStartStop.images = #(playbtn, playstop_mask, 1, 1, 1, 1, 1)
				)
			)			
			--END TIMER--
			
			-- START THUMB INFO THUMB INFO THUMB INFO --

			on enableMassImporter changed enableMass do 
			(
				if enableMass == true then
				(
					messagebox "Mass importer - ENABLED" beep:false title:"fStructX messages"
				)
				else 
				(
					messagebox "Mass importer - DISABLED" beep:false title:"fStructX messages"
				)
			)
						
			on showHideThumbs changed loadScript do
				(
					if loadScript == true then
					(
						showHideThumbs.text = "T"
						theThumbsScript = @"$userScripts\BorakaScriptPack_vol1\loadThumbs.ms"
						isScriptExist = doesfileExist theThumbsScript
						if (isScriptExist == true) then
							fileIn theThumbsScript
						else
							messagebox "Something go wrong with \"thumbs preview\""
					)
					else
					(
						showHideThumbs.text = "t"
						destroydialog loadFrontAndBack
					)
				)
			--END THUMB INFO
		)
		--END SHELLTIMER ROLLOUT--
		
		rollout loadFrontAndBack "Front/Back views" width:250 height:490
		(
			on loadFrontAndBack open do
			(
				theThumbsScript = @"$userScripts\BorakaScriptPack_vol1\loadThumbs.ms"
				isScriptExist = doesfileExist theThumbsScript
				if (isScriptExist == true) then
					fileIn theThumbsScript
				else
					messagebox "Something go wrong with \"thumbs preview\""
			)
		)
		
		--Create a dialog from the second rollout and pass the .HWND 
		local bgCol = [52,52,52]
		local greyCol = [68,68,68]
		local bgColgreen = [109,174,46]
		local bgColDarkGrey = [52,52,52]
		
		createDialog fStructImporter pos:[(getDialogpos fStruct)[1]+fStruct.width + pdWidth1,(getDialogPos fStruct)[2]+fStruct.height + pdHeight] parent:fStruct.hwnd style:#()
		createDialog fStructShellTimer bgcolor:bgCol pos:[(getDialogpos fStruct)[1]+fStruct.width + pdWidth1,(getDialogPos fStruct)[2]+fStruct.height + pdHeight3] parent:fStruct.hwnd style:#()
		createDialog loadFrontAndBack bgcolor:bgColDarkGrey pos:[(getDialogpos fStruct)[1]+fStruct.width + 373,(getDialogPos fStruct)[2]+fStruct.height + (-393)] parent:fStruct.hwnd style:#()
	)
)
--END F-STRUCTx ROLLOUT  --
createDialog fStruct pos:[100,200] style:#(#style_sysmenu,#style_toolwindow) 