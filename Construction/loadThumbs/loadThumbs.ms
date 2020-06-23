try ( destroyDialog loadFrontAndBack) catch ()

rollout loadFrontAndBack "Front/Back views" width:250 height:490
(
	local geometryNumber = ""
	local frontsideA = ""
	local backsideB = ""
	local thePath = fStruct.editLocation.text
	local thumbsPath = @"M:\MD_N\Thumbs"
	local emptyBox = openbitmap @"$userScripts\BorakaScriptPack_vol1\imgs\emptyBox.jpg"

	imgtag frontSide "Front" pos:[10,10] width:230 height:230 bitmap:emptyBox  
	imgtag backSide "Back" pos:[10,250] width:230 height:230 bitmap:emptyBox
	
	fn getTheGeometryNumber = 
	(
		if (fstruct.editLocation.text != "" ) then
		(
			fltr1 = filterstring thePath ":\\" --filter the path 
			fltr2 = filterstring fltr1[fltr1.count] "_" --getthe number
			geometryNumber = fltr2[1]  --N**M*** --set number to variable 
			frontsideA = geometryNumber + "-A" --number + A equals to frontside map
			backsideB = geometryNumber + "-B" -- number + B equals to backside map
		)
	)
	
	fn loadTheThumbs theExtension = 
	(
		--FRONTSIDE
		--assembly the name ; check if the file exist ; change the map 
		frontThumb = thumbsPath + "\\" + frontsideA + theExtension
		isFrontExist = doesFileExist frontThumb
		if (isFrontExist == true ) then
		(
			frontSide.bitmap = openbitmap frontThumb
		)
		else
		(
			frontSide.bitmap = emptyBox
		)
		--BACKSIDE
		--assembly the name ; check if the file exist ; change the map 
		backThumb = thumbsPath + "\\" + backsideB + theExtension
		isBackExist = doesFileExist backThumb
		if (isBackExist == true ) then
		(
			backSide.bitmap = openbitmap backThumb
		)
		else
		(
			backSide.bitmap = emptyBox
		)
--DEBUG
-- 		print frontThumb
-- 		print backThumb
	)
	
	fn compAlpha c1 p1 c2 p2 =
	(
		color c1.a c1.a c1.a
	)

--ZOOM the thumbs x2
-- FS
	on frontSide click do 
	(
		if(loadFrontAndBack.width < 750) then
		(
			frontSide.pos = [10,10]
			frontSide.width = frontSide.width*2.09
			frontSide.height = frontSide.height*2.045
			loadFrontAndBack.width = loadFrontAndBack.width*2
			backSide.visible = false
			
			if(loadFrontAndBack.width > 500)then
			(
				loadFrontAndBack.height = loadFrontAndBack.height*2
			)
		)
	)
	
	on frontSide mouseout do
	(
		frontSide.pos = [10,10]
		frontSide.width = 230
		frontSide.height = 230
		loadFrontAndBack.width = 250
		loadFrontAndBack.height = 490
		backSide.visible = true
	)
	
--BS
	on backSide click do 
	(
		if(loadFrontAndBack.width < 750) then
		(
			backSide.pos = [10,10]
			backSide.width = backSide.width*2.09
			backSide.height = backSide.height*2.045
			loadFrontAndBack.width = loadFrontAndBack.width*2
			frontSide.visible = false
			
			if(loadFrontAndBack.width > 500)then
			(
				loadFrontAndBack.height = loadFrontAndBack.height*2
			)
		)
	)
	
	on backSide mouseout do 
	(
		backSide.pos = [10,250]
		backSide.width = 230
		backSide.height = 230
		loadFrontAndBack.width =250
		loadFrontAndBack.height = 490
		frontSide.visible = true
	)
	
	on loadFrontAndBack open do
	(
		getTheGeometryNumber()
		loadTheThumbs ".png"
-- 		local imgAlpha = bitmap backSide.bitmap.width backSide.bitmap.height
-- 		pasteBitmap backSide.bitmap imgAlpha [0,0] [0,0] type:#function function:compAlpha
-- 		display imgAlpha 
	)
) 

bgColDarkGrey = [52,52,52]
createDialog loadFrontAndBack bgcolor:bgColDarkGrey pos:[(getDialogpos fStruct)[1]+fStruct.width + 373,(getDialogPos fStruct)[2]+fStruct.height + (-393)] parent:fStruct.hwnd style:#()
