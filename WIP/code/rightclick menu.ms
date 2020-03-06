
rollout roTest "test"
(

local rcTest

-- declare the RC Menu to be used later...
-- NOTE: a function is used to create a LOCAL rc menu (otherwise you get an error
--	that a rollout clause is expected,) you could, however, just define the 
--	RC Menu outside the rollout scope, in which case you don't need the function.
fn createMenu = 
(
rcMenu rcTest
(
menuItem miItem1 "Item 1"
menuItem miItem2 "Item 2"
seperator menuSep01
menuItem miItem3 "Item 3"

on miItem1 picked do (print "item 1 picked...")
on miItem2 picked do (print "item 2 picked...")
on miItem3 picked do (print "item 3 picked...")
) -- end of rcTest rcmenu
)


-- now declare the rollout controlers
button bnMenu "Click here for the menu..." width:150

on bnMenu rightclick do (
-- use the popUpMenu command to display the RC Menu we defined earlier...
popUpMenu rcTest pos:(bnMenu.pos + [145,0]) rollout:roTest align:#align_topleft
)

-- on rollout open we call the createMenu fn to define the local RCMenu
on roTest open do createMenu() 

)-- end of roTest rollout

createDialog roTest
