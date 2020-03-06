(
getThePath = @"C:\Users\RR\Dropbox\maxscript\0_Root\N05M034_Hot-Sauce"
	
--filter the path ;get the last idx; filter na lst idx ; get first idx - example : N**M**
fltr = filterstring getThePath "\ :"
fltrLastIdx = fltr[fltr.count]
fltr2 = filterstring fltrLastIdx "_"
local garmentMatName = fltr2[1]

for i = 1 to selection.count do
	(
		--filter and compare 3-th index of selection to its own hanger name
		local impSel = selection[i]
		fltrSel = filterstring impSel.name "_"
		local fltrThirdIdx = fltrSel[3]
		
		newmat = VRayMtl()
		Diff = Falloff()
		Normalmap = VRayNormalMap ()
		CompMap = CompositeTexturemap ()
		
		--material name
		if (fltrThirdIdx == "NH-0" or fltrThirdIdx == "NH-1" or fltrThirdIdx == "NH-2" or fltrThirdIdx == "NH-3") then
		(
			newmat.name = garmentMatName + "_" + fltrThirdIdx
		)
		else if (fltrSel[1] == "SM" and impSel.name.count >= 17)then 
		(
			newmat.name = garmentMatName + "_"
		)
		else
		(
			newmat.name = "Wrong_mesh_name_material"
		)
		
		-- DIFFUSE
					-- falloff
		local psd = getThePath + "\\Maps\\" + "T_" + garmentMatName + "_SE00_CA_000000-000_D.psd"
		newmat.texmap_diffuse = Diff
		newmat.texmap_diffuse.name = "DIFF"
		isPsdFileExist = doesFileExist psd 
			if ( isPsdFileExist == true) then 
				(
					newmat.texmap_diffuse.map1 = Bitmaptexture filename:psd 
					newmat.texmap_diffuse.map1.name = "DIFF_map1"
					newmat.texmap_diffuse.map1.coords.realWorldScale = false
					newmat.texmap_diffuse.map1.coords.U_Tiling = 1
					newmat.texmap_diffuse.map1.coords.V_Tiling = 1
					newmat.texmap_diffuse.map1.alphaSource = 2					
			
					newmat.texmap_diffuse.map2 = Bitmaptexture filename:psd 
					newmat.texmap_diffuse.map2.name = "DIFF_map2"
					newmat.texmap_diffuse.map2.coords.realWorldScale = false
					newmat.texmap_diffuse.map2.coords.U_Tiling = 1
					newmat.texmap_diffuse.map2.coords.V_Tiling = 1
					newmat.texmap_diffuse.map2.alphaSource = 2
				)
		
		--NORMALS
		newmat.texmap_bump_multiplier = 100
		--vray normal 
		newmat.texmap_bump = Normalmap
		newmat.texmap_bump.name = "NORMALS"
				-- composite
		newmat.texmap_bump.normal_map = CompMap
		newmat.texmap_bump.normal_map.name = "Normal_maps"
			newmat.texmap_bump.normal_map.mapEnabled.count = 3
				newmat.texmap_bump.normal_map.layername[3] = "Fabric"
				newmat.texmap_bump.normal_map.layername[2] = "Seams"
				newmat.texmap_bump.normal_map.layername[1] = "Wrinkles"
			
							--wrinkles
		local normalWrinkles = getThePath + "\\Maps\\" + "Normal_blank.jpg"		
		local normalWrinklesNh0 = getThePath + "\\Maps\\" + "T_" + garmentMatName + "_NH-0_0_N.jpg"
		local normalWrinklesNh1 = getThePath + "\\Maps\\" + "T_" + garmentMatName + "_NH-1_0_N.jpg"
		local normalWrinklesNh2 = getThePath + "\\Maps\\" + "T_" + garmentMatName + "_NH-2_0_N.jpg"
		local normalWrinklesNh3 = getThePath + "\\Maps\\" + "T_" + garmentMatName + "_NH-3_0_N.jpg"
		local isNh0FileExist = doesFileExist normalWrinklesNh0
		local isNh1FileExist = doesFileExist normalWrinklesNh1
		local isNh2FileExist = doesFileExist normalWrinklesNh2
		local isNh3FileExist = doesFileExist normalWrinklesNh3
		--if the file exists and selection name - 3-th index are the same
		if ( isNh0FileExist == true and fltrThirdIdx == "NH-0") then 
			(
				newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesNh0 
			)
		else
			(
				if ( isNh1FileExist == true and fltrThirdIdx == "NH-1")then
					(
						newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesNh1 
					)
				else
					(
						if ( isNh2FileExist == true and fltrThirdIdx == "NH-2")then
							(
								newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesNh2 gamma:1.0
							)
						else
							(
								if ( isNh3FileExist == true and fltrThirdIdx == "NH-3")then
									(
										newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinklesNh3
									)
								else
									(
										newmat.texmap_bump.normal_map.mapList[1] = Bitmaptexture filename:normalWrinkles 
									)
								
							)
					)
			)
			newmat.texmap_bump.normal_map.maplist[1].name = "Wrinkles"
			newmat.texmap_bump.normal_map.maplist[1].coords.realWorldScale = false
			newmat.texmap_bump.normal_map.maplist[1].coords.U_Tiling = 1
			newmat.texmap_bump.normal_map.maplist[1].coords.V_Tiling = 1
			newmat.texmap_bump.normal_map.maplist[1].alphaSource = 2
			newmat.texmap_bump.normal_map.opacity[1] = 100
			newmat.texmap_bump.normal_map.blendMode[1] = 0
							--Seams
			local normalSeams = getThePath + "\\Maps\\" + "T_" + garmentMatName + "_N.jpg"
			newmat.texmap_bump.normal_map.mapList[2] = Bitmaptexture filename:normalSeams 
			newmat.texmap_bump.normal_map.maplist[2].name = "Seams"
			newmat.texmap_bump.normal_map.maplist[2].coords.realWorldScale = false
			newmat.texmap_bump.normal_map.maplist[2].coords.U_Tiling = 1
			newmat.texmap_bump.normal_map.maplist[2].coords.V_Tiling = 1
			newmat.texmap_bump.normal_map.maplist[2].alphaSource = 2
			newmat.texmap_bump.normal_map.opacity[2] = 30
			newmat.texmap_bump.normal_map.blendMode[2] = 5
							--Fabric
			local normalFabric = getThePath + "\\Maps\\" + "Dri-fit.jpg"
			newmat.texmap_bump.normal_map.mapList[3] = Bitmaptexture filename:normalFabric 
			newmat.texmap_bump.normal_map.maplist[3].name = "Fabric"
			newmat.texmap_bump.normal_map.maplist[3].coords.realWorldScale = false
			newmat.texmap_bump.normal_map.maplist[3].coords.U_Tiling = 1
			newmat.texmap_bump.normal_map.maplist[3].coords.V_Tiling = 1
			newmat.texmap_bump.normal_map.maplist[3].alphaSource = 2
			newmat.texmap_bump.normal_map.opacity[3] = 15
			newmat.texmap_bump.normal_map.blendMode[3] = 5
			
		--OPACITY
		local opacPath = getThePath + "\\Maps\\" + "T_" + garmentMatName + "_O.jpg"
		isOpacFileExist = doesFileExist opacPath
		if ( isOpacFileExist == true) then 
			(
				Opac = opacPath
				newmat.texmap_opacity = Bitmaptexture filename: Opac 
				newmat.texmap_opacity.name = "OPAC"
				newmat.texmap_opacity.coords.realWorldScale = false
				newmat.texmap_opacity.coords.U_Tiling = 1
				newmat.texmap_opacity.coords.V_Tiling = 1
				newmat.texmap_opacity.alphaSource = 2
			)
		selection[i].material = newmat
		for mat in (getClassInstances vrayMtl processAllAnimatables:true) do showTextureMap mat on
	)
)