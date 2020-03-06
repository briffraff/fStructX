fn getFileOwner f = (
local fileInfo = dotNetObject "System.IO.FileInfo" f
local fileAccessControl = fileInfo.getAccessControl()
local NTAccountType = dotNetClass "System.Security.Principal.NTAccount"
local fileOwner = fileAccessControl.getOwner NTAccountType
fileOwner.value
)

f = @"M:\MD_N\Garments\06 LS\N06W057_Versa" 
getFileOwner f