fileName = selection[1].name
	
fn MakeFileNameValid fileName = -- fname must be just filename, no path....
(
	local legal_characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-" -- illegal characters in file name
	local res = copy fileName
	local replacedSymbol = ""
	
	-- make sure the object name is legal for a filename
	local count = res.count
	
	for i = 1 to count do
	(
		if (findString legal_characters res[i]) == undefined do -- replace illegal characters with *
		(
			res[i] = "*"
			replacedSymbol = "*"
		)
	)
	--
	res
	selection[1].name = res
	print res
	print replacedSymbol
	
	if (replacedSymbol.count >= 1 and replacedSymbol == "*")do
	(
		messagebox "The name contains non latin letters ! Search for '*' "
	)
	replacedSymbol
)

MakeFileNameValid filename
