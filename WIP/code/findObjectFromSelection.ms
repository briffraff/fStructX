--variables
global objectCollection = selection
global isNumber3Exists = false
global counter = 0
global boxFound = 0

--no objects selected
if (objectCollection.count != 0 ) then
(
	--searching for kutiq number 3 
	for i in objectCollection do
	(	
		if (i.name == "Box003") then
		(
			i.name = "Kutiq003"
		)
		if (i.name == "Kutiq003") then 
		(
			isNumber3Exists = true	
			boxFound += 1
			
			local posToMove = 30
			i.pos.z += posToMove	
		)
			
		counter += 1
	)
		
	if (isNumber3Exists == false and boxFound <= 1) then
	(
		local noFoundBox = "Ne uspqh da namerq kutiq s ime \"Kutiq003\"! "
		messagebox noFoundBox beep:false
	)
	else
	(
		local foundMessage = ("Namerih " + boxFound as string + " kutii !")
		messagebox foundMessage beep:false
	)
)
else
(
	local noSelection = "Nqma selektirani obekti !"
	messagebox noSelection beep:false
)



