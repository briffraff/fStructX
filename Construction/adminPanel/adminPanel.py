import variables_ as gc

import sys

# append sys paths
sys.path.append(gc.modulesPath)

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
        self.tableWidget.setColumnCount(len(gc.columns))

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
        self.updateDomainBtn.setText(self.setBtnText(self.updateDomainBtn.accessibleName(),gc.true))   
        self.horizontalLayout_2.addWidget(self.updateDomainBtn)

        # - Users count label
        self.usersCountLabel = QtGui.QLabel(self.domainFrame)
        self.horizontalLayout_4.addWidget(self.usersCountLabel)

        # - Users count 
        self.usersCountField = QtGui.QLabel(self.domainFrame)
        self.usersCountField.setMaximumSize(QtCore.QSize(40,18))
        self.usersCountField.setObjectName("usersCountField")
        self.usersCountField.setAccessibleName("usersCountField")
        self.horizontalLayout_4.addWidget(self.usersCountField)

        #spacer
        spacerItem3 = QtGui.QSpacerItem(240, 20, QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Minimum)
        self.horizontalLayout_4.addItem(spacerItem3)

        # - Activate all licenses button
        self.activateAllBtn = QtGui.QPushButton(self.domainFrame)
        self.activateAllBtn.setMinimumWidth(40)
        self.activateAllBtn.setMaximumSize(QtCore.QSize(40,24))
        self.activateAllBtn.setObjectName("activateAllBtn")
        self.activateAllBtn.setAccessibleName("activateAllBtn")
        self.activateAllBtn.setText(self.setBtnText(self.activateAllBtn.accessibleName(),gc.true))
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
        self.removeAllBtn.setText(self.setBtnText(self.removeAllBtn.accessibleName(),gc.true))
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
        # self.usersCountField.setStyleSheet("background-color:#258bdd")


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
            self.text = gc.removeBtnText
            self.deleteBtn.setStyleSheet("#deleteBtn {background-color: #fe0000;} #deleteBtn:pressed {background-color: #444444; color: white;}")

        if (buttonName == "licenseBtn"):
            if (currentStatus == "true"):
                self.text = gc.licenseOnText
                self.onOffBtn.setStyleSheet("#licenseBtn {background-color: #6dae2e;} #licenseBtn:pressed {background-color: #444444; color: white;}")
            else:
                self.text = gc.licenseOffText
                self.onOffBtn.setStyleSheet("#licenseBtn {background-color: #fe0000;} #licenseBtn:pressed {background-color: #444444; color: white;}")

        if(buttonName == "updateDomainBtn"):
            self.text = gc.updateBtnText
            self.updateDomainBtn.setStyleSheet("#updateDomainBtn:pressed { background-color: #0078d7; color:white }")  

        if(buttonName == "activateAllBtn"):
            self.text = gc.activateAllText
            self.activateAllBtn.setStyleSheet("#activateAllBtn {font-size: 16px; background-color: #6dae2e; color:white;} #activateAllBtn:pressed {background-color: #444; color:white;}")
            
        if(buttonName == "removeAllBtn"):
            self.text = gc.removeAllText
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
        self.licenseFileInfo = self.readConfigFile(gc.licenseFile)
        
        #init empty user object
        self.currentUser = dict({
            gc.keyAccount : "",
            gc.keyId : "",
            gc.keyName : "",
            gc.keyRole : "",
            gc.keyLic : "",
            gc.keyReg : "",
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
            self.currentUser[gc.keyAccount] = self.currentUserAccount
            self.currentUser[gc.keyName] = self.registerNameField.text()
            self.currentUser[gc.keyRole] = self.registerRoleField.text()
            self.currentUser[gc.keyLic] = gc.false
            self.currentUser[gc.keyReg] = self.calcRegToDate()
            self.currentUser[gc.keyId] = self.generateUUID(self.currentUser[gc.keyAccount],self.currentUser[gc.keyName],self.currentUser[gc.keyRole])


            #create section and set values
            self.licenseFileInfo.add_section(self.currentUser[gc.keyAccount])

            for index, (key,value) in enumerate(self.currentUser.items()):
                
                if(key == gc.keyAccount):
                    continue
                
                self.licenseFileInfo.set(self.currentUser[gc.keyAccount],key,str(value))

            with open(gc.licenseFile,"w") as lic:
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
            self.theMsg = gc.deleteUserMsg.format(self.currentAccount)

        elif(msg.__contains__("license")):
            self.clickedBtnText = QtGui.qApp.focusWidget().text()
            #get text of the button then passed opposite to the message
            if(self.clickedBtnText == gc.licenseOffText):
                self.theMsg = gc.licenseOnOffMsg.format(gc.licenseOnText,self.currentAccount)
            elif(self.clickedBtnText == gc.licenseOnText ):
                self.theMsg = gc.licenseOnOffMsg.format(gc.licenseOffText,self.currentAccount)

        elif(msg.__contains__("ALL")):
            self.theMsg = gc.removeAllUsersMsg
        
        elif(msg.__contains__("onOffAllLicense")):
            self.clickedBtnText = QtGui.qApp.focusWidget().text()
            #get text of the button then passed opposite to the message
            if(self.clickedBtnText == "-"):
                self.theMsg = gc.removeAllUsersMsg.format(gc.licenseOnText)
            elif(self.clickedBtnText == "+"):
                self.theMsg = gc.removeAllUsersMsg.format(gc.licenseOffText)
        
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
        self.licenseFileInfo = self.readConfigFile(gc.licenseFile)

        # get clicked widget
        self.focusedWidget = self.focusOnClickedWidget()
        # get row index
        self.currentUserRow = self.focusedWidget[2]
        #select row
        self.tableWidget.selectRow(self.currentUserRow)

        # get account name
        self.currentAccount = self.tableWidget.item(self.currentUserRow, 2).text()

        # message method to confirm delete process
        self.confirmDelete = self.message(gc.deleteUserMsg)

        if(self.confirmDelete == QtGui.QMessageBox.Yes):

            # Delete ini record
            self.licenseFileInfo.remove_section(self.currentAccount)

            with open(gc.licenseFile,'w') as output_file:
                self.licenseFileInfo.write(output_file)

            # Delete row
            self.tableWidget.removeRow(self.currentUserRow)

            self.populateTable()
        else:
            return


    # - Activate or Deactivate user license
    def activateDeactivateLicense(self):
        #read ini files
        self.licenseFileInfo = self.readConfigFile(gc.licenseFile)

        # get clicked widget
        self.focusedWidget = self.focusOnClickedWidget()
        # get row index
        self.currentUserRow = self.focusedWidget[2]
        #select row
        self.tableWidget.selectRow(self.currentUserRow)

        # get account name
        self.currentAccount = self.tableWidget.item(self.currentUserRow, 2).text()

        #message method to confirm delete process
        self.confirmDelete = self.message(gc.licenseOnOffMsg)

        if (self.confirmDelete == QtGui.QMessageBox.Yes):
            
            # Change license - on or off
            self.currentLicenseStatus = self.licenseFileInfo.get(self.currentAccount,gc.keyLic)

            # set to OFF
            if(self.currentLicenseStatus == gc.true):
                self.licenseFileInfo.set(self.currentAccount,gc.keyLic,gc.false)
            # set to ON
            elif(self.currentLicenseStatus == gc.false):
                self.licenseFileInfo.set(self.currentAccount,gc.keyLic,gc.true)

            with open(gc.licenseFile,'w') as output_file:
                self.licenseFileInfo.write(output_file)

            #populate table
            self.populateTable()

            #select row
            self.tableWidget.selectRow(self.currentUserRow)
        else:
            return


    # - Activate all users account
    def activateAllLic(self):

        # deselect all rows
        self.tableWidget.clearSelection()

        #read ini files
        self.licenseFileInfo = self.readConfigFile(gc.licenseFile)

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

            self.clickedBtnText = QtGui.qApp.focusWidget().text()

            if(self.clickedBtnText == "+"):
                #change license status
                for section in self.filteredSections:

                    #check if current section exist in the config file
                    self.isLicenseExist = self.licenseFileInfo.has_section(section)

                    # set to OFF
                    if (self.isLicenseExist):   
                        self.licenseFileInfo.set(section,gc.keyLic,gc.false)

                self.activateAllBtn.setText("-")
                self.activateAllBtn.setStyleSheet("#activateAllBtn {font-size: 20px; background-color:  #fe0000; color:white;} #activateAllBtn:pressed {background-color: #444; color:white;}")

            elif(self.clickedBtnText == "-"):
                #change license status
                for section in self.filteredSections:

                    #check if current section exist in the config file
                    self.isLicenseExist = self.licenseFileInfo.has_section(section)

                    # set to ON
                    if (self.isLicenseExist):   
                        self.licenseFileInfo.set(section,gc.keyLic,gc.true)
                    
                self.activateAllBtn.setText("+")
                self.activateAllBtn.setStyleSheet("#activateAllBtn {font-size: 16px; background-color: #6dae2e; color:white;} #activateAllBtn:pressed {background-color: #444; color:white;}")


            with open(gc.licenseFile,'w') as output_file:
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
        self.licenseFileInfo = self.readConfigFile(gc.licenseFile)

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
        
        self.confirmDelete = self.message(gc.removeAllUsersMsg)

        if (self.confirmDelete == QtGui.QMessageBox.Yes):
            
            # remove sections
            for section in self.filteredSections:
                self.licenseFileInfo.remove_section(section)

            with open(gc.licenseFile,'w') as output_file:
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

            self.currentUserRow = self.btnDeleteIndex.row()

        return [self.buttonLocation,self.btnDeleteIndex,self.currentUserRow]


    # get single user info
    def getUser(self,name):
        
        self.licenseFileInfo = self.readConfigFile(gc.licenseFile)

        self.isAccount = self.licenseFileInfo.has_section(name)

        if (self.isAccount):

            # ["1","Borislav","BorisoB","admin","2022","true","Remove"]
            self.userId = self.licenseFileInfo.get(name,gc.keyId)
            self.firstName = self.licenseFileInfo.get(name,gc.keyName)
            self.accountName = name
            self.role = self.licenseFileInfo.get(name,gc.keyRole)
            self.regTo = self.licenseFileInfo.get(name,gc.keyReg)
            self.currentStatus = self.licenseFileInfo.get(name,gc.keyLic)

            self.thisUser = [self.userId,self.firstName,self.accountName,self.role,self.regTo,self.currentStatus,""]
            return self.thisUser
        

    #get all registered users(sections)
    def getUsers(self):

        #read ini file
        self.licenseFileInfo = self.readConfigFile(gc.licenseFile)

        #get sections
        self.sections = self.licenseFileInfo.sections()

        #filter sections list
        self.usersList = filter(lambda user: user != "DOMAIN" and user != "riffraff" and user != "Guest",self.sections)
        
        #sort filtered list
        self.sortedList = sorted(self.usersList)

        return self.sortedList 


    # count
    def count(self,users):

        #count the users
        self.usersCount = len(self.users)

        return self.usersCount


    # set users count to widget
    def populateUsersCountInfo(self):

        self.users = self.getUsers()

        self.usersCount = self.count(self.users)

        self.usersCountField.setText(gc.usersCountMsg.format(self.usersCount))
        self.usersCountLabel.setText(gc.usersCountText)
        

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

        self.licenseFileInfo = self.readConfigFile(gc.licenseFile)

        self.registeredDomain = self.getDomainName()

        self.activeDomain = os.environ.get("USERDOMAIN")
        self.activeUser = os.environ.get("USERNAME")
        self.domainAndUser = (self.activeDomain + "\\" + self.activeUser)

        #is env result username exist 
        self.isUserExist = self.licenseFileInfo.has_section(self.activeUser)
        self.isOwnerSection = self.licenseFileInfo.has_section(gc.ownerSection)

        #TODO Should make it domain independant

        #if user is registered
        if(self.isUserExist):

            self.isAdmin = self.licenseFileInfo.get(self.activeUser, gc.keyRole) == gc.roles['a']
            self.isOwner = self.licenseFileInfo.get(self.activeUser, gc.keyRole) == gc.roles['o']

            #if admin or owner
            if (self.isAdmin or self.isOwner):
                self.realName = self.licenseFileInfo.get(self.activeUser, gc.keyName)
                self.role = self.licenseFileInfo.get(self.activeUser,gc.keyRole)

        # #if owner section- riffraff
        # elif(self.isOwnerSection):
        #     if (self.licenseFileInfo.get(gc.ownerSection,gc.keyName) == gc.ownerName == self.activeUser):
        #         self.role = self.licenseFileInfo.get(gc.ownerSection,gc.keyRole)

        #         if (self.role == "owner"):
        #             self.realName = gc.ownerName
        
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
        self.licenseFileInfo = self.readConfigFile(gc.licenseFile)
        currentInput = self.registerDomainNameField.text()

        self.isDomainSection = self.licenseFileInfo.has_section(gc.domainSection)

        # if [DOMAIN] not exist
        if(self.isDomainSection == False):
            self.licenseFileInfo.add_section(gc.domainSection)

            with open(gc.licenseFile,'w') as output_file:
                self.licenseFileInfo.write(output_file)

        self.isDomainSection = self.licenseFileInfo.has_section(gc.domainSection)

        if(self.isDomainSection):
            self.isDomainSectionEmpty = self.licenseFileInfo.items(gc.domainSection) == []

            self.isInputNotEmpty = currentInput != ""

            if(self.isDomainSectionEmpty == False):  
                # if __name__ = ""
                self.isNameOptionEmpty = self.licenseFileInfo.get(gc.domainSection,gc.keyName) == ""

            if((self.isDomainSectionEmpty and self.isInputNotEmpty) or (self.isNameOptionEmpty and self.isInputNotEmpty)):

                self.licenseFileInfo.set(gc.domainSection,gc.keyName,currentInput)
            
                with open(gc.licenseFile,'w') as output_file:
                    self.licenseFileInfo.write(output_file)

                self.registerDomainBtn.setStyleSheet("#registerDomainBtn {background-color: #6dae2e;}")
                QtCore.QTimer.singleShot(1500, lambda :self.registerDomainBtn.setStyleSheet(
                    "#registerDomainBtn {background-color: #343434;} #registerDomainBtn:pressed { background-color: #0078d7; color:white; }"))

                self.registerDomainNameField.clear()
                self.resetStyles()

            elif(self.isDomainSectionEmpty == False and self.isNameOptionEmpty == False and self.isInputNotEmpty):
                self.registerDomainNameField.setText("Domain is already registered!")
                self.registerDomainNameField.setStyleSheet("color:red")
                QtCore.QTimer.singleShot(gc.pauseFor, lambda :self.resetStyles())
                QtCore.QTimer.singleShot(gc.pauseFor, lambda :self.registerDomainNameField.clear())

        
        self.populateDomain()
        

    # - get domain from a file
    def getDomainName(self):

        gc.domainName = ""

        self.licenseFileInfo = self.readConfigFile(gc.licenseFile)

        self.hasDomainSect = self.licenseFileInfo.has_section(gc.domainSection)

        if (self.hasDomainSect == True):

            self.isSectionEmpty = (self.licenseFileInfo.items(gc.domainSection) == [])

            if(self.isSectionEmpty == False):
               gc.domainName = self.licenseFileInfo[gc.domainSection][gc.keyName]
    
        return gc.domainName


    # - set domain to combobox widget
    def populateDomain(self):

        self.currentDomain = self.getDomainName()

        self.choseDomainBox.setItemText(0, self.currentDomain)


    # - Edit domain name if exist
    def updateDomainName(self):
        #read license file
        self.licenseFileInfo = self.readConfigFile(gc.licenseFile)

        self.isDomainSection = self.licenseFileInfo.has_section(gc.domainSection)
        
        #if domain section exist
        if (self.isDomainSection):

            currentInput = self.registerDomainNameField.text()

            self.isInputNotEmpty = currentInput != ""
            self.isDomainSectionNotEmpty = self.licenseFileInfo.items(gc.domainSection) != []
            self.isDomainSectionEmpty = self.licenseFileInfo.items(gc.domainSection) == []

            if (self.isDomainSectionNotEmpty and self.isInputNotEmpty):
                 #TODO - + if name options exist update domain anyway(doesn matter if empty or not)

                # currentRegisteredDomain = self.licenseFileInfo.get(gc.domainSection,gc.keyName)
                # if (currentRegisteredDomain != ""):

                self.licenseFileInfo.set(gc.domainSection,gc.keyName,(currentInput + "\\"))

                with open(gc.licenseFile,'w') as output_file:
                    self.licenseFileInfo.write(output_file)
                
                self.updateDomainBtn.setStyleSheet("#updateDomainBtn {background-color: #6dae2e;}")
                QtCore.QTimer.singleShot(1500, lambda :self.updateDomainBtn.setStyleSheet(
                    "#updateDomainBtn {background-color: #343434;} #updateDomainBtn:pressed { background-color: #0078d7; color:white; }"))

                self.registerDomainNameField.clear()
                self.resetStyles()

            elif(self.isDomainSectionEmpty and self.isInputNotEmpty):
                self.registerDomainNameField.setText("Need to register domain first !")
                self.registerDomainNameField.setStyleSheet("color:red")
                QtCore.QTimer.singleShot(gc.pauseFor, lambda :self.resetStyles())
                QtCore.QTimer.singleShot(gc.pauseFor, lambda :self.registerDomainNameField.clear())

        self.populateDomain()


    # - Populate table with users info
    def populateTable(self):

        #get users
        self.users = list(self.getUsers())

        #count the users
        self.usersCount = self.count(self.users)
        
        #set table rows count
        self.tableWidget.setRowCount(self.usersCount)
        
        #set table columns count
        self.userPropertiesCount = self.tableWidget.columnCount() # options count

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
                owner = self.role == gc.roles['o']
                admin = self.role == gc.roles['a']
                user = self.role == gc.roles['u']

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
                        self.tableWidget.setItem(row,col,item)
                        self.tableWidget.removeCellWidget(row,col)
                    else:
                        self.tableWidget.item(row,col).setText(self.userInfo[col])
                
            # self.currentStatus = "true" #debug

        # order table by column name
        self.tableWidget.setSortingEnabled(False)
        self.tableWidget.sortItems(self.tableColName,QtCore.Qt.SortOrder.AscendingOrder)

        # update user count
        self.populateUsersCountInfo()

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

    with open((gc.qssFile), 'r') as ss:
        app.setStyleSheet(ss.read())

    app.exec_()


if __name__ == "__main__":
	main()



