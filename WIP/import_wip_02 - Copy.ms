--===============================================================================================================================--
-- MD workflow - IMPORTER
-- author: Riff-Raff
--===============================================================================================================================--

try ( destroyDialog fStructImporter) catch () 

	global fStructImporter
	
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
					theUVpath = fStructImporter.editLocation.text
					theUVpathIdx = filterstring theUVpath "\\ :"
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
						--launch Atangeo Balancer nPro64
						shelllaunch "C:\Program Files (x86)\Atangeo\Balancer nPro and Decimon\BalancerNPro64.exe" itemsObjNames[a]
						format "-> BALANCER : %\n" itemsObjNames[a]							
					)
					format "\n"
			)
				
			if (itemMdIdx != 0)do 
			(	
				for a in itemMdIdx do
					(
						--launch Atangeo Balancer nPro64
						shelllaunch "C:\Program Files (x86)\Atangeo\Balancer nPro and Decimon\BalancerNPro64.exe" itemsMdNames[a]							
						format "-> BALANCER : %\n" itemsMdNames[a]
					)
					format "\n"
			)
	)
	
	--=====
	--RCMenu
	--=====
	rcmenu fStructRightClickMenuBalancer
	(
		menuItem executeBalancer "Execute Balancer" checked:false bgcolor:red
		menuItem uvToPs "UVmap to Photoshop" checked:false
			
		on fStructRightClickMenuBalancer open do
			(
				--
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

rollout fStructImporter "fStructImporter" width:450 height:424
	
(
	local filesObjArr = #()
	local fileObjNamesArr = #()
	local filesMdArr = #()
	local fileMdNamesArr = #()
	local newGarmentPath = undefined
	local selectedFileIdx = 0
	local txtInput = undefined
	local sel = 0
	
	local importBtnTooltip =  "1. LMB = Import selected object" + "\n" + "2. RMB = Refresh list"
--===============--
-- UI
--===============--
	button pickLocation "Browse" pos:[25,71] width:64 height:24 align:#left border:true 
	edittext editLocation "" pos:[95,71] width:177 height:24 readOnly:false align:#left
		
	checkbutton enableImport "Enable import" pos:[31,111] width:137 height:26 align:#left tooltip: "* Enable/Disable the object's lists" 
	checkBox chkBox_showFullPath "Show full path" pos:[200,120]
	
	button importBtn "Locked - Import" pos:[10,289] width:240 height:40 align:#left border:true enabled:false tooltip:importBtnTooltip
	
	multilistbox listObj "" items:#() selection:#() pos:[30,150] width:400 height:10 align:#left selection:0 enabled:false 
	multilistbox listObjMD "" items:#() selection:#() pos:[30,350] width:400 height:4 align:#left selection:0 enabled:false
	
	edittext searchtxt "" pos:[0,0] width:400 height:1 align:#left enabled:false
	checkbutton searchbtn "search" pos:[405,0] width:40 height:18 align:#left enabled:false border:false checked: false
	
--==================--
-- FUNCTIONS
--==================--
	
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
	fn FillListboxes thePath =
	(
		filesObjArr =(getFiles (thePath +"\\Obj"+ "\\*.obj" ))
		fileObjNamesArr = (for f in filesObjArr collect (filenameFromPath f))
		filesMdArr = (getFiles (thePath +"\\Obj\\MD"+ "\\*.obj" )) 
		fileMdNamesArr = (for f in filesMdArr collect (filenameFromPath f))
		
		listObj.items = fileObjNamesArr
		listObjMD.items = fileMdNamesArr 
	)
	
	-- Search for word 
	fn SearchForWordInArray theArray theWord caseSensitive:true =
	(
		pattern = "*" + theWord + "*"
		for j = 1 to theArray.count where matchpattern theArray[j] pattern:pattern ignoreCase:caseSensitive collect j
	)
	
	fn creatingLog = 
	(
			local ArrIdx = SearchForWordInArray fileObjNamesArr searchtxt.text ignoreCase:true
			listObj.selection = ArrIdx
			local ArrNames = for n in fileObjNamesArr collect n
			
			local ArrMdIdx = SearchForWordInArray fileMdNamesArr searchtxt.text ignoreCase:true
			listObjMd.selection = ArrMdIdx
			local ArrMdNames = for n in fileMdNamesArr collect n
				
			thePath = editLocation.text
			filterName = filterstring thePath "\\ : "
			filterIdx = filterName[filterName.count]
			exportFileLog = thePath + "\\" + filterIdx + "_Statistics.txt"
			print exportFilelog
		
			--Deleting logfile
			df = deleteFile exportfilelog
		
			--Creating logfile
			if (doesFileExist exportFilelog == false )then 
				(
					t = localtime	
					cf = createFile exportfilelog

					format "---------- STATISTICS for % ----------\n\n" filterIdx to:cf
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

	fn printSome = 
	(
			local ArrIdx = SearchForWordInArray fileObjNamesArr searchtxt.text ignoreCase:true
			listObj.selection = ArrIdx
			local ArrNames = for n in fileObjNamesArr collect n
			
			local ArrMdIdx = SearchForWordInArray fileMdNamesArr searchtxt.text ignoreCase:true
			listObjMd.selection = ArrMdIdx
			local ArrMdNames = for n in fileMdNamesArr collect n
			
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
			printSome()
			searchbtn.checked = true
		)
		else 
		(
			listObjMd.selection = 0
			listObj.selection = 0
			searchbtn.checked = false
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
			
		)
		else
		(
			listObj.selection = 0
			listObjMd.selection = 0
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
	on pickLocation pressed do
	(
		newGarmentPath = getSavePath()
		if ( newGarmentPath != undefined ) then
		(
			searchtxt.text = ""
			editLocation.text = newGarmentPath			
			FillListboxes newGarmentPath
			creatingLog()
			listObj.selection = 0
			listObjMD.selection = 0
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
			if (searchtxt.text == "") then
			(
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
			
			listObj.enabled = true
			listObjMD.enabled = true
			importBtn.caption = "Import"
			importBtn.enabled = true
			searchtxt.enabled = true
			searchbtn.checked = true
			searchbtn.enabled = true
		)
		else
		(
			listObj.enabled = false
			listObjMD.enabled = false
			listObj.selection = 0
			listObjMd.selection = 0
			importBtn.caption = "Import - Locked"
			importBtn.enabled = false
			searchtxt.enabled = false
			searchbtn.checked = false
			searchbtn.enabled = false

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
							
							--create and import to 4_Product layer
							createImportObjectsInLayer()
						)
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
							
							--create and import to 4_Product layer
							createImportObjectsInLayer() 
						)
				)		
			)	
		)
	)
--========END IMPORTER========--
)
createDialog fStructImporter
