(
thePath = @"C:\Users\RR\Dropbox\maxscript\0_Root\N05M034_Hot-Sauce\Obj"
theExtension = "\\*.obj"

myfiles = #()
myfilesNames = #()
myfilesDates = #()

myfiles = sort(getFiles (thePath + theExtension))
myfilesNames = sort(for f in myfiles collect (filenameFromPath f))
myfilesDates = sort(for d in myfiles collect (getFilemodDate d)) -- sorting to get the max item as string

theLastDate = amax myfilesDates --the latest date item
indx = findItem myfilesDates theLastDate --index of that newest date
date = theLastDate -- save date in new variable
theLastObjectName = myfilesNames[indx] as string --get the name of item

--revert
myfilesDates = (for d in myfiles collect (getFilemodDate d)) -- without sorting
	
	for i =1 to myfiles.count do
	(
	format "% - % - % \n" i myfilesNames[i] myfilesDates[i]
	)

newIndex = finditem myfilesDates date --new index -- right index
theLastNewObjectName = myfilesNames[newIndex] as string --get the name of item
	
	format "The last date : % \n" theLastDate
	format "The newdate index : %\n" newIndex
	format "The last name : %\n" theLastNewObjectName
)