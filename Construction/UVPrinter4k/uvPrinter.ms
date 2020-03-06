-----------------------------------------------------
-- Osnovnata programa - 'UV Printer 4k'
-- Programata otpechatva UVW map na selektiran obekt
-- Chete imeto na max file i putqt kum nego i otpechatva purviqt filtriran index + UV ,kato ime na jpg-to
-- Jpg file-ut se zapisva v papka \\Maps 
-- avtor : Borislav Borisov - 'riff-raff'
-----------------------------------------------------
-- Functions
	-- maps folder creation
	fn createFolder =
	(
		 mapsfolder = maxFilePath + "\\Maps\\"
		 isFolderExist = doesFileExist mapsfolder 
		if	( isFolderExist == false ) then
				makeDir mapsfolder all:false
	)
(

--selektirane na obekt
selectedObject = selection[1]

--proverka za broi selektirani obekti
if (selection.count == 0) then
	(
		noSelection = "0 objects selected !"
		messageBox  noSelection title:"ERROR!!!" beep:true
	)
	else
	(
		if (selection.count == 1 and  classof selection[1].baseobject == Editable_Poly or selection.count == 1 and classof selection[1].baseobject == Editable_Mesh) then
		(
			-- Maps folder will be created if folder doesn't exist 
			createFolder()
			
		  max modify mode

		  --dobavqne na unwrap modifikator
		  unwrapMod = Unwrap_UVW()
		  addModifier selectedObject unwrapMod

		  --nastroiki
		  unwrapMod.renderuv_width = 4096
		  unwrapMod.renderuv_height = 4096
		  unwrapMod.renderuv_seamColor = color 255 255 255
		  unwrapMod.renderuv_visibleedges = false
		  unwrapMod.renderuv_showframebuffer = off
		  JPEG.setQuality(100)
		  JPEG.setSmoothing(100)

		  --zadavane na mqstoto za save na Uv-to i format na imeto
		  --uvSavePath =  maxfilepath + "\\maps\\ "+ selectedObject.name +"_UV.jpg"
		  pathHere = maxFilePath

		  -- premahvame razshirenieto .max
		  fileHere = maxFileName
		  filename = getFilenameFile fileHere

		  -- filter na string-a i vzimane na purviq element
		  elements = filterString filename "_"
		  format "elements: % \n" filename
		  maxNameFirstItem = elements[1]
		  format "maxNameFirstItem: % \n" maxNameFirstItem
		  uvSavePath =  pathHere + "\\Maps\\" + maxNameFirstItem + "_UV.jpg"
		  uvRenderPath = uvSavePath

		  --render UV
		  unwrapMod.renderUV uvRenderPath

		  -- delete unwrap modifier
		  deleteModifier selectedObject 1

		  max create mode

		  --izvejdane na suobshtenie ,za krai na procesa
		  correctCountSelection = toUpper "* Done!"
		  messageBox  correctCountSelection title: "Successful progress" beep:false

		)
		-- izvejdane na suobshtenie za greshen broi slektirani geometrii
		else
		(
			if (selection.count >= 2 and  classof selection[1].baseobject == Editable_Poly or selection.count >= 2 and  classof selection[1].baseobject == Editable_Mesh)then
			(
				wrongCountSelection = toUpper "* You must select 1  object!"
				messageBox  wrongCountSelection title: "WARNING" beep:true
			)
			else
			(
				splineDetection = "* SPLINE detected ! Please select different objects!"
				messageBox splineDetection title: "WARNING" beep:true
			)
		)
	)
)
