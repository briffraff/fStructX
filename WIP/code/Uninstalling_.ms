fn getFilesRecursive root pattern =
(	
    my_files = #()
    
    dir_array = GetDirectories (root+"/*")
    for d in dir_array do join dir_array (GetDirectories (d+"/*"))
    for f in dir_array do join my_files (getFiles (f + pattern))
    counter =  my_files.count as string
	my_files = getFiles (root + "\\" + pattern)
    for del in my_files do deletefile del

)

-- deleting files
getFilesRecursive @"$userScripts\BorakaScriptPack_vol1\" "*.mat"
getFilesRecursive @"$userScripts\BorakaScriptPack_vol1\" "*.mtl"
getFilesRecursive @"$userScripts\BorakaScriptPack_vol1\" "*.ms"
getFilesRecursive @"$userScripts\BorakaScriptPack_vol1\" "*.jpg"
getFilesRecursive @"$userScripts\BorakaScriptPack_vol1\" "*.mcr"
getFilesRecursive @"$userScripts\BorakaScriptPack_vol1\" "*.run"
getFilesRecursive @"$userScripts\BorakaScriptPack_vol1\" "*.bmp"

txt = "'BorakaScriptPack_vol1' - uninstalled !"
messagebox txt beep:false

