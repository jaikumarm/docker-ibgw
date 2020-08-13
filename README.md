Dockerized IB Gateway and IBC with xvfb and novnc for remote viewing
=======================
[![CircleCI](https://circleci.com/gh/jaikumarm/docker-ibgw.svg?style=svg)](https://circleci.com/gh/jaikumarm/docker-ibgw)

See [CHANGELOG](./CHANGELOG.md) for a list of notable changes

Usage
-----
Clone this repository and build the image:
```
git clone https://github.com/jaikumarm/docker-ibgw.git
cd docker-ibgw
docker build . -t docker-ibgw
```

Run your image with `docker run`
```
docker run \
    -e TWS_USER=CHANGEME \
    -e TWS_PASSWORD=CHANGEME \
    -e TWS_PORT=4001 \
    -e SOCAT_PROXY_PORT=4004 \
    -e TWS_LIVE_PAPER=paper \
    -p 4001:4001 -p 5901:5900 -p 8088:8080 \
    -v /var/log/ibgw:/opt/ibc/logs \
    -d docker-ibgw
```

With `docker-compose` edit the docker-compose.yml with your ib credentials, then run
```
docker-compose -f docker-compose.yml up -d ibgw
```

In docker logs of the container and you should see
```
...
2020-03-10 00:04:00,318 ib_insync.IBC DEBUG 2020-03-10 00:04:00:317 IBC: Detected frame entitled: IB Gateway.  API Account: xxxxxxx; event=Activated
2020-03-10 00:04:00,320 ib_insync.IBC DEBUG 2020-03-10 00:04:00:320 IBC: Detected dialog entitled: Uxxxxxxx Trader Workstation Configuration; event=Closed
2020-03-10 00:04:21,354 ib_insync.IBC DEBUG remove Client 10
...
```

If you see `ib_insync.IBC DEBUG remove Client 10.` it means its all good.

This is fairly a opinionated configuration based on my own needs, if you (don't) like it fork it!

Thanks!
-----
Thanks to the two projects without which this repo will likely not exist!
* https://github.com/IbcAlpha/IBC
* https://github.com/erdewit/ib_insync

Also some of the code is borrowed and/or inspired from in no particular order
* https://github.com/canada4663/ib_insyncDocker
* https://github.com/restis/ibc-docker
