
rollout test "Test Timer" width:162 height:48
(
	Timer clock "seconds" pos:[70,4] width:24 height:24 interval:1000 active:false  --tick once a second 
	button btnStartStop "play" pos:[5,5] width:70 height:18  enabled:true  border:true 
	colorPicker timerColour "" pos:[5,23] width:70 height:6 enabled:false border:false color:[255,0,0]
	label counterSec "00" pos:[140,7] tooltip:"seconds"
	label separator1 ":" pos:[132,7] tooltip:""
	label counterMin "00" pos:[115,7] tooltip:"minutes"
	label separator2 ":" pos:[107,7] tooltip:""
	label counterHours "00" pos:[90,7] tooltip:"hours"
 		
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

createDialog test