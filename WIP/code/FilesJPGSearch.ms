globalCounter = 0

fn getFilesRecursive root pattern =
(
	my_files = #()
	
	dir_array = GetDirectories (root+"/*")
	for d in dir_array do join dir_array (GetDirectories (d+"/*"))
	for f in dir_array do join my_files (getFiles (f + pattern))
	--for del in my_files do deletefile del
	counter =  my_files.count
	globalCounter += counter
)

fn getFilesRecursiveYA root pattern =
(
	my_files = #()
	
	dir_array = GetDirectories (root+"/*")
	for d in dir_array do join dir_array (GetDirectories (d+"/*"))
	for f in dir_array do join my_files (getFiles (f + pattern))
	--for del in my_files do deletefile del
	counter =  my_files.count
	globalCounter += counter
)

fn getFilesRecursivePS root pattern =
(
	my_files = #()
	
	dir_array = GetDirectories (root+"/*")
	for d in dir_array do join dir_array (GetDirectories (d+"/*"))
	for f in dir_array do join my_files (getFiles (f + pattern))
	--for del in my_files do deletefile del
	counter =  my_files.count
	globalCounter += counter
)

fn msgResults counter =
(
	txt = "files found : " + globalCounter as string + "\n"
	messagebox txt	
)


pattern = "T_N??????_SP20_??_??????-???_D.jpg"

clearlistener()

getFilesRecursive @"M:\MD_N\Garments" pattern
print my_files

getFilesRecursiveYA @"M:\MD_N\Garments YA" pattern
print my_files

getFilesRecursivePS @"M:\MD_N\Garments PS" pattern
print my_files

msgResults globalCounter
print globalCounter


