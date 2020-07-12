-----------------------------------------------------
-- Osnovnata programa - '000Exporter'
-- Programata premestva selektiraniqt obekt na coordinati 0,0,0 i exportva obekta s negovoto ime v papka *.max\obj ,kato .obj
-- avtor : Borislav Borisov - 'riff-raff'
-----------------------------------------------------
try ( defilterSelectedNameoyDialog ExportAtZero) catch ()

global scriptName = "000 Exporter"

global selectedObject = ""
global replacedSymbol = ""
global fileName = ""
global exportHere = ""

global reduced = "_Reduced"
global unreal = "_UE"
global objExtension = ".obj"
global fbxExtension = ".fbx"
global legal_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_" -- legal characters in file name

global toMDFolder = "\\Obj\\MD\\"
global toWrongNamesFolder = "\\Obj\\WrongNames\\"
global toUnrealFolder = "\\Obj\\UE\\"
global toObjFolder = "\\Obj\\"

global noSelectionMsg = "No geometry selected!"

global theClasses = exporterPlugin.classes
global obj = ObjExp
global fbx = FBXEXP

rollout ExportAtZero "ExportAtZeroDialogWindow" width:150 height:75  --define a rollout 
(
	label typeOfGeometry "Select type to export:" pos:[20,5]
	checkbutton checkObj ".OBJ" pos:[15,25] width:120 height:20
	checkbutton checkFbx ".FBX" pos:[15,47] width:120 height:20

	--- FUNCTIONS ---
	
	--create folders
	--obj
	fn createObjFolder =
	(
		objfolder = maxFilePath + toMDFolder
		isFolderExist = doesFileExist objfolder 
		if	( isFolderExist == false ) then
			makeDir objfolder all:true 
	)

	--wrong names
	fn createWrongNamesFolder =
	(
		objfolder = maxFilePath + toWrongNamesFolder
		isFolderExist = doesFileExist objfolder 
		if	( isFolderExist == false ) then
			makeDir objfolder all:true 
	)

	--UE
	fn createUEFolder =
	(
		ueFolder = maxFilePath + toUnrealFolder
		isFolderExist = doesFileExist ueFolder
			if	( isFolderExist == false ) then
			makeDir ueFolder all:true
	)

	-- clear smoothing groups
	fn clearSG currentSelection =
	(
		try
		(
			local numFaces = polyop.getNumfaces currentSelection
			local faces = (for i in 1 to numFaces collect i) as bitarray
			polyOp.setFaceSmoothGroup currentSelection faces 1
		)
		catch
		(
		)
	)
	
	fn checkForBulgarianChars currentSelection = -- fname must be just filename, no path....
	(
		local curSel = copy currentSelection
		local count = curSel.count
		
		--check if all chars are valid
		for i = 1 to count do
		(
			if (findString legal_characters curSel[i]) == undefined do -- replace illegal characters with *
			(
				replacedSymbol = "*"
				curSel[i] = replacedSymbol
			)
		)

		--curSel
		selection[1].name = curSel

		local isOk = false
		if(replacedSymbol.count == 0 and replacedSymbol == "") then
		(
			isOk = true
		)
		else
		(
			isOk = false
		)

		return isOk
	)

	fn cloneAndPlaceToZero = 
	(
		maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
		select nnl
		$.pos = [0,0,0]
	)
	
	fn letExport fileName exportHere classIndex =
	(
		--check for cyr
		local readyToExport = checkForBulgarianChars fileName

		if (readyToExport == true) then
		(
			-- with *.OBJ export dialog
			exportFile (exportHere) selectedOnly:true  using:theClasses[classIndex]
			
			-- set face smooth groups
			clearSG fileName

			--delete objects
			max delete
		)
		else
		(
			messagebox "The name contains NON LATIN symbols ! Search for '*' " title:"WRONG SYMBOLS"
			
			--delete objects
			max delete
			
			replacedSymbol = ""
		)

	)
	----------------------------------------------------------------------------------------------------------
	----EVENTS---

	-- OBJ
	on checkObj changed exportObj do
	(
		if (exportObj == true and selection.count == 1) then
		(
			--create needed folders
			createObjFolder()
			createWrongNamesFolder()
			createUEFolder()

			--selected object
			selectedObject = selection[1]
			
			--get export class index
			local objClassIndex = findItem theClasses obj

			-- filter legal characters - remove "_"
			local legalCharacterMinusUnderScoreDivider = substring legal_characters 1 (legal_characters.count-1)
			--#("_", "_", "_", "_")
			local filterSelectedName = filterString selectedObject.name legalCharacterMinusUnderScoreDivider
			--4
			local underscoresCount = filterSelectedName.count
			--elements of the name
			local selectionElementsCount = (FilterString selectedObject.name "_").count

			if (underscoresCount >= 1) then
			(
							
				--"_"
				local suffix = filterSelectedName[underscoresCount]
				--"_Reduced"
				local suffixReduced = suffix + "Reduced"
				--"_UE"
				local suffixUE = suffix + "UE"

				-- name patterns
				local rowPattern = matchpattern selectedObject.name pattern:"SM_*_*_*"
				local weldedPattern = matchpattern selectedObject.name pattern:"SM_*_*_*_"
				local reducedPattern = matchpattern selectedObject.name pattern:"SM_*_*_*_Reduced"
				local uePattern = matchpattern selectedObject.name pattern:"SM_*_*_*_UE"

				-- to MD folder
				if(selectionElementsCount == 4 and underscoresCount == 3 and rowPattern) then
				(
					fileName = selectedObject.name
					exportHere = maxFilePath + toMDFolder + fileName + objExtension
					print "MD"
				)
				-- to Obj folder
				else if(underscoresCount == 4 and suffix == "_" and weldedPattern or 
					underscoresCount == 4 and selectionElementsCount == 5 and suffixReduced == reduced and reducedPattern) then
				(
					fileName = selectedObject.name
					exportHere = maxFilePath + toObjFolder + fileName + objExtension
					print "Obj"
				)
				--to UE folder
				else if(underscoresCount == 4 and suffixUE == unreal and uePattern) then
				(
					fileName = selectedObject.name
					exportHere = maxFilePath + toUnrealFolder + (substring fileName 1(fileName.count - 3)) + objExtension
					print "UE"
				)	
				else
				(
					fileName = selectedObject.name
					exportHere = maxFilePath + toWrongNamesFolder + fileName + objExtension
					print "WrongNames"
				)

				--To 0,0,0
				cloneAndPlaceToZero()

				--EXPORT
				letExport fileName exportHere objClassIndex			
			)
			else
			(
				messageBox "Object name is wrong!" title:scriptName beep:false
			)
				
		)	
		else
		(
			--if no selection
			messagebox noSelectionMsg title:scriptName
		)

		--deselect button
		checkObj.state = false	
	)
	




	-- FBX
	on checkFbx changed exportFbx do
	(
		if (exportFbx == true and selection.count == 1) then
		(
			selectedObject = selection[1]
						
			maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
			select nnl
			$.pos = [0,0,0]
			
			-- creating of variable with class of exporter plugins
			local theClasses = exporterPlugin.classes

			local fbxClassIndex = finditem theClasses fbx
			
			local filterSelectedName = filterString selection[1].name "ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvvxyz 1234567890 -"
			--#("_", "_", "_", "_")
			local underscoresCount = filterSelectedName.count
			--4
			local suffix = filterSelectedName[filterSelectedName.count]
			--"_"
			local suffixReduced = suffix + "Reduced"
			--"_Reduced"
			
			local suffixUE = suffix + "UE"
			--"_UE"
						
			if(underscoresCount == 4 and matchpattern selectedObject.name pattern:"*_*_*_*_UE") then
			(
				local fileName = selectedObject.name
				local exportHere = maxFilePath + "\\Obj\\UE\\"
				local objSavePath = exportHere + fileName 
			)
			else if(underscoresCount == 4 and suffix == "_" or underscoresCount == 4 and suffixReduced == "_Reduced") then
			(
				local fileName = selectedObject.name
				local exportHere = maxFilePath + "\\Obj\\"
				local objSavePath = exportHere + fileName 
			)
			else if (underscoresCount == 3 and matchpattern selectedObject.name pattern:"*_*_*_*") then
			(
				local fileName = selectedObject.name
				local exportHere = maxFilePath + "\Obj\\MD\\"
				local objSavePath = exportHere + fileName 
			)
			else
			(
				local fileName = selectedObject.name
				local exportHere = maxFilePath + "\\Obj\\WrongNames\\"
				local objSavePath = exportHere + fileName 
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