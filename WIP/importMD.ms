
try ( destroyDialog fStruct) catch () --destroys previous dialog if one is open

rollout fStruct "folderStructure" width:100 height:150
(
	button importFrom "ImportFrom" pos:[0,0] width:100 height: 30 tooltip:"Import the obj"

	fn importTree = 
	(
	global fullPath = undefined
   	global dir = ForObjects --//Main Scripts directory
		
   	global dirArray = GetDirectories (dir + "/obj") --//Get subfolders in directory
	global dirArrayMd = GetDirectories (dir +"/obj/md") --//Get subfolders in directory

   	global foldersArray = for d in dirArray  collect (trimright (filenameFromPath d) "\\") --//Array which stores just the names of the subfolders
    global foldersArrayMd = for d in dirArrayMd  collect (trimright (filenameFromPath d) "\\") --//Array which stores just the names of the subfolders

   	form = dotnetobject "MaxCustomControls.Maxform" 
	form.size = dotNetObject "System.Drawing.Size" 288 100 editable:false
   	form.Text = "Dynamic ContextMenu" 
   	cm = dotNetObject "ContextMenu"  
   	form.ContextMenu = cm
 
   	for i in foldersArray do
   	(
   		item = cm.menuitems.add i
   		item.name = i
   	)
		for i in foldersArrayMd do
   	(
   		item = cm.menuitems.add i
   		item.name = i
   	)
 
   	fn onPopup s e = 
   	(
   		for b = 1 to foldersArray.count do
   		(
   			i = (s.menuitems.Find (foldersArray[b] as string) off)[1]
   			i.menuitems.clear()
 
   			global sFiles = #()
   			global sFiles = getFiles (dirArray[b] + "*.obj*")
 
  			fn fnRunScript s e = --Run the selected script 
  			(
  				--fileIn s.name
				importFile (s.tag) #noPrompt
  			) 
  			if sFiles.count > 0 then --//Add the scripts to appropriate list
  			(
  				for n in sFiles do
  				(
  					scriptName = getFIleNameFile n
  					item = i.menuitems.add scriptName
  					item.name = scriptName
					item.tag = n -- variable "n" contains the fullpath extention
 
  					dotnet.addEventHandler item "Click" fnRunScript
  				)
  			)
   			else
   			(
   				item = i.menuitems.add "No Obj"
   				item.enabled = off
   			)
   		)	
		
		for b = 1 to foldersArrayMd.count do
   		(
   			i = (s.menuitems.Find (foldersArrayMd[b] as string) off)[1]
   			i.menuitems.clear()
 
   			sFiles = #()
   			sFiles = getFiles (dirArrayMd[b] + "*.obj*")
 
  			fn fnRunScript s e = --Run the selected script 
  			(
				importFile (s.tag) #noPrompt
  			) 
  			if sFiles.count > 0 then --//Add the scripts to appropriate list
  			(
  				for n in sFiles do
  				(
  					scriptName = getFIleNameFile n
  					item = i.menuitems.add scriptName
  					item.name = scriptName
					item.tag = n -- variable "n" contains the fullpath extention
 
  					dotnet.addEventHandler item "Click" fnRunScript
  				)
  			)
   			else
   			(
   				item = i.menuitems.add "No Obj"
   				item.enabled = off
   			)
   		)		
   	)
   	dotnet.addEventHandler cm "Popup" onPopup
   	form.showmodeless()

)
	on importFrom pressed do
	(
	global ForObjects = getSavePath()
		if ( ForObjects != undefined ) then
				(
					importTree()
				)
				
	)	
)
createDialog fStruct