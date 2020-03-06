-- script Name 			: santa Mirror Morph
-- Ver				: 1.0
-- Concept & Written By		: Susanta Dutta
-- contact			: susanta3d@gmail.com
-- ------------------------------------------------------------------------------------
-- Usage:
-- Help you to create mirror morph target like left sneer to right sneer.
-- After using mirror tool you cannot use the morph target as mirror morph. You can use 
-- this tool to mirror the morph targets ( basically for creating left eye brow up right eyebrow up etc.)
-- Copy the target what you want to mirror.
-- pick the new target copy from santa Mirror morph Floater
-- pick the head object
-- click the mirror button to create mirror morph

-- limitation:
-- only for polygon morpher modeling
-- before do the process delete all modifiers from Target( Turbo smooth, Mesh Smooth etc.)
-- maintain the work Flow for asymmetrical structure ( see the attached help Pdf)
-- Please report bugs and additional requirements, if any, to susanta3d@gmail.com , subject:santa Mirror Morph.


-- Use At Your Own Risk

------------------------------------------------------------------------------------------

MacroScript santaMirrorMorph
ButtonText:"Santa Mirror Morph"
Category:"Susanta" 
Tooltip:"Santa Mirror Morph"

(
rollout rollMirror "Mirror Morph" 
(
	
	
	pickbutton pickMorph "PickTarget" pos:[27,42] width:125 height:21
	pickbutton pickHead "Pick Head" pos:[27,9] width:125 height:22
	button butMirror "Create Mirror" pos:[46,72] width:88 height:32
	
	local mirObj
	local mainObj
	local mainText = pickHead.text
	local mirText = pickMorph.text
	
	
	on pickMorph picked val do
	(
	
			pickMorph.text = val.name
			mirObj = val
			
	)
	on pickHead picked val do
	(
	
			pickHead.text = val.name
			mainObj = val
			
	)
	on butMirror pressed do
	(	
	 try
	 (
		viewport.setType #view_front
		tempMain = copy mainObj
		hide mainObj
		tempTarget = copy mirObj
		hide mirObj
		clearSelection()
		
		collapseStack tempMain
		collapseStack tempTarget
		
		scale tempTarget [-1,1,1]
		addModifier tempTarget (Morpher ())
		tempTarget.modifiers[#Morpher].Autoload_of_targets = 1
		WM3_MC_BuildFromNode tempTarget.morpher 1 tempMain
		set animate on
		sliderTime = 5f
		WM3_MC_SetValue tempTarget.modifiers[#morpher] 1 100.00
		set animate off
		
		tempMain_new = copy tempMain
		delete tempMain
		tempMain_new.pos = tempTarget.pos
		
		addModifier tempMain_new (Skin_Wrap ())
		tempMain_new.modifiers[#Skin_Wrap].falloff = 0.001
		tempMain_new.modifiers[#Skin_Wrap].distance = 0.001
		tempMain_new.modifiers[#Skin_Wrap].faceLimit = 1
		tempMain_new.modifiers[#Skin_Wrap].engine = 1
		tempMain_new.modifiers[#Skin_Wrap].meshList [1] = tempTarget
		sliderTime = 100
		sliderTime = 50
		sliderTime = 10
		sliderTime = 5
		sliderTime = 0
		convertto  tempMain_new editable_poly
		delete tempTarget
		
		unhide mainObj
		unhide mirObj
		tempMain_new.pos = mirObj.pos
		tempMain_new.wireColor = mirObj.wireColor
		local varNewName = mirObj.name
		delete mirObj
		tempMain_new.name= varNewName
	)
	catch(Messagebox "Select Right Objects or Invalid Process")

	)
)

rollout rollAbout "About"
(
	label myabout "Developed by:Susanta Dutta" align:#left width:300
	hyperlink emailid "susanta3d@gmail.com" align:#center width:111 address:"mailto:susanta3d@gmail.com"
	

)



if varFloatMirror != undefined then closeRolloutFloater varFloatMirror
varFloatMirror = newRolloutFloater "Santa Mirror Morph" 200 180
addRollOut rollMirror varFloatMirror
addRollOut rollAbout varFloatMirror
)