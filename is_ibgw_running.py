import os
import sys
import time
import logging
import json
import base64
from ib_insync import ibcontroller
from ib_insync import IB
from ib_insync.ibcontroller import Watchdog
import ib_insync.util as util
from updateConfig import updateIbcConfig, updateTwsConfig

util.logToConsole(logging.DEBUG)
logger = logging.getLogger(name=__name__)
twsPort = os.getenv("TWS_PORT", "4001")

if __name__ == "__main__":

    ib = IB()

    ib.connect('127.0.0.1', twsPort, clientId=10)
    time.sleep(5)

    if not ib.isConnected():
        logging.debug('HEALTHCHECK: ib is not connected')
        sys.exit(1)
    else:
        logging.debug('HEALTHCHECK: ib is connected')
        sys.exit(0)