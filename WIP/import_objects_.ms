--===============================================================================================================================--
-- MD workflow - IMPORTER
-- author: Riff-Raff
--===============================================================================================================================--
	
--========--
-- UI
--========--
try ( destroyDialog fStructImport ) catch () --destroys previous dialog if one is open

widthSize = 288 + 288

rollout fStructImport"folderStructure" width:408 height:428

(
	--	Header
	local img_header = @"$userScripts\BorakaScriptPack_vol1\imgs\fstructox_header.bmp"
	local img_header_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\fstructox_header_mask.bmp"
	button 'header' "" pos:[0,0] width:408 height:37 enabled:false images:#("$userScripts\BorakaScriptPack_vol1\imgs\fstructox_header.bmp", "$userScripts\BorakaScriptPack_vol1\imgs\fstructox_header_mask.bmp", 1, 1, 1, 1, 1) border:false align:#left
	
	-- Obj folder

	listbox 'listObj' "" items:#() pos:[16,64] width:376 height:10 align:#left
	GroupBox 'grp4' "* Obj folder" pos:[8,48] width:392 height:160 align:#left
	-- MD folder

	listbox 'listMd' "" pos:[16,232] width:376 height:10 align:#left
	GroupBox 'grp5' "* MD folder" pos:[8,216] width:392 height:160 align:#left
	
	--	Footer
	local img_footer = @"$userScripts\BorakaScriptPack_vol1\imgs\fstructox_footer.bmp"
	local img_footer_mask = @"$userScripts\BorakaScriptPack_vol1\imgs\fstructox_footer_mask.bmp"
	button 'footer' "" pos:[0,394] width:408 height:30 enabled:false images:#("$userScripts\BorakaScriptPack_vol1\imgs\fstructox_footer.bmp", "$userScripts\BorakaScriptPack_vol1\imgs\fstructox_footer_mask.bmp", 1, 1, 1, 1, 1) toolTip:"MD object importer" border:false align:#left
	
	--============================--
-- FUNCTIONS
--============================--

--======================--
-- MAIN
--======================--

)
createDialog fStructImport