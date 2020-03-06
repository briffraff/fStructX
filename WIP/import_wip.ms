--===============================================================================================================================--
-- MD workflow - IMPORTER
-- author: Riff-Raff
--===============================================================================================================================--

try ( destroyDialog fStructImporter) catch () 

rollout fStructImporter "fStructImporter" width:450 height:424
	
(
	
--===============--
-- UI
--================-
	button 'pickLocation' "Pick" pos:[25,71] width:64 height:24 align:#left border:true 
	edittext 'editLocation' "" pos:[95,71] width:177 height:24 readOnly:false align:#left
		
	checkbutton 'enableImport' "Enable import" pos:[31,111] width:137 height:26 align:#left tooltip: "* Enable/Disable the object's lists" 
	local importBtnTooltip =  "1. LMB = Import selected object" + "\n" + "2. RMB = Refresh list"
	button 'importBtn' "Locked - Import" pos:[10,289] width:240 height:40 align:#left border:true enabled:false tooltip:importBtnTooltip
	
	listbox 'listObj' "" items:#() pos:[30,150] width:400 height:10 align:#left selection:0 enabled:false 
	listbox 'listObjMD' "" items:#() pos:[30,350] width:400 height:4 align:#left selection:0 enabled:false
	
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
	
--==================--
-- MAIN
--==================--
	
-- pick location 
	on pickLocation pressed do
	(
		NewGarmentPath = getSavePath()
		if ( NewGarmentPath != undefined ) then
				(
					editLocation.text = NewGarmentPath
					thePTh = editLocation.text
					objPath =  getFiles (thePTh +"\\Obj"+ "\\*.obj" )
					objPathMd = getFiles (thePTh +"\\Obj\\MD"+ "\\*.obj" ) 
					--local files =  getFiles objPath
					--local filesMd = getFiles objPathMd
					listObj.items = for f in objPath collect (filenameFromPath f)
					listObjMD.items = for f in objPathMd collect (filenameFromPath f)
					
						--print the results
					for a in objPath do
						( 
							a=filterstring a @"\" 
							print a[a.count]							
						)
					for a in objPathMd do
						( 
							a=filterstring a @"\" 
							print a[a.count]	
						)
				

				)
	)

-- refresh the database list 
	on importbtn rightclick do
	(
		clearlistener()
				thePTh = editLocation.text
				objPath = (thePTh +"\\Obj"+ "\\*.obj" )
				objPathMd = (thePTh +"\\Obj\\MD"+ "\\*.obj" ) 
				local files = getFiles objPath
				local filesMd = getFiles objPathMd
				listObj.items = files --for f in files collect (filenameFromPath f)
				listObjMD.items = filesmd --for f in filesmd collect (filenameFromPath f)
				listObj.selection = 0
				listObjMD.selection = 0
		
			--print the results
					for a in files do
						( 
							a=filterstring a @"\" 
							print a[a.count]	
						)
						
					for a in filesmd do
						( 
							a=filterstring a @"\" 
							print a[a.count]	
						)
	)

--Enable button
	on enableImport changed theState do
	(
		if (enableImport.state == true )	then
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
		
				if (editLocation.text == "") then
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
									 selectedObject = listObj.selected  
									 filterObject = filterstring selectedObject "\\"
									 objectLastItem = filterObject[filterObject.count]
									 importedObject = txt + objectLastItem
									importFile listObj.selected #noprompt
									
									--create and import to 4_Product layer
									createImportObjectsInLayer()
									--printing the results
									print importedObject
								)	
								
							if (listObjMD.selection != 0)do 
								(	
								--md import
									selectedObjectmd = listObjMD.selected  
									 filterObjectmd = filterstring selectedObjectmd "\\"
									 objectLastItemmd = filterObjectmd[filterObjectmd.count]
									 importedObjectmd = txt + objectLastItemmd
									importFile listObjMD.selected #noprompt
									
									--create and import to 4_Product layer
									createImportObjectsInLayer() 
									--printing the results
									print importedObjectmd
								)		
					)							
				)
	)
)
createDialog fStructImporter
