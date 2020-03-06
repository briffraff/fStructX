nameObj = "SM_N05M009_SF00_0"
"SM_N05M009_SF00_0"
elements = filterstring nameObj "_"
#("SM", "N05M009", "SF00", "0")
elements
#("SM", "N05M009", "SF00", "0")
a = elements[1]
"SM"
a
"SM"
b = elements[2]
"N05M009"
c = elements[3]
"SF00"
d = elements[4]
"0"
a + "_" + b + "_" + c + "_" + d
"SM_N05M009_SF00_0"

-- matchpattern 
nameObjs = "SM_N05M009_SF00_0"
"SM_N05M009_SF00_0"
matchpattern nameobjs pattern:"SM_*******_****_*"
true

--set cursor position
(dotnetClass "Cursor").Position = dotnetObject "System.Drawing.Point" 200 150


--launch some program
if selection.count == 1 do
(	
bitmappath = $.material.diffusemap.filename
shelllaunch "C:\Program Files (x86)\Adobe\Adobe Photoshop CS2\Photoshop.exe" ("/open " + bitmappath)
)