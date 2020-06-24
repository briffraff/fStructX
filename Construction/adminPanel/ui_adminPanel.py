from PySide import QtCore, QtGui

_translate = QtCore.QCoreApplication.translate
_utf8 = QtGui.QApplication.UnicodeUTF8

class UI_adminPanel(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.setStyleSheet("background-image: url(:/images/images/AdminPanel_ui);")
        MainWindow.setWindowModality(QtCore.Qt.NonModal)
        MainWindow.resize(480, 650)
        MainWindow.setMinimumSize(QtCore.QSize(480, 360))
        MainWindow.setMaximumSize(QtCore.QSize(480, 800))
        MainWindow.setAutoFillBackground(True)
        MainWindow.setDocumentMode(False)
        MainWindow.setTabShape(QtGui.QTabWidget.Rounded)
        MainWindow.setDockNestingEnabled(False)


        # - Central Widget ----------------------------------------------------------
        self.centralWidget = QtGui.QWidget(MainWindow)
        self.centralWidget.setObjectName("centralWidget")
        self.centralWidget.setStyleSheet("background:transparent;")
        self.verticalLayout_2 = QtGui.QVBoxLayout(self.centralWidget)
        self.verticalLayout_2.setObjectName("verticalLayout_2")


        # - Header ----------------------------------------------------------
        self.header = QtGui.QFrame(self.centralWidget)
        self.header.setFrameShape(QtGui.QFrame.NoFrame)
        self.header.setFrameShadow(QtGui.QFrame.Raised)
        self.header.setObjectName("header")
        self.verticalLayout = QtGui.QVBoxLayout(self.header)
        self.verticalLayout.setObjectName("verticalLayout")
        self.welcomelayout = QtGui.QHBoxLayout()
        self.welcomelayout.setObjectName("welcomelayout")
        spacerItem = QtGui.QSpacerItem(276, 20, QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Minimum)
        self.welcomelayout.addItem(spacerItem)
        self.welcomeName = QtGui.QLabel(self.header)
        self.welcomeName.setEnabled(True)
        font = QtGui.QFont()
        font.setPointSize(10)
        self.welcomeName.setFont(font)
        self.welcomeName.setAutoFillBackground(False)
        self.welcomeName.setScaledContents(False)
        self.welcomeName.setWordWrap(False)
        self.welcomeName.setIndent(-4)
        self.welcomeName.setObjectName("welcomeName")
        self.welcomelayout.addWidget(self.welcomeName)
        self.verticalLayout.addLayout(self.welcomelayout)
        self.ownerlayout = QtGui.QHBoxLayout()
        self.ownerlayout.setObjectName("ownerlayout")
        spacerItem1 = QtGui.QSpacerItem(350, 20, QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Minimum)
        self.ownerlayout.addItem(spacerItem1)
        self.activeUserRole = QtGui.QLabel(self.header)
        self.activeUserRole.setEnabled(True)
        self.activeUserRole.setMinimumSize(QtCore.QSize(60, 0))
        self.activeUserRole.setMaximumSize(QtCore.QSize(60, 16777215))
        font = QtGui.QFont()
        font.setPointSize(8)
        self.activeUserRole.setFont(font)
        self.activeUserRole.setAutoFillBackground(False)
        self.activeUserRole.setScaledContents(False)
        self.activeUserRole.setWordWrap(False)
        self.activeUserRole.setIndent(-4)
        self.activeUserRole.setObjectName("activeUserRole")
        self.ownerlayout.addWidget(self.activeUserRole)
        self.verticalLayout.addLayout(self.ownerlayout)
        self.verticalLayout_2.addWidget(self.header)


        # - Choose Domain ----------------------------------------------------------
        self.domainFrame = QtGui.QFrame(self.centralWidget)
        self.domainFrame.setFrameShape(QtGui.QFrame.StyledPanel)
        self.domainFrame.setFrameShadow(QtGui.QFrame.Raised)
        self.domainFrame.setObjectName("domainFrame")

        self.horizontalLayout_4 = QtGui.QHBoxLayout(self.domainFrame)
        self.horizontalLayout_4.setObjectName("horizontalLayout_4")

        self.activeDomainLbl = QtGui.QLabel(self.domainFrame)
        self.activeDomainLbl.setObjectName("activeDomainLbl")
        self.horizontalLayout_4.addWidget(self.activeDomainLbl)

        self.choseDomainBox = QtGui.QComboBox(self.domainFrame)
        self.choseDomainBox.setMinimumSize(QtCore.QSize(120, 0))
        self.choseDomainBox.setObjectName("choseDomainBox")
        self.choseDomainBox.addItem("")
        self.horizontalLayout_4.addWidget(self.choseDomainBox)

        spacerItem2 = QtGui.QSpacerItem(234, 17, QtGui.QSizePolicy.Expanding, QtGui.QSizePolicy.Minimum)
        self.horizontalLayout_4.addItem(spacerItem2)
        
        self.verticalLayout_2.addWidget(self.domainFrame)
        

        # - Table ----------------------------------------------------------
        self.tableWidget = QtGui.QTableWidget(self.centralWidget)
        self.tableWidget.setToolTip("")
        self.tableWidget.setAutoFillBackground(True)
        self.tableWidget.setFrameShape(QtGui.QFrame.NoFrame)
        self.tableWidget.setFrameShadow(QtGui.QFrame.Plain)
        self.tableWidget.setLineWidth(0)
        self.tableWidget.setAutoScroll(True)
        self.tableWidget.setAutoScrollMargin(16)
        self.tableWidget.setEditTriggers(QtGui.QAbstractItemView.CurrentChanged|QtGui.QAbstractItemView.EditKeyPressed|QtGui.QAbstractItemView.SelectedClicked)
        self.tableWidget.setDragDropOverwriteMode(False)
        self.tableWidget.setDragDropMode(QtGui.QAbstractItemView.NoDragDrop)
        self.tableWidget.setAlternatingRowColors(False)
        self.tableWidget.setSelectionMode(QtGui.QAbstractItemView.ExtendedSelection)
        self.tableWidget.setSelectionBehavior(QtGui.QAbstractItemView.SelectRows)
        self.tableWidget.setVisible(False)
        self.tableWidget.resizeColumnsToContents()
        self.tableWidget.setVisible(True)
        self.tableWidget.setTextElideMode(QtCore.Qt.ElideLeft)
        self.tableWidget.setShowGrid(True)
        self.tableWidget.setGridStyle(QtCore.Qt.DashLine)
        self.tableWidget.setWordWrap(False)
        self.tableWidget.setColumnCount(0)
        self.tableWidget.setRowCount(0)
        self.tableWidget.setObjectName("tableWidget")

        self.tableWidget.horizontalHeader().setVisible(True)
        self.tableWidget.horizontalHeader().setCascadingSectionResizes(True)
        self.tableWidget.horizontalHeader().setDefaultSectionSize(66)
        self.tableWidget.horizontalHeader().setHighlightSections(True)
        self.tableWidget.horizontalHeader().setSortIndicatorShown(False)
        self.tableWidget.horizontalHeader().setStretchLastSection(True)
        self.tableWidget.horizontalHeader().setObjectName("horizontalHeader")

        self.tableWidget.verticalHeader().setVisible(False)
        self.tableWidget.verticalHeader().setCascadingSectionResizes(False)
        self.tableWidget.verticalHeader().setDefaultSectionSize(25)
        self.tableWidget.verticalHeader().setHighlightSections(False)
        self.tableWidget.verticalHeader().setSortIndicatorShown(False)
        self.tableWidget.verticalHeader().setObjectName("verticalHeader")
        self.verticalLayout_2.addWidget(self.tableWidget)

        self.tableWidget.setCornerButtonEnabled(False)


        # - Register Domain ----------------------------------------------------------
        self.registerDomainNameGroup = QtGui.QGroupBox(self.centralWidget)
        self.registerDomainNameGroup.setFlat(False)
        self.registerDomainNameGroup.setCheckable(True)
        self.registerDomainNameGroup.setChecked(False)
        self.registerDomainNameGroup.setObjectName("registerDomainNameGroup")
        self.horizontalLayout_2 = QtGui.QHBoxLayout(self.registerDomainNameGroup)
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")

        self.registerDomainNameField = QtGui.QLineEdit(self.registerDomainNameGroup)
        self.registerDomainNameField.setReadOnly(False)
        self.registerDomainNameField.setObjectName("registerDomainNameField")
        self.horizontalLayout_2.addWidget(self.registerDomainNameField)

        self.registerDomainBtn = QtGui.QPushButton(self.registerDomainNameGroup)
        self.registerDomainBtn.setObjectName("registerDomainBtn")
        self.horizontalLayout_2.addWidget(self.registerDomainBtn)


        self.verticalLayout_2.addWidget(self.registerDomainNameGroup)


        # - Register New User ----------------------------------------------------------
        self.registerNewUserGroup = QtGui.QGroupBox(self.centralWidget)
        self.registerNewUserGroup.setCheckable(True)
        self.registerNewUserGroup.setChecked(False)
        self.registerNewUserGroup.setObjectName("registerNewUserGroup")

        self.horizontalLayout = QtGui.QHBoxLayout(self.registerNewUserGroup)
        self.horizontalLayout.setObjectName("horizontalLayout")

        self.registerNameField = QtGui.QLineEdit(self.registerNewUserGroup)
        self.registerNameField.setReadOnly(False)
        self.registerNameField.setObjectName("registerNameField")
        self.horizontalLayout.addWidget(self.registerNameField)

        self.registerAccountNameField = QtGui.QLineEdit(self.registerNewUserGroup)
        self.registerAccountNameField.setText("")
        self.registerAccountNameField.setReadOnly(False)
        self.registerAccountNameField.setObjectName("registerAccountNameField")
        self.horizontalLayout.addWidget(self.registerAccountNameField)

        self.registerRoleField = QtGui.QLineEdit(self.registerNewUserGroup)
        self.registerRoleField.setText("")
        self.registerRoleField.setReadOnly(False)
        self.registerRoleField.setObjectName("registerRoleField")
        self.horizontalLayout.addWidget(self.registerRoleField)

        self.registerUserBtn = QtGui.QPushButton(self.registerNewUserGroup)
        self.registerUserBtn.setObjectName("registerUserBtn")
        self.horizontalLayout.addWidget(self.registerUserBtn)
        
        self.verticalLayout_2.addWidget(self.registerNewUserGroup)

        MainWindow.setCentralWidget(self.centralWidget)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(_translate("MainWindow", "Admin Panel", None, _utf8))
        self.activeDomainLbl.setText(_translate("MainWindow", " => DOMAIN : ", None, _utf8))

        self.tableWidget.setSortingEnabled(True)
        __sortingEnabled = self.tableWidget.isSortingEnabled()
        self.tableWidget.setSortingEnabled(False)
        self.tableWidget.setSortingEnabled(__sortingEnabled)
        
        self.registerDomainNameGroup.setTitle(_translate("MainWindow", "Register/Update Domain", None, _utf8))
        self.registerDomainNameField.setPlaceholderText(_translate("MainWindow", "domain name", None, _utf8))
        self.registerDomainBtn.setText(_translate("MainWindow", "Register", None, _utf8))
        self.registerNewUserGroup.setTitle(_translate("MainWindow", "Register New User", None, _utf8))
        self.registerNameField.setPlaceholderText(_translate("MainWindow", "name", None, _utf8))
        self.registerAccountNameField.setPlaceholderText(_translate("MainWindow", "account name", None, _utf8))
        self.registerRoleField.setPlaceholderText(_translate("MainWindow", "role", None, _utf8))
        self.registerUserBtn.setText(_translate("MainWindow", "Register", None, _utf8))
