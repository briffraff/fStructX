import sys

sys.path.append(r"C:\Users\riffraff\Dropbox\Scripting\maxscript\4_Final stage\Config\modules")

import os
from PySide import QtGui,QtCore 
from ui_adminPanel import UI_adminPanel
import resource_rc
from backports import configparser
import uuid
# from collections import OrderedDict
import datetime


class iNI(dict):
    def __init__(self):
        super(iNI, self).__init__()
        self.__dict__ = self


qssFilePath = r"C:\Users\riffraff\Dropbox\Scripting\maxscript\Construction\files"
licPath = r"C:\Users\riffraff\Dropbox\Scripting\maxscript\4_Final stage\Config\lic"
tempfStructFolder = r"C:\Users\Public\Documents\fStructX"
qssFileName = "adminPanelStylesheet.qss"
logName = r"log.txt"
licName = r"Licenses.ini"

logFile = os.path.join(tempfStructFolder, logName)
licenseFile = os.path.join(licPath, licName)
qssFile = os.path.join(qssFilePath, qssFileName)

removeBtnText = "Remove"
licenseOnText = "ON"
licenseOffText = "OFF"
updateBtnText = "Update"
activateAllText = "+"
removeAllText = "-"

true = "true"
false = "false"

roles = {
    "o":"owner",
    "a":"admin",
    "u":"user",
}

domainSection = 'DOMAIN'
domainName = ''
ownerSection = 'OWNER'
ownerName = 'riffraff'
keyName = "__name__"
keyRole = "__role__"
keyLic = "__lic__"
keyReg = "__reg__"
keyAccount = "__account__"
keyId = "__id__"
pauseFor = 2500
# usersCount = 4

deleteUserMsg = 'Are you sure you want to delete this user ? \n\t         [  {0}  ]'
licenseOnOffMsg = 'Are you sure you want to turn [ {0} ]  [ {1} ]  license ?'
removeAllUsersMsg = 'Are you sure you want to remove ALL users ?'
licenseOnOffAllUsersMsg = 'Are you sure you want to set all license [ {0} ] ?'

