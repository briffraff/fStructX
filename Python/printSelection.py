import MaxPlus as mp

selectionManager = mp.SelectionManager

mySel = selectionManager.Nodes
objectList = []

for each in mySel: 
    x = each.Name 
    objectList.append(x)

selectionCount = selectionManager.GetCount()

if selectionCount == 0:
    print "Nqma selektirani obekti v scenata"
elif (selectionCount == 1):
    selObj = objectList[selectionCount - 1]
    print "Selektiraniqt obekt e : {0}".format(selObj)
else:
    counter = 0
    for selection in objectList:
        if (counter == 0):
            print "Obshtiqt broi : {0}".format(selectionCount)
            print "{0}: {1}".format(counter+1,selection)
        else:
            print "{0}: {1}".format(counter+1,selection)
        
        counter += 1 