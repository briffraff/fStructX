rollout testRollz "Loading..." width:260 height:100 (
  	label lbl_infoA 		"Reading Files..."	pos:[11,20]
  	label lbl_infoB 		"Press ESC to cancel"	pos:[150,20]
  	progressbar mahprogbar color:green
  	button btn_Start 		"start loop" 		pos:[50,60] width:155 height:30
  	
  	on btn_Start pressed do (
  		maxSize = 10000000
  		for tmp=0 to maxSize do (
  			tmp += 1
  			if mahprogbar.value != (floor((tmp*100)/maxsize)) do (
  				mahprogbar.value = floor((tmp*100)/maxsize)
  				windows.processPostedMessages() --So Windows doesn't assume Max is 'Not Responding'
  			)
  			if keyboard.escPressed do (destroyDialog testRollz ; return "canceled")
  		)
  		--destroyDialog testRollz
  	)
  )
  createdialog testRollz