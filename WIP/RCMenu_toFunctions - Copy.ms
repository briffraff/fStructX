(
	try (destroyDialog MyRollout) catch ()
	
	resetMaxFile #noPrompt
	global MyRollout
	global MyObjects = #(cone pos:[-50,50,0], sphere pos:[50,50,0], pyramid pos:[50,-50,0])
		rcmenu MyRCmenu
		(
			menuItem mi_box "Display as Box" checked:false
			menuItem mi_frz "Freeze" checked:false
				on MyRCmenu open do
				(
					local CurNode = MyObjects[(MyRollout.MyLbx.selection)]
					local IsValNode = (IsValidNode CurNode)
					-- Enable items only if node is still valid
					mi_box.enabled = mi_frz.enabled = IsValNode
					-- Set check state of items
						if IsValNode do 
						(
							mi_box.checked = CurNode.boxmode
							mi_frz.checked = CurNode.isFrozen
						)
				)
				
				-- Set up event handlers for items
				on mi_box picked do 
					(
						local CurNode = MyObjects[(MyRollout.MyLbx.selection)]
						CurNode.boxmode = (not CurNode.boxmode)
					)
				on mi_frz picked do 
					(
						local CurNode = MyObjects[(MyRollout.MyLbx.selection)]
						CurNode.isFrozen = (not CurNode.isFrozen)
					)
		)

	rollout MyRollout "MyRollout: (double-click items for RCmenu)" 
		(
			listbox MyLbx items:(for i=1 to MyObjects.count collect MyObjects[i].name)
			on MyLbx doubleClicked val do (popUpMenu MyRCmenu)
		)
	createDialog MyRollout width:300
)