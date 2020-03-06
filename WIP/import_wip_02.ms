--===============================================================================================================================--
-- MD workflow - IMPORTER
-- author: Riff-Raff
--===============================================================================================================================--

try ( destroyDialog fStructImporter) catch () 

	global fStructImporter
	global newGarmentPath = undefined
	
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
								--launch Atangeo Balancer nPro64
								shelllaunch balnsr itemsObjNames[a]
								format "-> BALANCER : %\n" itemsObjNames[a]							
							)
							format "\n"
					)
						
					if (itemMdIdx != 0)do 
					(	
						for a in itemMdIdx do
							(
								--launch Atangeo Balancer nPro64
								shelllaunch balnsr itemsMdNames[a]							
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
	
	--=====
	--RCMenu
	--=====
	rcmenu fStructRightClickMenuBalancer
	(
		menuItem executeBalancer "Execute Balancer" checked:false 
		menuItem uvToPs "UVmap to Photoshop" checked:false
			
		on fStructRightClickMenuBalancer open do
			(
				print "Right click menu : OPEN"
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

rollout fStructImporter "fStructImporter" width:362 height:424
	
(
	local filesObjArr = #()
	local fileObjNamesArr = #()
	local filesMdArr = #()
	local fileMdNamesArr = #()
	local selectedFileIdx = 0
	local txtInput = undefined
	local sel = 0
	
	local importBtnTooltip =  "1. LMB = Import selected object" + "\n" + "2. RMB = Refresh list"
--===============--
-- UIe
--===============--
	button pickLocation "Browse" pos:[25,10] width:64 height:24 align:#left border:true visible:true
	edittext editLocation "" pos:[95,10] width:177 height:24 readOnly:false align:#left visible:false
		
	checkbutton enableImport "Enable import" pos:[10,45] width:125 height:24 align:#left tooltip: "* Enable/Disable the object's lists" 
	checkBox chkBox_showFullPath "Show full path" pos:[265,350]
	
	button importBtn "Locked - Import" pos:[10,350] width:240 height:36 align:#left border:true enabled:false tooltip:importBtnTooltip
	
	GroupBox groupLists "* OBJ / MD folders" pos:[8,76] width:346 height:264 align:#left
	multilistbox listObj "" items:#() selection:#() pos:[20,99] width:320 height:8 align:#left selection:0 enabled:false 
	multilistbox listObjMD "" items:#() selection:#() pos:[20,221] width:320 height:8 align:#left selection:0 enabled:false

	edittext searchtxt "" pos:[180,46] width:130 height:22 align:#left enabled:false
	checkbutton searchbtn "search" pos:[314,46] width:40 height:24 align:#left enabled:false border:false checked: false
	
--==================--
-- FUNCTIONS
--==================--
fn mat = 
(
	--filter the path ;get the last idx; filter na lst idx ; get first idx - example : N**M**
	fltr = filterstring newGarmentPath "\ :"
	fltrLastIdx = fltr[fltr.count]
	fltr2 = filterstring fltrLastIdx "_"
	local garmentMatName = fltr2[1]

	for i = 1 to selection.count do
	(
		--filter and compare 3-th index of selection to its own hanger name
		local impSel = selection[i]
		fltrSel = filterstring impSel.name "_"
		local fltrThirdIdx = fltrSel[3]
		
		newmat = VRayMtl()
		Diff = Falloff()
		Normalmap = VRayNormalMap ()
		CompMap = CompositeTexturemap ()
		
		--material name
		if (fltrThirdIdx == "NH-0" or fltrThirdIdx == "NH-1" or fltrThirdIdx == "NH-2" or fltrThirdIdx == "NH-3") then
		(
			newmat.name = garmentMatName + "_" + fltrThirdIdx
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
		local psd = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_SE00_CA_000000-000_D.psd"
		newmat.texmap_diffuse = Diff
		newmat.texmap_diffuse.name = "DIFF"
		isPsdFileExist = doesFileExist psd 
			if ( isPsdFileExist == true) then 
				(
					newmat.texmap_diffuse.map1 = Bitmaptexture filename:psd 
					newmat.texmap_diffuse.map1.name = "DIFF_map1"
					newmat.texmap_diffuse.map1.coords.realWorldScale = false
					newmat.texmap_diffuse.map1.coords.U_Tiling = 1
					newmat.texmap_diffuse.map1.coords.V_Tiling = 1
					newmat.texmap_diffuse.map1.alphaSource = 2
			
					newmat.texmap_diffuse.map2 = Bitmaptexture filename:psd 
					newmat.texmap_diffuse.map2.name = "DIFF_map2"
					newmat.texmap_diffuse.map2.coords.realWorldScale = false
					newmat.texmap_diffuse.map2.coords.U_Tiling = 1
					newmat.texmap_diffuse.map2.coords.V_Tiling = 1
					newmat.texmap_diffuse.map2.alphaSource = 2
				)
		
		--NORMALS
		newmat.texmap_bump_multiplier = 100
		--vray normal 
		newmat.texmap_bump = Normalmap
		newmat.texmap_bump.name = "NORMALS"
				-- composite
		newmat.texmap_bump.normal_map = CompMap
		newmat.texmap_bump.normal_map.name = "Normal_maps"
			newmat.texmap_bump.normal_map.mapEnabled.count = 3
				newmat.texmap_bump.normal_map.layername[3] = "Fabric"
				newmat.texmap_bump.normal_map.layername[2] = "Seams"
				newmat.texmap_bump.normal_map.layername[1] = "Wrinkles"
			
							--wrinkles
		local normalWrinkles = newGarmentPath + "\\Maps\\" + "Normal_blank.jpg"		
		local normalWrinklesNh0 = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_NH-0_0_N.jpg"
		local normalWrinklesNh1 = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_NH-1_0_N.jpg"
		local normalWrinklesNh2 = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_NH-2_0_N.jpg"
		local normalWrinklesNh3 = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_NH-3_0_N.jpg"
		local isNh0FileExist = doesFileExist normalWrinklesNh0
		local isNh1FileExist = doesFileExist normalWrinklesNh1
		local isNh2FileExist = doesFileExist normalWrinklesNh2
		local isNh3FileExist = doesFileExist normalWrinklesNh3
		--if the file exists and selection name - 3-th index are the same
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
								newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesNh2 gamma:1.0
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
			newmat.texmap_bump.normal_map.maplist[1].name = "Wrinkles"
			newmat.texmap_bump.normal_map.maplist[1].coords.realWorldScale = false
			newmat.texmap_bump.normal_map.maplist[1].coords.U_Tiling = 1
			newmat.texmap_bump.normal_map.maplist[1].coords.V_Tiling = 1
			newmat.texmap_bump.normal_map.maplist[1].alphaSource = 2
			newmat.texmap_bump.normal_map.opacity[1] = 100
			newmat.texmap_bump.normal_map.blendMode[1] = 0
							--Seams
			local normalSeams = newGarmentPath + "\\Maps\\" + "T_" + garmentMatName + "_N.jpg"
			newmat.texmap_bump.normal_map.mapList[2] = Bitmaptexture filename:normalSeams 
			newmat.texmap_bump.normal_map.maplist[2].name = "Seams"
			newmat.texmap_bump.normal_map.maplist[2].coords.realWorldScale = false
			newmat.texmap_bump.normal_map.maplist[2].coords.U_Tiling = 1
			newmat.texmap_bump.normal_map.maplist[2].coords.V_Tiling = 1
			newmat.texmap_bump.normal_map.maplist[2].alphaSource = 2
			newmat.texmap_bump.normal_map.opacity[2] = 30
			newmat.texmap_bump.normal_map.blendMode[2] = 5
							--Fabric
			local normalFabric = newGarmentPath + "\\Maps\\" + "Dri-fit.jpg"
			newmat.texmap_bump.normal_map.mapList[3] = Bitmaptexture filename:normalFabric 
			newmat.texmap_bump.normal_map.maplist[3].name = "Fabric"
			newmat.texmap_bump.normal_map.maplist[3].coords.realWorldScale = false
			newmat.texmap_bump.normal_map.maplist[3].coords.U_Tiling = 1
			newmat.texmap_bump.normal_map.maplist[3].coords.V_Tiling = 1
			newmat.texmap_bump.normal_map.maplist[3].alphaSource = 2
			newmat.texmap_bump.normal_map.opacity[3] = 15
			newmat.texmap_bump.normal_map.blendMode[3] = 5
			
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
							
							--set mat
							mat()
							
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
							
							--set mat
							mat()
							
							--create and import to 4_Product layer
							createImportObjectsInLayer() 
						)
				)		
			)	
		)
	)
--========END IMPORTER========--
)
createDialog fStructImporter --bgcolor:[109,174,46]
