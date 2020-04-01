import os
import fileinput

def updateIbcConfig(configFile):

    if os.environ.get('TWS_USER', False):
        userName = os.environ['TWS_USER']
    else:
        raise Exception("ERROR: No IB Username Set")

    if os.environ.get('TWS_PASSWORD', False):
        userPassword = os.environ['TWS_PASSWORD']
    else:
        raise Exception("ERROR: No IB Password Set")

    with fileinput.FileInput(configFile, inplace=True) as file:
        for line in file:
            line = line.replace('{ib_user}', userName)
            line = line.replace('{ib_password}', userPassword)
            print(line, end='')

    return

def updateTwsConfig(configFile):

    with fileinput.FileInput(configFile, inplace=True) as file:
        for line in file:
            if os.environ.get('TWS_PORT', False):
                twsPort = os.environ['TWS_PORT']            
                line = line.replace('LocalServerPort=4001', 'LocalServerPort=%d' % int(twsPort))
            print(line, end='')

    return    
