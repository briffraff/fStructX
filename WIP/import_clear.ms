--===============================================================================================================================--
-- MD workflow - IMPORTER
-- author: Riff-Raff
--===============================================================================================================================--

try ( destroyDialog fStructImporter) catch () 

rollout fStructImporter "fStructImporter" width:450 height:424
	
(
global files
global dirs
global searchFiles
global missingMapfiles
global allMats
global compareNames
global currSel
global mapfiles
global mapDirs
global foundedmaps
global foundedfilenames
global mapfile
global addmap
global searchMissingMaps
global findDirs
--===============--
-- UI
--================-
	
	button 'pickLocation' "Pick" pos:[25,71] width:64 height:24 align:#left border:true 
	edittext 'gDir' "" pos:[95,71] width:177 height:24 readOnly:false align:#left
		
	checkbutton 'enableImport' "Enable import" pos:[31,111] width:137 height:26 align:#left tooltip: "* Enable/Disable the object's lists" 
	local importBtnTooltip =  "1. LMB = Import selected object" + "\n" + "2. RMB = Refresh list"
	button 'importBtn' "Locked - Import" pos:[10,289] width:240 height:40 align:#left border:true  tooltip:importBtnTooltip
	
	listbox 'findbox' "" items:#() pos:[30,150] width:400 height:10 align:#left selection:0 

--==================--
-- MAIN
--==================--




-- pick location 
	on pickLocation pressed do
	(
		NewGarmentPath = getSavePath()
		if ( NewGarmentPath != undefined ) then
				(
					gDir.text = NewGarmentPath
					
						dirs = #()
						files = #()
						append dirs (gDir.text + "\\")
		               -- findDirs gDir.text dirs
					findbox.items.count = 0
					
						for d in dirs do
						(
							if  gDir.text != "" then files += (getFiles (d + "*.obj"))
						)
						for f in files do
						(
							findbox.items = for f in files collect (getFilenameFile f +getFilenameType f)as string
						)
						
				)
	)
	
	
-- import selected object
	on importBtn pressed do
	(
			importFile findbox.items #noprompt
				
		)
	)

createDialog fStructImporter
