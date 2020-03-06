global tempfStructFolder = @"C:\Users\Public\Documents\fStructX\"
global fstructxIniFile = @"C:\Users\Public\Documents\fStructX\fstructXIni.ini"
global iniSectionDates = "Dates"
global iniSectionInfo = "Info"
global iniSectionUsedGarments = "LastUsedGarments"
global scriptName = "fStructX"
global author = "RiffRaff"
global creationDate = "10 Feb 2018"
global theCrew = "Borko,Ana,Dido,Mariq,Petya,Zara,Hristiyana,Marina,Mims,Margi,MimiG,Sasho,Andji,Iliqna,Liubomira"
global lastModification = "16 Feb 2020 by RiffRaff"
global cleanAll = "/ CLEAN ALL"
global errorMessageTitle = "Something went wrong ! Try again!"
global okMessage = "Process completed !"
global fTitle = "fStructX | Importer"
global cleanMessage = "Paths wouldn't be available yet! Do you want to continue ?"
global brokenPath = "Sorry, Broken path!"


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
	
	-- Info
	setIniSetting fstructxIniFile iniSectionInfo "scriptName" scriptName
	setIniSetting fstructxIniFile iniSectionInfo "author" author
	setIniSetting fstructxIniFile iniSectionInfo "marvCrew" theCrew
	
	-- Used Garments
	setIniSetting fstructxIniFile iniSectionUsedGarments cleanAll cleanMessage
)
		
try ( destroyDialog ddl_test) catch ()

rollout ddl_test "Drop-Down List"
(
		
	fn collectionReversed = 
	(
		--get keys
		local sectionKeys = getIniSetting fstructxIniFile iniSectionUsedGarments
		--get values
		local sectionKeysValues = for i in sectionKeys collect (getIniSetting fstructxIniFile iniSectionUsedGarments i)
		-- reverse collection
		local reverseCollection = for i = sectionKeys.count to 1 by -1 collect sectionKeys[i]
	)

	local collection = collectionReversed()

	local img_pick = @"$userScripts\BorakaScriptPack_vol1\imgs\pickButton.bmp"
	local img_pick_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\pickButton_mask.bmp"
	button pickLocation "" pos:[15,10] width:50 height:24 align:#left border:false images:#(img_pick, img_pick_mask, 1, 1, 1, 1, 1)
	edittext editLocation "" pos:[70,10] width:150 height:24 readOnly:false text:"..please set a path" align:#left
	dropdownlist choseGarment height:10 items:collection selection:0 tooltip:"List of used garments" 
	
	on choseGarment selected i do 
	(
		--get current kvp
		local currentSelection = choseGarment.items[i]
		local currentValue = (getIniSetting fstructxIniFile iniSectionUsedGarments currentSelection)
		format "You selected '%' - '%'!\n" currentSelection currentValue
	
		if(currentSelection != undefined and currentSelection != cleanAll) then
		(			
			--attach new name
			editLocation.text = currentValue
			
			--check if exist at ini file
			isExists = hasIniSetting fstructxIniFile iniSectionUsedGarments (currentSelection as string)
			
			if (isExists == true) then
			(
				--del
				delIniSetting fstructxIniFile iniSectionUsedGarments (currentSelection as string)
			)
			--write
			setIniSetting fstructxIniFile iniSectionUsedGarments (currentSelection as string) (currentValue as string)
			
			--refresh dropdown list
			local collection = collectionReversed()
			choseGarment.items = collection
			choseGarment.selection = 1
		)
		else
		(
			IsCleanExist = hasIniSetting fstructxIniFile iniSectionUsedGarments cleanAll
			keysCollect = getIniSetting fstructxIniFile iniSectionUsedGarments
			
			yesNo = queryBox cleanMessage title:fTitle beep:false
			if (yesNo) then
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
					editLocation.text = "..please set a path"
				)
				
				--refresh dropdown list
				local collection = collectionReversed()
				choseGarment.items = collection
			)
		)
	)
		
	on pickLocation pressed do 
	(
		--get path
		NewGarmentPath = getSavePath()
					
		if (NewGarmentPath != "") then
		(
			local input = filterstring NewGarmentPath "\:"
			local lastelement = input[input.count]
			local lastElementParts = (filterstring lastelement "_").count
		)
		
		if(NewGarmentPath != undefined)then
		(
			if (NewGarmentPath != "" and lastelement != "Obj" and lastelement != "Maps" and lastelement != "Garments" and lastelement != "Renders" and lastelement != "FBX" and lastelement != "Ref") then 
			(
				if(lastElementParts == 2) then
				(
				
					editLocation.text =  NewGarmentPath
					
					--split the string path
					local fltr = filterstring NewGarmentPath "\:"
					local fltrLastIdx = fltr[fltr.count]
					
					--get current kvp
					local currentKey = fltrLastIdx
					local currentValue = NewGarmentPath
					
					--check if exist at ini file
					isExists = hasIniSetting fstructxIniFile iniSectionUsedGarments (currentKey as string)
					
					if (isExists == true) then
					(
						--del
						delIniSetting fstructxIniFile iniSectionUsedGarments (currentKey as string)
					)
					
					--write
					setIniSetting fstructxIniFile iniSectionUsedGarments (currentKey as string) (currentValue as string)
					
					--refresh dropdown list
					local collection = collectionReversed()
					choseGarment.items = collection
					choseGarment.selection = 1
				)
				else
				(
					editLocation.text = brokenPath
				)
			)
		)
		else
		(
			editLocation.text = brokenPath
		)
	)
			
	on editLocation entered txtPathInput do
	(
		if (txtPathInput != "") then
		(
			local input = filterstring txtPathInput "\:"
			local lastelement = input[input.count]
			local lastElementParts = (filterstring lastelement "_").count
		)
		
		if (txtPathInput != "" and lastelement != "Obj" and lastelement != "Maps" and lastelement != "Garments" and lastelement != "Renders" and lastelement != "FBX" and lastelement != "Ref") then 
		(
			if(lastElementParts == 2) then
			(
				NewGarmentPath = editLocation.text
				
				--split the string path
				local fltr = filterstring NewGarmentPath "\:"
				local fltrLastIdx = fltr[fltr.count]
				
				--get current kvp
				local currentKey = fltrLastIdx
				local currentValue = NewGarmentPath
				
				--check if exist at ini file
				isExists = hasIniSetting fstructxIniFile iniSectionUsedGarments (currentKey as string)
				
				if (isExists == true) then
				(
					--del
					delIniSetting fstructxIniFile iniSectionUsedGarments (currentKey as string)
				)
				
				--write
				setIniSetting fstructxIniFile iniSectionUsedGarments (currentKey as string) (currentValue as string)
				
				--refresh dropdown list
				local collection = collectionReversed()
				choseGarment.items = collection
				choseGarment.selection = 1
			)
			else
			(
				editLocation.text = brokenPath
			)
		)
		else
		(
			editLocation.text = brokenPath
		)
	)
)

createDialog ddl_test 250 250