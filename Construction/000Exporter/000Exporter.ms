-----------------------------------------------------
-- Osnovnata programa - '000Exporter'
-- Programata premestva selektiraniqt obekt na coordinati 0,0,0 i exportva obekta s negovoto ime v papka *.max\obj ,kato .obj
-- avtor : Borislav Borisov - 'riff-raff'
-----------------------------------------------------
try ( destroyDialog ExportAtZero) catch ()

global selectedObject = ""
global replacedSymbol = ""

rollout ExportAtZero "ExportAtZeroDialogWindow" width:150 height:75  --define a rollout 

(
	label typeOfGeometry "Select type to export:" pos:[20,5]
	checkbutton checkObj ".OBJ" pos:[15,25] width:120 height:20
	checkbutton checkFbx ".FBX" pos:[15,47] width:120 height:20

--- FUNCTIONS ---
	
fn createObjFolder =
	(
		 objfolder = maxFilePath + "\\Obj\\MD\\"
		 isFolderExist = doesFileExist objfolder 
			if	( isFolderExist == false ) then
				makeDir objfolder all:true 
	)
	
fn createWrongNamesFolder =
	(
		 objfolder = maxFilePath + "\\Obj\\WrongNames\\"
		 isFolderExist = doesFileExist objfolder 
			if	( isFolderExist == false ) then
				makeDir objfolder all:true 
	)

fn createUEFolder =
	(
		ueFolder = maxFilePath + "\\Obj\\UE\\"
		isFolderExist = doesFileExist ueFolder
			if	( isFolderExist == false ) then
			makeDir ueFolder all:true
	)

-- fn createFBXFolder =
-- 	(
-- 		 FBXfolder = maxFilePath + "\\FBX\\MD\\"
-- 		 isFolderExist = doesFileExist FBXfolder 
-- 			if	( isFolderExist == false ) then
-- 				makeDir FBXfolder all:true 
-- 	)

-- fn createFBXWrongNameFolder =
-- (
-- 	 FBXfolder = maxFilePath + "\\FBX\\WrongNames\\"
-- 	 isFolderExist = doesFileExist FBXfolder 
-- 		if	( isFolderExist == false ) then
-- 			makeDir FBXfolder all:true 
-- )

-- fn createFBXUEFolder =
-- (
-- 	ueFolder = maxFilePath + "\\FBX\\UE\\"
-- 	isFolderExist = doesFileExist ueFolder
-- 		if	( isFolderExist == false ) then
-- 		makeDir ueFolder all:true
-- )

-- adding a smoothing groups
fn clearSG =
	(
		try
		(
			local numFaces = polyop.getNumfaces $
			local faces = (for i in 1 to numFaces collect i) as bitarray
			polyOp.setFaceSmoothGroup $ faces 1
		)
		catch
		(
		)
	)
	
fn checkForBulgarianChars fileName = -- fname must be just filename, no path....
(
	local legal_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-" -- illegal characters in file name
	local res = copy fileName
	
	-- make sure the object name is legal for a filename
	local count = res.count
	
	for i = 1 to count do
	(
		if (findString legal_characters res[i]) == undefined do -- replace illegal characters with *
		(
			res[i] = "*"
			replacedSymbol = "*"
		)
	)
	--
	res
	selection[1].name = res
	--print replacedSymbol
	
-- 	if (replacedSymbol.count >= 1 and replacedSymbol == "*") then
-- 	(
-- 		messagebox "The name contains non latin letters ! Search for '*' "
-- 	)
)

	on checkObj changed exportObj do
	(
		if (exportObj == true and selection.count == 1) then
		(
			createObjFolder()
			createWrongNamesFolder()
			createUEFolder()
			
			selectedObject = selection[1]
						
			maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
			select nnl
			$.pos = [0,0,0]
			
			-- creating of variable with class of exporter plugins
			local theClasses = exporterPlugin.classes

			local objClassIndex = findItem theClasses ObjExp

			local str = filterString selection[1].name "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvvxyz1234567890-"
			--#("_", "_", "_", "_")
			local suffixCount = str.count
			--4
			local suffix = str[str.count]
			--"_"
			local suffixReduced = suffix + "Reduced"
			--"_Reduced"
			
			local suffixUE = suffix + "UE"
			--"_UE"
			
			if(suffixCount == 4 and matchpattern selectedObject.name pattern:"*_*_*_*_UE") then
			(
				local fileName = selectedObject.name
				local pathHere = maxFilePath + "\\Obj\\UE\\"
				local objSavePath = pathHere + (substring fileName 1(fileName.count - 3))
			)
			else if(suffixCount == 4 and suffix == "_" or suffixCount == 4 and suffixReduced == "_Reduced") then
			(
				local fileName = selectedObject.name
				local pathHere = maxFilePath + "\\Obj\\"
				local objSavePath = pathHere + fileName 
			)
			else if (suffixCount == 3 and matchpattern selectedObject.name pattern:"*_*_*_*") then
			(
				local fileName = selectedObject.name
				local pathHere = maxFilePath + "\\Obj\\MD\\"
				local objSavePath = pathHere + fileName 
			)
			else
			(
				local fileName = selectedObject.name
				local pathHere = maxFilePath + "\\Obj\\WrongNames\\"
				local objSavePath = pathHere + fileName 
			)
			
			fileName = selection[1].name
			checkForBulgarianChars fileName
						
			if (replacedSymbol.count == 0 and replacedSymbol == "") then
			(	
				-- with *.OBJ export dialog
				exportFile (objSavePath ) selectedOnly:true  using:theClasses[objClassIndex]
				
				-- set face smooth groups
				clearSG()

				--delete objects
				actionMan.executeAction 0 "40020"
			)
			else
			(
				messagebox "The name contains NON LATIN symbols ! Search for '*' " title:"WRONG SYMBOLS"
				
				--delete objects
				actionMan.executeAction 0 "40020"
				
				replacedSymbol = ""
			)
		)
			
		else
		(
			messagebox "No geometry selected!" title:"000 Exporter message"
		)
		checkObj.state = false	
	)
	
	on checkFbx changed exportFbx do
	(
		if (exportFbx == true and selection.count == 1) then
		(
-- 			createFBXFolder()
-- 			createFBXWrongNameFolder()
-- 			createFBXUEFolder()

			selectedObject = selection[1]
						
			maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
			select nnl
			$.pos = [0,0,0]
			
			-- creating of variable with class of exporter plugins
			local theClasses = exporterPlugin.classes

			local fbxClassIndex = finditem theClasses FBXEXP
			
			local str = filterString selection[1].name "ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvvxyz 1234567890 -"
			--#("_", "_", "_", "_")
			local suffixCount = str.count
			--4
			local suffix = str[str.count]
			--"_"
			local suffixReduced = suffix + "Reduced"
			--"_Reduced"
			
			local suffixUE = suffix + "UE"
			--"_UE"
						
			if(suffixCount == 4 and matchpattern selectedObject.name pattern:"*_*_*_*_UE") then
			(
				local fileName = selectedObject.name
				local pathHere = maxFilePath + "\\Obj\\UE\\"
				local objSavePath = pathHere + fileName 
			)
			else if(suffixCount == 4 and suffix == "_" or suffixCount == 4 and suffixReduced == "_Reduced") then
			(
				local fileName = selectedObject.name
				local pathHere = maxFilePath + "\\Obj\\"
				local objSavePath = pathHere + fileName 
			)
			else if (suffixCount == 3 and matchpattern selectedObject.name pattern:"*_*_*_*") then
			(
				local fileName = selectedObject.name
				local pathHere = maxFilePath + "\Obj\\MD\\"
				local objSavePath = pathHere + fileName 
			)
			else
			(
				local fileName = selectedObject.name
				local pathHere = maxFilePath + "\\Obj\\WrongNames\\"
				local objSavePath = pathHere + fileName 
			)
			
			fileName = selection[1].name
			checkForBulgarianChars fileName
			
			if (replacedSymbol.count == 0 and replacedSymbol == "") then
			(	
				-- with *.FBX export dialog
				exportFile (objSavePath ) selectedOnly:true  using:theClasses[fbxClassIndex]
				
				-- set face smooth groups
				clearSG()

				--delete objects
				actionMan.executeAction 0 "40020"
			)
			else
			(
				messagebox "The name contains NON LATIN symbols ! Search for '*' " title:"WRONG SYMBOLS"
				
				--delete objects
				actionMan.executeAction 0 "40020"
				
				replacedSymbol = ""
			)
		)
		else
		(
			messagebox "No geometry selected!" title:"000 Exporter message"
		)
		
		checkFbx.state = false
	)
)
createDialog ExportAtZero pos:[200,205] style:#() 