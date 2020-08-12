import os
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
ibcPath = os.getenv("IBC_PATH", "/opt/ibc")
homePath = os.getenv("HOME", "/root")
twsPath = os.getenv("TWS_PATH", "/root/Jts")
twsLiveorPaperMode = os.getenv("TWS_LIVE_PAPER", "paper") # live or paper
twsPort = os.getenv("TWS_PORT", "4001")
ibcConfigFile = ibcPath + "/config.ini"
twsConfigFile = twsPath + "/jts.ini"

logger.info("Updating config files")
updateIbcConfig(ibcConfigFile)
updateTwsConfig(twsConfigFile)

ibc = ibcontroller.IBC(
    twsVersion=978,
    gateway=True,
    ibcPath=ibcPath,
    tradingMode=twsLiveorPaperMode,
    twsSettingsPath=twsPath,
    ibcIni=ibcConfigFile,
)

ibc.start()
IB.run()