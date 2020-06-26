import os

# Paths
qssFilePath = r"C:\Users\riffraff\Dropbox\Scripting\maxscript\Construction\files"
licPath = r"C:\Users\riffraff\Dropbox\Scripting\maxscript\4_Final stage\Config\lic"
modulesPath = r"C:\Users\riffraff\Dropbox\Scripting\maxscript\4_Final stage\Config\modules"
tempfStructFolder = r"C:\Users\Public\Documents\fStructX"
qssFileName = "adminPanelStylesheet.qss"
logName = r"log.txt"
licName = r"Licenses.ini"

logFile = os.path.join(tempfStructFolder, logName) #not used
licenseFile = os.path.join(licPath, licName)
qssFile = os.path.join(qssFilePath, qssFileName)

# Text
removeBtnText = "Remove"
licenseOnText = "ON"
licenseOffText = "OFF"
updateBtnText = "Update"
activateAllText = "+"
removeAllText = "-"

# License true/false
true = "true"
false = "false"

# Roles
roles = {
    "o":"owner",
    "a":"admin",
    "u":"user",
}

# Sections
domainSection = 'DOMAIN'
domainName = ''
ownerSection = 'OWNER'
ownerName = 'riffraff'

# Options
keyName = "__name__"
keyRole = "__role__"
keyLic = "__lic__"
keyReg = "__reg__"
keyAccount = "__account__"
keyId = "__id__"

# ints
pauseFor = 2500
# usersCount = 4

# Messages
deleteUserMsg = 'Are you sure you want to delete this user ? \n\t         [  {0}  ]'
licenseOnOffMsg = 'Are you sure you want to turn [ {0} ]  [ {1} ]  license ?'
removeAllUsersMsg = 'Are you sure you want to remove ALL users ?'
licenseOnOffAllUsersMsg = 'Are you sure you want to set all license [ {0} ] ?'