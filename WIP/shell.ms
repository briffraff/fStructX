try (destroyDialog fStructShellTimer ) catch ()

rollout fStructShellTimer "Set the 'Shell' " width:362 height:65 
(
	
-- Shell -----------------------------------------------------------------------------------------------------------------------------------------------------
		label innerLbl "Inner Amount :" pos:[10,10] width:75 height:24 readOnly:false 
		spinner innerValue "" range:[0.1,10,0.15] type:#worldunits pos:[85,9] fieldwidth:60 height:18 readOnly:false enabled:true tooltip:"The InnerAmount value of Shell"
		button createShell "create Shell" pos:[10,34] width:148 height:20 border:true	 visible:true	
		button nextStep "Continue" pos:[10,34] width:148 height:20 border:true visible:false		
		button nextStep2 "Continue.." pos:[10,34] width:148 height:20 border:true visible:false		
		button orderUv "Finalizing" pos:[10,34] width:148 height:20 border:true visible:false			
	  --  button fStructbg "" pos:[0,0] width:181 height:65  enabled:true  border:true 
	

		local theShell = Shell()
		local theUnwrap = Unwrap_UVW()
		local thePoly = Edit_poly()
		local selObj = undefined
	
		--FUNCTIONS 
		fn createShellfunction = 
		(
			if (selection.count == 0) then
			(
				messagebox "No object selected ! Please select object and try again!"
			)
			else
			(
				selObj = selection[1]
				select selObj
				convertToPoly selObj
				max modify mode
				modpanel.addmodtoselection theShell
				theShell.innerAmount = innerValue.value 
				theShell.outerAmount = 0.0
				theShell.overrideInnerMatID  = true
				theShell.matInnerID  = 1
				theShell.overrideOuterMatID = true
				theShell.matOuterID  = 2
				theShell.overrideMatID = true
				theShell.MatId = 3
				theShell.autosmooth = true
				theShell.autoSmoothAngle = 45
				theShell.selectInnerFaces = true
				convertToPoly selObj
				max modify mode
				subobjectlevel = 4 
				modpanel.addmodtoselection theUnwrap
				--theUnwrap.edit()
				subobjectlevel = 3
				max select all
				theUnwrap.breakSelected()
				pointA = theUnwrap.getSelCenter() 
				theUnwrap.moveSelected [1,0,0]
				convertToPoly selObj
				max modify mode
				subobjectlevel = 4
				$.selectByMaterial 3
				modpanel.addmodtoselection theUnwrap
				subobjectlevel = 3
				max select all
				theUnwrap.breakSelected()
				pointB = theUnwrap.getSelCenter() 
				theUnwrap.moveSelected [2,0,0]
				convertToPoly selObj
				modpanel.addmodtoselection theUnwrap
				subobjectlevel = 3
				theUnwrap.unwrap2.setGeomSelectElementMode false
				theUnwrap.unwrap2.setTVSubObjectMode(3)
				theUnwrap.setIgnoreBackFaceCull false					
				theUnwrap.edit()
				theUnwrap.unwrap.fit()
				$.selectByMaterial 1
				createShell.visible = false
				nextStep.visible = true
				messagebox "Deselect the parts you want to keep and press 'Continue' !" beep:false
			)
		)

		fn ContinueTo = 
		(
			nextStep.visible = false
			modpanel.addmodtoselection thePoly
			subobjectlevel = 4
			nextStep2.visible = true
			messagebox "Just delete the selected polygons ,then press 'Continue..' again!" beep:false
		)

		fn OrderTheUv =
		(
			nextStep2.visible = false
			convertToPoly selObj
			max modify mode
			modpanel.addmodtoselection theUnwrap
			subobjectlevel = 3
			theUnwrap.selectByMatID 3
			theUnwrap.freeze()
			theUnwrap.selectByMatID 2
			theUnwrap.freeze()
			theUnwrap.unwrap2.setGeomSelectElementMode false
			theUnwrap.unwrap2.setTVElementMode true
			theUnwrap.edit()
			orderUv.visible = true
			messagebox "Put the inner parts in the Uv and press 'Finalizing' " beep:false
		)

		fn FinalizingUvShell =
		(
			orderUv.visible = false
			theUnwrap.unwrap2.setTVElementMode false
			convertToPoly selObj
			max create mode
			clearSelection()
			messagebox "DONE !"
			createShell.visible = true
		)
		
		--MAIN
			on createShell pressed do
			(
				createShellfunction()
			)
			
			on nextStep pressed do
			(
				Continueto()
			)
			
			on nextStep2 pressed do 
			(
				OrderTheUv()
			)
			
			on orderUv pressed do
			(
				FinalizingUvShell()
			)

--Timer-------------------------------------------------------------------------------------------------------------------------------------------------
		Timer clock "seconds" pos:[70,4] width:24 height:24 interval:1000 active:false  --tick once a second 
		button btnStartStop "play" pos:[205,5] width:70 height:18  enabled:true  border:true bgcolor:red
		colorPicker timerColour "" pos:[201,23] width:74 height:6 enabled:false border:false color:[255,0,0]
		label counterSec "00" pos:[340,7] tooltip:"seconds"
		label separator1 ":" pos:[332,7] tooltip:""
		label counterMin "00" pos:[315,7] tooltip:"minutes"
		label separator2 ":" pos:[307,7] tooltip:""
		label counterHours "00" pos:[290,7] tooltip:"hours"
			
		local sec = 0
		local min = 0
		local hours = 0
	
	on clock tick do
	(
		--change minutes
		if (clock.ticks == (sec+60)) then 
		(
			sec += 60	
			min += 1
			
			if(min < 10 ) then
			(
				format "Total time : 0%h : 0%m : 0%s\n" hours min (sec-sec)
			)
			else
			(
				format "Total time : 0%h : %m : 0%s\n" hours min (sec-sec)
			)
			
			counterMin.text =((counterMin.text as integer) + 1)as string 
			counterSec.text = "00"
		)
		--change hours
		if (clock.ticks == (hours+1)*3600) then
		(		
			hours += 1
				
			if(hours < 10 ) then
			(
				format "Total time : 0%h : 0%m : 0%s\n" hours min (sec-sec)
			)
			else
			(
				format "Total time : %h : 0%m : 0%s\n" hours min (sec-sec)
			)
				
			counterHours.text =((counterHours.text as integer) + 1)as string
			counterMin.text = "00"
			
		)
				
		--change seconds
		counterSec.text =((counterSec.text as integer) + 1) as string
	)
	
	on btnStartStop rightclick do
	(	
		counterSec.text = "00"
		counterMin.text = "00"
		counterHours.text = "00"
		clock.ticks = 0
	)
	
	on btnStartStop pressed do
	(
		if (clock.active == false) then
		(
			clock.active = true
			timerColour.color = [0,186,255]
			btnStartStop.text = "pause"
		)
		else
		(
			clock.active = false
			timerColour.color = [255,0,0]
			btnStartStop.text = "play"
		)
	)
)
createDialog fStructShellTimer --bgcolor:[200,1,5]









