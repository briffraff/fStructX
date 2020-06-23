try ( destroyDialog fstructHeader) catch ()

rollout fstructHeader "Header panel" width:613 height:30
(
)

bgColDarkGrey = [52,52,52]
createDialog fstructHeader bgcolor:bgColDarkGrey pos:[(getDialogpos fStruct)[1]+fStruct.width + pdWidth1,(getDialogPos fStruct)[2]] parent:fStruct.hwnd style:#()
