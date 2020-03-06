--===============================================================================================================================--
-- MD workflow - IMPORTER
-- author: Riff-Raff
--===============================================================================================================================--

try ( destroyDialog fStructImporter) catch () 

rollout fStructImporter "fStructImporter" width:450 height:424
	
(
	local filesObjArr = #()
	local fileObjNamesArr = #()
	local filesMdArr = #()
	local fileMdNamesArr = #()
	local newGarmentPath = undefined
	local selectedFileIdx = 0
	
	local importBtnTooltip =  "1. LMB = Import selected object" + "\n" + "2. RMB = Refresh list"
--===============--
-- UI
--===============--
	button pickLocation "Browse" pos:[25,71] width:64 height:24 align:#left border:true 
	edittext editLocation "" pos:[95,71] width:177 height:24 readOnly:false align:#left
		
	checkbutton enableImport "Enable import" pos:[31,111] width:137 height:26 align:#left tooltip: "* Enable/Disable the object's lists" 
	checkBox chkBox_showFullPath "Show full path" pos:[200,120]
	
	button importBtn "Locked - Import" pos:[10,289] width:240 height:40 align:#left border:true enabled:false tooltip:importBtnTooltip
	
	multilistbox listObj "" items:#() pos:[30,150] width:400 height:10 align:#left selection:0 enabled:false 
	multilistbox listObjMD "" items:#() pos:[30,350] width:400 height:4 align:#left selection:0 enabled:false
	
--==================--
-- FUNCTIONS
--==================--
	
	--create and import to 4_Product layer
	fn createImportObjectsInLayer = 
	(
		layerName = "4_Product"
		LayerManager.newLayerFromName layerName
		newLayer = layermanager.getLayerFromName layerName
		for obj in selection do newLayer.addNode obj
	)
	
	fn FillListboxes thePath =
	(
		filesObjArr =sort (getFiles (thePath +"\\Obj"+ "\\*.obj" ))
		fileObjNamesArr = sort(for f in filesObjArr collect (filenameFromPath f))
		filesMdArr = sort (getFiles (thePath +"\\Obj\\MD"+ "\\*.obj" )) 
		fileMdNamesArr = sort(for f in filesMdArr collect (filenameFromPath f))
		
		listObj.items = fileObjNamesArr
		listObjMD.items = fileMdNamesArr 
	)
	
--==================--
-- MAIN
--==================--
	
-- pick location 
	on pickLocation pressed do
	(
		newGarmentPath = getSavePath()
		if ( newGarmentPath != undefined ) then
		(
			editLocation.text = newGarmentPath			
			FillListboxes newGarmentPath
		)
		else
			newGarmentPath = undefined
	)

-- refresh the database list 
	on chkBox_showFullPath changed state do
	(
		if state then
		(
			listObj.items = filesObjArr
			listObjMD.items = filesMdArr
		)
		else
		(
			listObj.items = fileObjNamesArr
			listObjMD.items = fileMdNamesArr
		)
	)
	
	on importbtn rightclick do
	(
		clearlistener()
		if newGarmentPath != undefined do
		(
			if chkBox_showFullPath.checked == true then
			(
				FillListboxes newGarmentPath
				
				listObj.items = filesObjArr
				listObjMD.items = filesMdArr
			)
			else
			(
				FillListboxes newGarmentPath
			)
		)
		listObj.selection = 0
		listObjMD.selection = 0
	)

	
--Enable button
	on enableImport changed theState do
	(
		if theState then
		(
			listObj.enabled = true
			listObjMD.enabled = true
			importBtn.caption = "Import"
			importBtn.enabled = true
		)
		else
		(
			listObj.enabled = false
			listObjMD.enabled = false
			listObj.selection = 0
			listObjMd.selection = 0
			importBtn.caption = "Import - Locked"
			importBtn.enabled = false
		)
	)
	
--swap selection list
	on listObj selected items do
	(
		listObjMd.selection = 0
	)
	
	on listObjMD selected items do
	(
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
				txt = "Imported object: " 
				
				if (listObj.selection != 0)do 
				(	
					--obj import
					local selectedFileIdx = listObj.selection
						for a in selectedFileIdx do
						(
							importFile filesObjArr[a] #noprompt 
							local importedObject = txt + fileObjNamesArr[a]
							
							--printing the results
							print importedObject
						)
				
					--create and import to 4_Product layer
					createImportObjectsInLayer()
				)	
					
				if (listObjMD.selection != 0)do 
				(	
					--md import
					local selectedFileIdx = listObjMD.selection
						for a in selectedFileIdx do
						(
							importFile filesMdArr[a] #noprompt
							local importedObjectmd = txt + fileMdNamesArr[a]
							
							--printing the results
							print importedObjectmd
						)
									
					--create and import to 4_Product layer
					createImportObjectsInLayer() 
				)		
			)							
		)
	)
)
createDialog fStructImporter
