matPath = @"C:\Users\RR\Dropbox\maxscript\12_MaxAssets\"
matName = "fstruct_materials.mat"
library = matpath + matname
tmp = loadTempMaterialLibrary library
materials = #()
for i=1 to tmp.count do append materials tmp[i]
for i=1 to materials.count do (setMeditMaterial i materials[i])


--macros.run "Medit Tools" "clear_medit_slots"



