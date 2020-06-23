
global fstructxInstFolder = pathConfig.GetDir #userscripts + "\\BorakaScriptPack_vol1"
global tempfStructFolder = @"C:\Users\Public\Documents\fStructX\"
global licPath = @"C:\Users\riffraff\Dropbox\Scripting\maxscript\4_Final stage\Config\lic\"
global logName = @"log.txt"
global licName = @"Licenses.ini"
global exportFilelog = tempfStructFolder + logName
global licenseFile = licPath + licName
global keyName = "__name__"
global keyRole = "__role__"
global keyLic = "__lic__"
global keyReg = "__reg__"
global expresion = " !"

global isLicensed = undefined
global owner = undefined
global role = undefined
global registeredTo = ""

fn loadAdminPanel = 
(
    adminPanelScript = @"C:\Users\riffraff\Dropbox\Scripting\maxscript\Construction\adminPanel\adminPanel.py"

    isScriptExist = doesfileExist adminPanelScript
    if (isScriptExist == true) then
    (
        --fileIn adminPanelScript --maxscript version
        python.ExecuteFile adminPanelScript
    )
    else
    (
        messagebox "Loading problem !"
    )
)

fn checkWhoIs = 
(
    local pathToChekerFile = exportFilelog
    
    local guest = "Guest"
    local noreg = "UNREGISTERED"
    local nolic = false

    local owner = ""
                
    local isAccount = false

    if(doesFileExist pathToChekerFile == true) then
        (
            -- get user name
            fileInfo = dotNetObject "System.IO.FileInfo" pathToChekerFile
            fileAccessControl = fileInfo.getAccessControl()
            NTAccountType = dotNetClass "System.Security.Principal.NTAccount"
            fileOwner = fileAccessControl.getOwner NTAccountType
            format "AUTHOR : '%' \n" fileOwner.value
            ownerPersonFull = fileOwner.value
            ownerPersonSplit = FilterString ownerPersonFull "\\"
            ownerPerson = ownerPersonSplit[ownerPersonSplit.count]

            -- check if user exists into the license file
            if(ownerPersonFull == (getINISetting licenseFile "DOMAIN" keyName) + ownerPerson) then
            (
                local isAccount = hasINISetting licenseFile ownerPerson
                if(isAccount == true) then
                (
                    owner = (getINISetting licenseFile ownerPerson keyName) + expresion
                    role = (getINISetting licenseFile ownerPerson keyRole)
                    isLicensed = getINISetting licenseFile ownerPerson keyLic
                    getRegDate = getINISetting licenseFile ownerPerson keyReg
                    registeredTo = if isLicensed == (nolic as string) then noreg else getRegDate
                )
                else
                (
                    owner = (getINISetting licenseFile guest keyName) + expresion
                    isLicensed = getINISetting licenseFile guest keyLic
                    registeredTo = getINISetting licenseFile guest keyReg
                )
            )
            else
            (
                owner = (getINISetting licenseFile guest keyName) + expresion
                isLicensed = getINISetting licenseFile guest keyLic
                registeredTo = getINISetting licenseFile guest keyReg
            )
        )
        
    return owner as string
)

fn checkLicense = 
(
    license = ""
    if(isLicensed == "true") then
    (
        license = toUpper "Licensed"
    )
    else
    (
        license = toUpper "Non-Licensed"
    )
    
    return license as string
)

fn checkRegistrationDate =
(
    register = ""
    if(isLicensed == "true") then
    (
        register = registeredTo
    )
    if(isLicensed == "false") then
    (
        register = registeredTo
    )
    
    return register as string
)

try ( destroyDialog fstructAdminSectionPanel) catch ()
rollout fstructAdminSectionPanel "Admin panel section" width:288 height:65
(
    local img_adminPanel = @"C:\Users\riffraff\Dropbox\Scripting\maxscript\Construction\imgs\adminPanel.jpg"
    local img_adminPanel_mask = @"C:\Users\riffraff\Dropbox\Scripting\maxscript\Construction\imgs\adminPanel_mask.jpg"
    local img_adminPanel_disable = @"C:\Users\riffraff\Dropbox\Scripting\maxscript\Construction\imgs\adminPanel_locked.jpg"
    button btnAdminPanel "ADMIN" pos:[0,0] width:((fstructAdminSectionPanel.width - 10)/5) height:fstructAdminSectionPanel.height align:#left border:false images:#(img_adminPanel, img_adminPanel_mask, 1, 1, 1, 1, 1)

    on fstructAdminSectionPanel open do
    (
        checkWhoIs() -- check who is the active user

        if ((role != "owner" and role != "admin") or (isLicensed != "true")) then
        (
            btnAdminPanel.enabled = false
            btnAdminPanel.images = #(img_adminPanel_disable, img_adminPanel_mask, 1, 1, 1, 1, 1)
        )
    )

    on btnAdminPanel rightclick do 
    (
        checkWhoIs()
        
        if ((role == "owner" and role == "admin") or (isLicensed == "true")) then
        (
            btnAdminPanel.enabled = true
            btnAdminPanel.images = #(img_adminPanel, img_adminPanel_mask, 1, 1, 1, 1, 1)
        )   
    ) 

    on btnAdminPanel pressed do
    (
        if ((role == "owner" and isLicensed == "true") or (role == "admin" and isLicensed == "true")) then 
        (
            loadAdminPanel()
        ) 
    )
)

bgColDarkGrey = [52,52,52]
createDialog fstructAdminSectionPanel bgcolor:bgColDarkGrey pos:[(getDialogpos fStruct)[1] + 8,(getDialogPos fStruct)[2]+fStruct.height + pdHeight3] parent:fStruct.hwnd style:#()
