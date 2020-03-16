try:
    from configparser import ConfigParser as cp
except ImportError:
    import ConfigParser as cp


class AttrDict(dict):
    def __init__(self, *args, **kwargs):
        super(AttrDict, self).__init__(*args, **kwargs)
        self.__dict__ = self

#ini vars
iniFile = "C:\\Users\\borko\\Dropbox\\Scripting\\maxscript\\4_Final stage\\ConfigLicenses.ini"
domainSection = 'DOMAIN'
domainName = 'PIXELPOOL'
usersSection = 'USERS'
adminsSection = 'ADMINS'
test = 'test23'

#methods
def initializeIni(config,iniFile):
    #write
    # config[domainSection] = {
    #     "name": domainName,
   
    if(config.has_section(domainSection) == False):
        config.add_section(domainSection)
        config.set(domainSection,"name",domainName)

    if(config.has_section(usersSection) == False):
        config.add_section(usersSection)

    if(config.has_section(adminsSection) == False):
        config.add_section(adminsSection)

        with open(iniFile,'w') as output_file:
            config.write(output_file)

config = cp(dict_type=AttrDict)

# read ini
config.read(iniFile)

#check
# isDomainexist = (domainSec in config)
hasDomainSect = config.has_section(domainSection)

if (hasDomainSect == True):
    
    #read
     isSectionempty = (config.items(domainSection) == [])
     if(isSectionempty == False):
         print(config.items(domainSection))

# #init ini file
initializeIni(config,iniFile)

# #remove
if (config.has_section(test)):
    config.remove_option(domainSection,'name')
    config.remove_section(test)

    with open(iniFile,'w') as output_file:
        config.write(output_file)

