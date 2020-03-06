(
   	local fullPath = undefined
   	dir = @"C:\Users\RR\Dropbox\maxscript" --//Main Scripts directory
   	dirArray = GetDirectories (dir+"/*") --//Get subfolders in directory
   	foldersArray = for d in dirArray collect (trimright (filenameFromPath d) "\\") --//Array which stores just the names of the subfolders
 
   	form = dotnetobject "MaxCustomControls.Maxform"
   	form.Text = "Dynamic ContextMenu"
   	cm = dotNetObject "ContextMenu"
   	form.ContextMenu = cm
 
   	for i in foldersArray do
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
 
   			sFiles = #()
   			sFiles = getFiles (dirArray[b] + "*.ms*")
 
  			fn fnRunScript s e = --Run the selected script 
  			(
  				--fileIn s.name
				fileIn (s.tag)
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
   				item = i.menuitems.add "No Scripts"
   				item.enabled = off
   			)
   		)		
   	)
   	dotnet.addEventHandler cm "Popup" onPopup
   	form.showmodeless()
)