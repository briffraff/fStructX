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
	
	renameNormals()