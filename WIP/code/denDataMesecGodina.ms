dateAndTime = getLocalTime()

dayNameIdx = dateAndTime[3]
data = dateAndTime[4] as string
meseciIdx = dateAndTime[2]
godina = dateAndTime[1] as string

dayNames = #("Ponedelnik","Vtornik","Srqda","Chetvurtuk","Petuk","Subuta","Nedelq")
Meseci = #("Qnuari","Fevruari","Mart","April","Mai","Iuni","Iuli","Avgust","Septemvri","Oktomvri","Noemvri","Dekemvri")

den = dayNames[dayNameidx+1]
mesec = Meseci[meseciIdx]
clearlistener()
denData = den + " " + data + " " + mesec + " " + godina
