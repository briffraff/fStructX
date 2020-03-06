thePath = @"C:\Users\borko\Dropbox\maxscript\0_Root\N05M034_Hot-Sauce\"

	filesObjArr = #()
	fileObjNamesArr = #()
			
	filesObjArr =sort(getFiles (thePath +"\\Obj"+  "\\*.obj"))
	fileObjNamesArr = sort(for f in filesObjArr collect (filenameFromPath f))


theLastObj = amax filesObjArr --the latest date item
indx = findItem filesObjArr theLastObj --index of that newest date
date = getFileCreateDate  filesObjArr[indx] -- get the date of creation
theLastObjectName = fileObjNamesArr[indx] as string --get the name of item
	--size
getFileSize theLastObj/1000000 -- mb(decimal)
getFileSize theLastObj*0.00000095367432 -- mb(binary)
	--some attributes
getFileAttribute theLastObj #hidden
setFileAttribute theLastObj #hidden false

for last in filesObjArr collect(getFilecreateDate last)


