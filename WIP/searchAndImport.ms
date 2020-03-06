try ( destroyDialog fStructImporter) catch () 

rollout fStructImporter "fStructImporter" width:450 height:424
(
	local Arr = #("MA-2", "MAR-1", "WA-1","MB-2","MA-2_Reduced","WA-1_reduced")
	local txt = undefined
	local sel = 0
	
	multilistbox listObj "" items:#() selection:#() pos:[30,150] width:400 height:10 selection:0 align:#left
	edittext searchtxt "" pos:[0,0] width:400 height:1 align:#left 
	button searchbtn "search" pos:[405,0] width:40 height:18 align:#left enabled:true border:false

fn SearchForWordInArray theArray theWord =
(
	pattern = "*" + theWord + "*"
	for j = 1 to theArray.count where matchpattern theArray[j] pattern:pattern collect j
)

-- when enter text in the searchbox
	on searchtxt entered txt do
	(
		if txt != "" then 
		(
			txtInput = searchtxt.text
			ArrIdx = SearchForWordInArray Arr txtInput ignoreCase:true
			local ArrNames = for n in Arr collect n
			local sel = listObj.selection = ArrIdx 
				sel
			
				-- print some info
				format "-----------------------------------------------------------------------\n"
				    print "*** STATISTICS ***"
				format  "--------------------\n" 
				format "TOTAL OBJs COUNT : % \n\n" Arr.count as string
				format "OBJs SELECTED : % \n\n" ArrIdx.count as string
				format "ROW | OBJ NAME \n" 
			 
				for i in ArrIdx do
				(
					format "#%  -  % \n" i ArrNames[i] 
				)
				format "\n"
				-- end print
		)
		else 
		(
			listObj.selection = 0
		)
	)

--when select item
	on listObj selectionEnd do
	(
		selIdx = listObj.selection
		selArrName = for n in selIdx collect format "You select : %  \n" Arr[n]
	)
	
--when open	
	on fStructImporter open do
	(
		listObj.items = sort Arr
		listObj.selection = 0
	)
)
createDialog fStructImporter
