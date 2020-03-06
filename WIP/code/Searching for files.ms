local txt = "*.txt"
local mtl = "*.mtl"
local obj = "*.obj"
local zpac = "*.zpac"
local zprj = "*.zprj"

fn getFilesRecursive root pattern =
(
	my_files = #()
	
	dir_array = GetDirectories (root+"/*")
	for d in dir_array do join dir_array (GetDirectories (d+"/*"))
	for f in dir_array do join my_files (getFiles (f + pattern))
	for del in my_files do deletefile del
	counter =  my_files.count as string
	txt = ".MTL files found : " + counter + "\n" + ".MTL files deleted : " + counter
	messagebox txt
)
deleted = getFilesRecursive @"M:\MD_N\Garments\" "*.mtl"