class MainWindow(QtGui.QMainWindow,UI_adminPanel):

    tableColId = 0
    tableColName = 1
    tableColAccountName = 2
    tableColRole = 3
    tableColRegisterTo = 4
    tableColLicense = 5
    tableColDeleteUser = 6


    def __init__(self, parent=None):
        super(MainWindow, self).__init__(parent)
        self.setupUi(self)
        self.update_ui()
        self.setIcon()
        self.connectButtonsToMethods()
        self.show()
        

    # - Update UI
    def update_ui(self):

        # - Users info table
        self.tableWidget.setColumnCount(7)

        self.tableHItem = self.tableWidget.horizontalHeaderItem

        for i in range(self.tableWidget.columnCount()):
            item = QtGui.QTableWidgetItem()
            self.tableWidget.setHorizontalHeaderItem(i, item)

        self.tableHItem(self.tableColId).setText("Id")
        self.tableHItem(self.tableColName).setText("Name")
        self.tableHItem(self.tableColAccountName).setText("Account")
        self.tableHItem(self.tableColRole).setText("Role")
        self.tableHItem(self.tableColRegisterTo).setText("Register to")
        self.tableHItem(self.tableColLicense).setText("License")
        self.tableHItem(self.tableColDeleteUser).setText("Delete user")
        
        self.tableWidget.horizontalHeader().setMinimumSize(462,20)
        self.tableWidget.horizontalHeader().setMaximumSize(462,20)
        self.tableWidget.setFixedWidth(462)

        # resize columns width
        self.tableWidget.setColumnWidth(0,30)
        self.tableWidget.setColumnWidth(1,110)
        # self.tableWidget.resizeColumnToContents(2) #its not working if sorting is False ?
        self.tableWidget.setColumnWidth(2,75)
        self.tableWidget.setColumnWidth(3,45)
        self.tableWidget.setColumnWidth(4,70)
        self.tableWidget.setColumnWidth(5,64)
        self.tableWidget.setColumnWidth(6,60)
        
        # lock header columns resize
        self.tableWidget.horizontalHeader().setResizeMode(QtGui.QHeaderView.Fixed)

        # - Update Domain Button
        self.updateDomainBtn = QtGui.QPushButton(self.registerDomainNameGroup)
        self.updateDomainBtn.setObjectName("updateDomainBtn")
        self.updateDomainBtn.setAccessibleName("updateDomainBtn")
        self.updateDomainBtn.setText(self.setBtnText(self.updateDomainBtn.accessibleName(),true))   
        self.horizontalLayout_2.addWidget(self.updateDomainBtn)

        # - Activate all licenses button
        self.activateAllBtn = QtGui.QPushButton(self.domainFrame)
        self.activateAllBtn.setMinimumWidth(40)
        self.activateAllBtn.setMaximumSize(QtCore.QSize(40,24))
        self.activateAllBtn.setObjectName("activateAllBtn")
        self.activateAllBtn.setAccessibleName("activateAllBtn")
        self.activateAllBtn.setText(self.setBtnText(self.activateAllBtn.accessibleName(),true))
        self.activateAllBtn.setToolTip("Activate all users licenses!\n\n***When the current year is over all the licenses will be set to OFF!")
        self.horizontalLayout_4.addWidget(self.activateAllBtn)

        #spacer
        spacerItem3 = QtGui.QSpacerItem(20, 17, QtGui.QSizePolicy.Fixed)
        self.horizontalLayout_4.addItem(spacerItem3)

        # - Remove all users button
        self.removeAllBtn = QtGui.QPushButton(self.domainFrame)
        self.removeAllBtn.setMinimumWidth(40)
        self.removeAllBtn.setMaximumSize(QtCore.QSize(40,24))
        self.removeAllBtn.setObjectName("removeAllBtn")
        self.removeAllBtn.setAccessibleName("removeAllBtn")
        self.removeAllBtn.setText(self.setBtnText(self.removeAllBtn.accessibleName(),true))
        self.removeAllBtn.setToolTip("Remove all users !\n")
        self.horizontalLayout_4.addWidget(self.removeAllBtn)

        #spacer
        spacerItem3 = QtGui.QSpacerItem(2, 17, QtGui.QSizePolicy.Fixed)
        self.horizontalLayout_4.addItem(spacerItem3)


        # - Styles for buttons
        self.registerDomainBtn.setStyleSheet("#registerDomainBtn:pressed { background-color: #0078d7; color:white }")
        self.registerUserBtn.setStyleSheet("#registerUserBtn:pressed { background-color: #0078d7; color:white; }")

        # - Active user info
        self.welcomeName.setStyleSheet("background-color:#258bdd")
        self.activeUserRole.setStyleSheet("background-color:#258bdd")


    # - Set Icon
    def setIcon(self):
        self.icon = QtGui.QIcon(":/resource_rc/images/icon.png")
        self.setWindowIcon(self.icon)


    def resetStyles(self):
        self.registerDomainNameField.setStyleSheet("color:white")


    # - Style methods for checkbox 
    def checkboxDomainGroup(self):

        self.checkStatus = self.registerDomainNameGroup.isChecked()

        if(self.checkStatus == True):
            self.registerDomainNameField.clear()
            self.registerDomainNameField.setStyleSheet("color:white")
        else:
            self.registerDomainNameField.clear()
            self.registerDomainNameField.setStyleSheet("color:#666")


    def checkboxUserGroup(self):
        self.checkStatus = self.registerNewUserGroup.isChecked()

        if(self.checkStatus == True):
            self.registerNameField.clear()
            self.registerNameField.setStyleSheet("color:white")

            self.registerAccountNameField.clear()
            self.registerAccountNameField.setStyleSheet("color:white")
            
            self.registerRoleField.clear()
            self.registerRoleField.setStyleSheet("color:white")

        else:
            self.registerNameField.clear()
            self.registerNameField.setStyleSheet("color:#666")

            self.registerAccountNameField.clear()
            self.registerAccountNameField.setStyleSheet("color:#666")
            
            self.registerRoleField.clear()
            self.registerRoleField.setStyleSheet("color:#666")

    
    # - Set Text and Styles to buttons
    def setBtnText(self,buttonName,currentStatus):
        self.text = ""

        if (buttonName == "deleteBtn"):
            self.text = removeBtnText
            self.deleteBtn.setStyleSheet("#deleteBtn {background-color: #fe0000;} #deleteBtn:pressed {background-color: #444444; color: white;}")

        if (buttonName == "licenseBtn"):
            if (currentStatus == "true"):
                self.text = licenseOnText
                self.onOffBtn.setStyleSheet("#licenseBtn {background-color: #6dae2e;} #licenseBtn:pressed {background-color: #444444; color: white;}")
            else:
                self.text = licenseOffText
                self.onOffBtn.setStyleSheet("#licenseBtn {background-color: #fe0000;} #licenseBtn:pressed {background-color: #444444; color: white;}")

        if(buttonName == "updateDomainBtn"):
            self.text = updateBtnText
            self.updateDomainBtn.setStyleSheet("#updateDomainBtn:pressed { background-color: #0078d7; color:white }")  

        if(buttonName == "activateAllBtn"):
            self.text = activateAllText
            self.activateAllBtn.setStyleSheet("#activateAllBtn {font-size: 16px; background-color: #6dae2e; color:white;} #activateAllBtn:pressed {background-color: #444; color:white;}")
            
        if(buttonName == "removeAllBtn"):
            self.text = removeAllText
            self.removeAllBtn.setStyleSheet("#removeAllBtn {font-size: 20px; background-color: #fe0000; color:white;} #removeAllBtn:pressed {background-color: #444; color:white;}")

        return self.text

    
    # - Add Delete button
    def addDeleteBtn(self,row,col,currentStatus):

        self.rowPos = row
        self.colPos = col

        self.deleteBtn = QtGui.QPushButton()

        self.deleteBtn.setObjectName("deleteBtn")
        self.deleteBtn.setAccessibleName("deleteBtn")

        self.name = self.deleteBtn.accessibleName()

        self.deleteBtn.setText(self.setBtnText(self.name,currentStatus))
        self.deleteBtn.setToolTip("Delete user permanently from database!\n It is undoable operation!")

        self.deleteBtn.clicked.connect(self.deleteUser)
        self.tableWidget.setCellWidget(self.rowPos,self.colPos,self.deleteBtn)


    # - Add License on/off button
    def addLicenseOnOffBtn(self,row,col,currentStatus):
        self.rowPos = row
        self.colPos = col

        self.onOffBtn = QtGui.QPushButton()
        
        self.onOffBtn.setObjectName("licenseBtn")
        self.onOffBtn.setAccessibleName("licenseBtn")

        self.name = self.onOffBtn.accessibleName()

        self.onOffBtn.setText(self.setBtnText(self.name,currentStatus))
        self.onOffBtn.setToolTip("This Action will activate or deactivate user's license!\n 1.If user's license is deactivated once the software will be automatically uninstalled!\n 2.License wouldn't be available after 'register to' date!")
        
        self.onOffBtn.clicked.connect(self.activateDeactivateLicense)
        self.tableWidget.setCellWidget(self.rowPos,self.colPos,self.onOffBtn)


    # - Register new user
    def registerUser(self):
        
        # [BorisoB]
        # __id__ = 234234df2dfin232gfoi234
        # __name__ = Borislav
        # __role__ = owner
        # __lic__ = true
        # __reg__ = UNLIMITED

        # deselect all rows
        self.tableWidget.clearSelection()

        #read ini file
        self.licenseFileInfo = self.readConfigFile(licenseFile)
        
        #init empty user object
        self.currentUser = dict({
            keyAccount : "",
            keyId : "",
            keyName : "",
            keyRole : "",
            keyLic : "",
            keyReg : "",
        })

        self.currentUserName = self.registerNameField.text()
        self.validateName = self.currentUserName != "" and self.currentUserName.count >= 2

        self.currentUserAccount = self.registerAccountNameField.text()
        self.validateAccount = self.currentUserAccount != "" and self.currentUserAccount.count >= 2

        self.currentUserRole = self.registerRoleField.text()
        self.validateRole = self.currentUserRole != "" and self.currentUserRole.count >= 4

        self.isValidate = self.validateName and self.validateAccount and self.validateRole

        #if user section exist
        if (self.licenseFileInfo.has_section(self.currentUserAccount) == False and self.isValidate):

            #collect info
            self.currentUser[keyAccount] = self.currentUserAccount
            self.currentUser[keyName] = self.registerNameField.text()
            self.currentUser[keyRole] = self.registerRoleField.text()
            self.currentUser[keyLic] = false
            self.currentUser[keyReg] = self.calcRegToDate()
            self.currentUser[keyId] = self.generateUUID(self.currentUser[keyAccount],self.currentUser[keyName],self.currentUser[keyRole])


            #create section and set values
            self.licenseFileInfo.add_section(self.currentUser[keyAccount])

            for index, (key,value) in enumerate(self.currentUser.items()):
                
                if(key == keyAccount):
                    continue
                
                self.licenseFileInfo.set(self.currentUser[keyAccount],key,str(value))

            with open(licenseFile,"w") as lic:
                self.licenseFileInfo.write(lic)

            # self.registerUserBtn.setStyleSheet("#registerUserBtn {background-color: #6dae2e;}")
            # QtCore.QTimer.singleShot(1500, lambda :self.registerUserBtn.setStyleSheet(
            #     "#registerUserBtn {background-color: #343434;} #registerUserBtn:pressed { background-color: #0078d7; color:white; }"))

            #clear fields 
            self.registerNameField.clear()
            self.registerAccountNameField.clear()
            self.registerRoleField.clear()
        
        self.populateActiveUserInfo()
        self.populateTable()

        # - select row of the registered user
        for row in range(self.tableWidget.rowCount()):
            if(self.tableWidget.item(row,self.tableColAccountName).text() == self.currentUserAccount):

                #select row
                self.tableWidget.selectRow(row)

                # imitate flash light
                QtCore.QTimer.singleShot(10, lambda :self.tableWidget.setStyleSheet("QWidget:item:selected { background-color: white; color:white; }"))
                QtCore.QTimer.singleShot(250, lambda :self.tableWidget.setStyleSheet("QWidget:item:selected { background-color: #0078d7; color:white; }"))
                QtCore.QTimer.singleShot(325, lambda :self.tableWidget.setStyleSheet("QWidget:item:selected { background-color: white; color:white; }"))
                QtCore.QTimer.singleShot(375, lambda :self.tableWidget.setStyleSheet("QWidget:item:selected { background-color: #d7801a; color:white; }"))

                break






        

    # - Generate UUID according name,account,role,current time
    def generateUUID(self,account,name,role):

        # make a UUID based on the host ID and current time
        currentTimeUuid = uuid.uuid1()

        #concat elements to generate unique string
        self.concatInfo = "{0}!{1}@{2}#{3}".format(account,name,role,currentTimeUuid)

        # return UUID type
        return uuid.uuid3(uuid.NAMESPACE_DNS,self.concatInfo)


    # - Calculate Expiration Date
    def calcRegToDate(self):

        current = datetime.datetime.now()
        year = current.strftime("%Y")
        regToDate = int(year) + 1

        return regToDate


    # - messagebox(msg)
    def message(self,msg):

        self.theMsg = ""

        # format the message accorrding passed msg
        if(msg.__contains__("delete")):
            self.theMsg = deleteUserMsg.format(self.currentAccount)

        elif(msg.__contains__("license")):
            self.clickedBtnText = self.focusOnClickedWidget().text()
            #get text of the button then passed opposite to the message
            if(self.clickedBtnText == licenseOffText):
                self.theMsg = licenseOnOffMsg.format(licenseOnText,self.currentAccount)
            elif(self.clickedBtnText == licenseOnText ):
                self.theMsg = licenseOnOffMsg.format(licenseOffText,self.currentAccount)

        elif(msg.__contains__("ALL")):
            self.theMsg = removeAllUsersMsg
        
        elif(msg.__contains__("onOffAllLicense")):
            self.clickedBtnText = self.focusOnClickedWidget().text()
            #get text of the button then passed opposite to the message
            if(self.clickedBtnText == "-"):
                self.theMsg = licenseOnOffAllUsersMsg.format(licenseOnText)
            elif(self.clickedBtnText == "+"):
                self.theMsg = licenseOnOffAllUsersMsg.format(licenseOffText)
        
        # message to confirm delete process
        self.yesNoBox = QtGui.QMessageBox(
            QtGui.QMessageBox.Question,
            'Confirm', 
            self.theMsg,
            QtGui.QMessageBox.Yes | QtGui.QMessageBox.Cancel
        )

        self.yesNoBox.setObjectName("yesNoBox")
        self.yesNoBox.setStyleSheet("color:red;")

        return self.yesNoBox.exec_()
        

    # - Delete user
    def deleteUser(self):

        #read ini files
        self.licenseFileInfo = self.readConfigFile(licenseFile)

        # get focus on table buttons
        self.btnDeleteIndex = self.tableWidget.indexAt(self.focusOnClickedWidget().pos())

        # get account name
        self.currentAccount = self.tableWidget.item(self.btnDeleteIndex.row(), 2).text()

        # message method to confirm delete process
        self.confirmDelete = self.message(deleteUserMsg)

        if(self.confirmDelete == QtGui.QMessageBox.Yes):

            # Delete ini record
            self.licenseFileInfo.remove_section(self.currentAccount)

            with open(licenseFile,'w') as output_file:
                self.licenseFileInfo.write(output_file)

            # Delete row
            self.tableWidget.removeRow(self.btnDeleteIndex.row())

            self.populateTable()
        else:
            return


    # - Activate or Deactivate user license
    def activateDeactivateLicense(self):
        #read ini files
        self.licenseFileInfo = self.readConfigFile(licenseFile)

        # get focus on table buttons
        self.btnDeleteIndex = self.tableWidget.indexAt(self.focusOnClickedWidget().pos())

        # get account name
        self.currentAccount = self.tableWidget.item(self.btnDeleteIndex.row(), 2).text()

        #message method to confirm delete process
        self.confirmDelete = self.message(licenseOnOffMsg)

        if (self.confirmDelete == QtGui.QMessageBox.Yes):
            
            # Change license - on or off
            self.currentLicenseStatus = self.licenseFileInfo.get(self.currentAccount,keyLic)

            # set to OFF
            if(self.currentLicenseStatus == true):
                self.licenseFileInfo.set(self.currentAccount,keyLic,false)
            # set to ON
            elif(self.currentLicenseStatus == false):
                self.licenseFileInfo.set(self.currentAccount,keyLic,true)

            with open(licenseFile,'w') as output_file:
                self.licenseFileInfo.write(output_file)

            #populate table
            self.populateTable()
        else:
            return


    # - Activate all users account
    def activateAllLic(self):

        # deselect all rows
        self.tableWidget.clearSelection()

        #read ini files
        self.licenseFileInfo = self.readConfigFile(licenseFile)

        #get all sections and filter them
        self.users = self.licenseFileInfo.sections()
        self.filteredSections = filter(
            lambda _section:
             _section != "DOMAIN" and 
             _section != "riffraff" and 
             _section != "BorisoB" and
             _section != "DimovD" and
             _section != "Guest",
             self.users
             )
        
        self.confirmDelete = self.message("onOffAllLicense")

        if (self.confirmDelete == QtGui.QMessageBox.Yes):

            self.clickedBtnText = self.focusOnClickedWidget().text()

            if(self.clickedBtnText == "+"):
                #change license status
                for section in self.filteredSections:

                    #check if current section exist in the config file
                    self.isLicenseExist = self.licenseFileInfo.has_section(section)

                    # set to OFF
                    if (self.isLicenseExist):   
                        self.licenseFileInfo.set(section,keyLic,false)

                self.activateAllBtn.setText("-")
                self.activateAllBtn.setStyleSheet("#activateAllBtn {font-size: 20px; background-color:  #fe0000; color:white;} #activateAllBtn:pressed {background-color: #444; color:white;}")

            elif(self.clickedBtnText == "-"):
                #change license status
                for section in self.filteredSections:

                    #check if current section exist in the config file
                    self.isLicenseExist = self.licenseFileInfo.has_section(section)

                    # set to ON
                    if (self.isLicenseExist):   
                        self.licenseFileInfo.set(section,keyLic,true)
                    
                self.activateAllBtn.setText("+")
                self.activateAllBtn.setStyleSheet("#activateAllBtn {font-size: 16px; background-color: #6dae2e; color:white;} #activateAllBtn:pressed {background-color: #444; color:white;}")


            with open(licenseFile,'w') as output_file:
                self.licenseFileInfo.write(output_file)

            #populate table
            self.populateTable()
        else:
            return


    # - Remove all users account
    def removeAllUsers(self):
        # deselect all rows
        self.tableWidget.clearSelection()

        #read ini files
        self.licenseFileInfo = self.readConfigFile(licenseFile)

        #get all sections and filter them
        self.users = self.licenseFileInfo.sections()
        self.filteredSections = filter(
            lambda _section:
             _section != "DOMAIN" and 
             _section != "riffraff" and 
             _section != "BorisoB" and
             _section != "DimovD" and
             _section != "Guest",
             self.users
             )
        
        self.confirmDelete = self.message(removeAllUsersMsg)

        if (self.confirmDelete == QtGui.QMessageBox.Yes):
            
            # remove sections
            for section in self.filteredSections:
                self.licenseFileInfo.remove_section(section)

            with open(licenseFile,'w') as output_file:
                self.licenseFileInfo.write(output_file)

            #populate table
            self.populateTable()
        else:
            return
    

    # get clicked widget and select row
    def focusOnClickedWidget(self):

        # get focus on table buttons
        self.buttonLocation = QtGui.qApp.focusWidget()

        if(self.buttonLocation.accessibleName() != "activateAllBtn"):
            self.btnDeleteIndex = self.tableWidget.indexAt(self.buttonLocation.pos())
            print "col={} ,row={}".format(self.btnDeleteIndex.column(), self.btnDeleteIndex.row())

            # get row index
            self.currentUserNumber = self.btnDeleteIndex.row()

            #select row
            self.tableWidget.selectRow(self.currentUserNumber)
            print "{0}".format(self.currentUserNumber)

        return self.buttonLocation


    # get single user info
    def getUser(self,name):
        
        self.licenseFileInfo = self.readConfigFile(licenseFile)

        self.isAccount = self.licenseFileInfo.has_section(name)

        if (self.isAccount):

            # ["1","Borislav","BorisoB","admin","2022","true","Remove"]
            self.userId = self.licenseFileInfo.get(name,keyId)
            self.firstName = self.licenseFileInfo.get(name,keyName)
            self.accountName = name
            self.role = self.licenseFileInfo.get(name,keyRole)
            self.regTo = self.licenseFileInfo.get(name,keyReg)
            self.currentStatus = self.licenseFileInfo.get(name,keyLic)

            self.thisUser = [self.userId,self.firstName,self.accountName,self.role,self.regTo,self.currentStatus,""]
            return self.thisUser
        

    #get all registered users(sections)
    def getUsers(self):

        #read ini file
        self.licenseFileInfo = self.readConfigFile(licenseFile)

        #get sections
        self.sections = self.licenseFileInfo.sections()

        #filter sections list
        self.usersList = filter(lambda user: user != "DOMAIN" and user != "riffraff" and user != "Guest",self.sections)
        
        #sort filtered list
        self.sortedList = sorted(self.usersList)

        return self.sortedList 


    #users count
    def count(self,users):

        #count the users
        self.usersCount = len(self.users)

        return self.usersCount


    # get row and col for selection
    def getRowAndCol(self):
        
        self.currentRow = self.tableWidget.currentRow()
        self.currentCol = self.tableWidget.currentColumn()

        self.rowCol = [self.currentRow,self.currentCol]

        return self.rowCol


    # Who is the active user (owner or admin)
    def getActiveUserInfo(self):
        
        self.realName = ""
        self.role = ""

        self.licenseFileInfo = self.readConfigFile(licenseFile)

        self.registeredDomain = self.getDomainName()

        self.activeDomain = os.environ.get("USERDOMAIN")
        self.activeUser = os.environ.get("USERNAME")
        self.domainAndUser = (self.activeDomain + "\\" + self.activeUser)

        #is env result username exist 
        self.isUserExist = self.licenseFileInfo.has_section(self.activeUser)
        self.isOwnerSection = self.licenseFileInfo.has_section(ownerSection)

        #TODO Should make it domain independant

        #if user is registered
        if(self.isUserExist):

            self.isAdmin = self.licenseFileInfo.get(self.activeUser, keyRole) == "admin"
            self.isOwner = self.licenseFileInfo.get(self.activeUser, keyRole) == "owner"

            #if admin or owner
            if (self.isAdmin or self.isOwner):
                self.realName = self.licenseFileInfo.get(self.activeUser, keyName)
                self.role = self.licenseFileInfo.get(self.activeUser,keyRole)

        # #if owner section- riffraff
        # elif(self.isOwnerSection):
        #     if (self.licenseFileInfo.get(ownerSection,keyName) == ownerName == self.activeUser):
        #         self.role = self.licenseFileInfo.get(ownerSection,keyRole)

        #         if (self.role == "owner"):
        #             self.realName = ownerName
        
        self.userInfo = [self.realName,self.role]

        return self.userInfo


    # - set info to active user info text fields 
    def populateActiveUserInfo(self):

        self.userInfo = self.getActiveUserInfo()

        self.welcomeName.setText(" {0}, {1} ".format("Welcome",self.userInfo[0]))
        self.activeUserRole.setText("=> {0}".format(self.userInfo[1]))


    # - Read License ini config file
    def readConfigFile(self,licFile):

        self.config = configparser.ConfigParser(dict_type=iNI)

        if (os.path.exists(licFile)):
            self.config.read(licFile)
        
        return self.config


    # - Register domain
    def registerDomain(self):

        #read license file
        self.licenseFileInfo = self.readConfigFile(licenseFile)
        currentInput = self.registerDomainNameField.text()

        if (self.licenseFileInfo.has_section(domainSection)):
            if(self.licenseFileInfo.items(domainSection) == [] and currentInput != ""):

                self.licenseFileInfo.set(domainSection,keyName,currentInput)
               
                with open(licenseFile,'w') as output_file:
                    self.licenseFileInfo.write(output_file)

                self.registerDomainBtn.setStyleSheet("#registerDomainBtn {background-color: #6dae2e;}")
                QtCore.QTimer.singleShot(1500, lambda :self.registerDomainBtn.setStyleSheet(
                    "#registerDomainBtn {background-color: #343434;} #registerDomainBtn:pressed { background-color: #0078d7; color:white; }"))

                self.registerDomainNameField.clear()
                self.resetStyles()

            elif(self.licenseFileInfo.items(domainSection) != [] and currentInput != ""):
                self.registerDomainNameField.setText("Domain is already registered!")
                self.registerDomainNameField.setStyleSheet("color:red")
                QtCore.QTimer.singleShot(pauseFor, lambda :self.resetStyles())
                QtCore.QTimer.singleShot(pauseFor, lambda :self.registerDomainNameField.clear())
                         
        self.populateDomain()
        

    # - get domain from a file
    def getDomainName(self):

        domainName = ""

        self.licenseFileInfo = self.readConfigFile(licenseFile)

        self.hasDomainSect = self.licenseFileInfo.has_section(domainSection)

        if (self.hasDomainSect == True):

            self.isSectionEmpty = (self.licenseFileInfo.items(domainSection) == [])

            if(self.isSectionEmpty == False):
               domainName = self.licenseFileInfo[domainSection][keyName]
    
        return domainName


    # - set domain to combobox widget
    def populateDomain(self):

        self.currentDomain = self.getDomainName()

        self.choseDomainBox.setItemText(0, self.currentDomain)


    # - Edit domain name if exist
    def updateDomainName(self):
        #read license file
        self.licenseFileInfo = self.readConfigFile(licenseFile)

        #if domain section exist
        if (self.licenseFileInfo.has_section(domainSection)):

            currentInput = self.registerDomainNameField.text()

            if (self.licenseFileInfo.items(domainSection) != [] and currentInput != ""):
                currentRegisteredDomain = self.licenseFileInfo.get(domainSection,keyName)

                if (currentRegisteredDomain != ""):

                    self.licenseFileInfo.set(domainSection,keyName,(currentInput + "\\"))

                    with open(licenseFile,'w') as output_file:
                        self.licenseFileInfo.write(output_file)
                    
                    self.updateDomainBtn.setStyleSheet("#updateDomainBtn {background-color: #6dae2e;}")
                    QtCore.QTimer.singleShot(1500, lambda :self.updateDomainBtn.setStyleSheet(
                        "#updateDomainBtn {background-color: #343434;} #updateDomainBtn:pressed { background-color: #0078d7; color:white; }"))

                    self.registerDomainNameField.clear()
                    self.resetStyles()

            elif(self.licenseFileInfo.items(domainSection) == [] and currentInput != ""):
                self.registerDomainNameField.setText("Need to register domain first !")
                self.registerDomainNameField.setStyleSheet("color:red")
                QtCore.QTimer.singleShot(pauseFor, lambda :self.resetStyles())
                QtCore.QTimer.singleShot(pauseFor, lambda :self.registerDomainNameField.clear())

        self.populateDomain()



    # - Populate table with users info
    def populateTable(self):

        # self.tableWidget.setSortingEnabled(False)

        #get users
        self.users = list(self.getUsers())

        #count the users
        self.usersCount = self.count(self.users)
        
        #set table row count
        self.tableWidget.setRowCount(self.usersCount)
        
        #set table column count
        self.userPropertiesCount = self.tableWidget.columnCount() # properties count

        # set item
        for row, accountName in enumerate(self.users):

            # if (row == 2):
            #     self.currentStatus = "false" #debug

            # get user by account name
            self.userInfo = self.getUser(accountName)

            # read status and role for this user
            self.currentStatus = self.userInfo[self.tableColLicense]
            self.role = self.userInfo[self.tableColRole]

            # set options values
            for col in range(self.userPropertiesCount):

                # init widget
                item = QtGui.QTableWidgetItem()
                item.setFlags(QtCore.Qt.ItemIsSelectable|QtCore.Qt.ItemIsEnabled)
                item.setTextAlignment(QtCore.Qt.AlignCenter)

                # set this widget item to the cell
                self.tableWidget.setItem(row, col, item)

                #check role
                owner = self.role == roles['o']
                admin = self.role == roles['a']
                user = self.role == roles['u']

                # add license button : column 5 and user or admin
                if (self.tableColLicense == col and user or self.tableColLicense == col and admin):
                    self.addLicenseOnOffBtn(row,col,self.currentStatus)
                # add delete button : column 6 and user or admin
                elif (self.tableColDeleteUser == col and user or self.tableColDeleteUser == col and admin):
                    self.addDeleteBtn(row,col,self.currentStatus)
                #all other options
                else:
                    if(col == self.tableColLicense and owner or col == self.tableColDeleteUser and owner):
                        self.tableWidget.takeItem(row,col)
                    else:
                        self.tableWidget.item(row,col).setText(self.userInfo[col])
                
            # self.currentStatus = "true" #debug

        # order table by column name
        # self.tableWidget.setSortingEnabled(True)
        # self.tableWidget.sortItems(1,QtCore.Qt.SortOrder.AscendingOrder)
        # self.tableWidget.horizontalHeader().setSortIndicator(1,QtCore.Qt.AscendingOrder)

    def core(self):
        self.populateActiveUserInfo()
        self.populateDomain()
        self.populateTable()

    def connectButtonsToMethods(self):
        self.updateDomainBtn.clicked.connect(self.updateDomainName)
        self.registerDomainBtn.clicked.connect(self.registerDomain)
        self.registerDomainNameGroup.clicked.connect(self.checkboxDomainGroup)
        self.registerUserBtn.clicked.connect(self.registerUser)
        self.registerNewUserGroup.clicked.connect(self.checkboxUserGroup)
        self.activateAllBtn.clicked.connect(self.activateAllLic)
        self.removeAllBtn.clicked.connect(self.removeAllUsers)

def main():
    app = QtGui.QApplication.instance()
    if not app:
        app = QtGui.QApplication(sys.argv)

    mainWin = MainWindow()
    mainWin.core()

  
    with open((qssFile), 'r') as ss:
        app.setStyleSheet(ss.read())

    app.exec_()


if __name__ == "__main__":
	main()



