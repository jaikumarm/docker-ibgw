Dockerized IB Gateway and IBC with xvfb and novnc for remote viewing
=======================

See [CHANGELOG](./CHANGELOG.md) for a list of notable changes

Usage
-----
Clone this repository and build the image:
```
git clone https://github.com/jaikumarm/docker-ibc.git
cd docker-ibc
docker build . -t docker-ibc
```

Run your image with `docker run`
```
docker run \
    -e TWS_USER=CHANGEME \
    -e TWS_PASSWORD=CHANGEME \
    -e TWS_PORT=4001 \
    -e TWS_LIVE_PAPER=paper \
    -p 4001:4001 -p 5901:5900 -p 8088:8080 \
    -v /var/log/ibc:/var/log/ibc \
    -d docker-ibc
```

With `docker-compose` edit the docker-compose.yml with your ib credentials, then run
```
docker-compose -f docker-compose.yml up -d ibc
```

In docker logs of the container and you should see
```
...
2020-03-10 00:04:00,318 ib_insync.IBC DEBUG 2020-03-10 00:04:00:317 IBC: Detected frame entitled: IB Gateway.  API Account: xxxxxxx; event=Activated
2020-03-10 00:04:00,320 ib_insync.IBC DEBUG 2020-03-10 00:04:00:320 IBC: Detected dialog entitled: Uxxxxxxx Trader Workstation Configuration; event=Closed
2020-03-10 00:04:21,354 ib_insync.IBC DEBUG addLogConsole Client 10
...
```

If you see `ib_insync.IBC DEBUG addLogConsole Client 10.` it means it all good. 

Once the container is up, connect to http://localhost:8088 and 
* Uncheck Read-Only API

CAUTION: Any time you delete and/or recreate the container you will have to do the above step, I have not found a good way to automate this step, if you know of a way please feel free to open a issue or even better a pull request.

This is fairly a opinionated configuration based on my own needs, if you (don't) like it fork it!

Also some of the code is borrowed and/or inspired from in no particular order
* https://github.com/canada4663/ib_insyncDocker
* https://github.com/restis/ibc-docker
