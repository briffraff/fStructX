(
	try (destroyDialog fStructImporter) catch ()
	
	global fStructImporter
	
	rcmenu fStructRightClickMenu
	(
		menuItem executeBalancer "Execute Balancer" checked:false
			
		on fStructRightClickMenu open do
			(
				--
			)
				
			-- Set up event handlers for items
		on executeBalancer picked do 
			(
				itemsNames = fStructImporter.listObj.items
				itemIdx = fStructImporter.listObj.selection
					for a in itemIdx do
						(
							format "Item: '%' sent to Balancer \n" itemsNames[a]
						)
			)
	)
		

	
	rollout fStructImporter "Right click the objects in list" 
		(
			local filesObjArr = #()
			local fileObjNamesArr = #()
			local ArrNames = for n in fileObjNamesArr collect n

			
			multilistbox listObj items:#()
			
			fn FillListboxes thePath =
				(
					filesObjArr =sort (getFiles (thePath +"\\Obj"+ "\\*.obj" ))
					fileObjNamesArr = sort (for f in filesObjArr collect (filenameFromPath f))
					listObj.items = fileObjNamesArr
				)
				-- for transfer -- 
				on listObj rightClick val do
				(
					popUpMenu fStructRightClickMenu
				)

				on fStructImporter open do 
				(
					local thePath = @"C:\Users\RR\Dropbox\maxscript\0_Root"
					FillListboxes thePath
					filterName = filterstring thePath "\\ : "
					local filterIdx = filterName[filterName.count]
					exportFileLog = thePath + "\\" + filterIdx + "_9Statistics.txt"
					print exportFilelog
					
					--delete log
					df = deleteFile exportfilelog
					
					--Creating logfile
					if (doesFileExist exportFilelog == false )then 
					(
						t = localtime	
						cf = createFile exportfilelog
						format " --- Statistic for ' % ' --- \n\n" filterIdx to:cf
						format "Date : %   \n\n" t to:cf
						format "Garment path : %  \n"thePath to:cf
						format "\n" to:cf				
						for i in listObj.items.count do
						(
						format "% \n" fileObjNamesArr[i] to:cf
						)
						close cf
					
					)				
				)
		)
		
	createDialog fStructImporter width:300
)