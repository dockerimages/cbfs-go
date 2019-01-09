# cbfsd-go
https://github.com/couchbase-fs/cbfs-go


Install
=======
```bash
docker run --rm -v /usr/local/bin:/install dockerimages/cbfsd-go cp -r ./* /install
docker run --rm -it -v /usr/local/bin:/install dockerimages/cbfsd-go /bin/cp -r /opt/cbfs/ /install

# -rwxr-xr-x    1 root     root       12.8M Mar 16  2015 cbfs
#-rwxr-xr-x    1 root     root       10.9M Mar 16  2015 cbfsclient
#drwxr-xr-x    2 root     root        4.0K Jan  9 10:24 monitor
# monitor
# -rw-r--r--    1 root     root      113.1K Mar 16  2015 d3.v2.min.js
# -rw-r--r--    1 root     root        1.1K Mar 16  2015 files.html
# -rw-r--r--    1 root     root        2.1K Mar 16  2015 files.js
# -rw-r--r--    1 root     root        1.6K Mar 16  2015 index.html
# -rw-r--r--    1 root     root       92.6K Mar 16  2015 jquery.min.js
# -rw-r--r--    1 root     root       11.8K Mar 16  2015 monitor.js


```




How do I run the stuff
======================

 wget https://gist.githubusercontent.com/tleyden/d70161c3827cb8b788a8/raw/8f6c81f0095b0007565e9b205e90afb132552060/cbfs_node.service.template



## Docker

```bash
/bin/bash -c 'ip=$(hostname -i | tr -d " ") \
  && /usr/bin/docker run \
  && --name cbfs -v /var/lib/cbfs/data:/var/lib/cbfs/data \
  && --net=host dockerimages/cbfsd-go \
  && cbfs -nodeID=$ip -bucket=cbfs -couchbase=http://$ip:8091/ -root=/var/lib/cbfs/data -viewProxy'
```


```
mkdir -p /tmp/localdata
./cbfs -nodeID=$mynodeid \
       -bucket=cbfs \
       -couchbase=http://$mycouchbaseserver:8091/
       -root=/tmp/localdata \
       -viewProxy
```

The server will be empty at this point, you can install the monitor
using cbfsclient (`go get github.com/couchbaselabs/cbfs/tools/cbfsclient`)

```
cbfsclient http://localhost:8484/ upload \
    $GOPATH/src/github.com/couchbaselabs/cbfs/monitor monitor
```

Then go to [http://localhost:8484/monitor/](http://localhost:8484/monitor/)



```
[Unit]
Description=cbfs_node

[Service]
TimeoutStartSec=1000
ExecStartPre=-/usr/bin/docker kill cbfs
ExecStartPre=-/usr/bin/docker rm cbfs
ExecStartPre=/usr/bin/docker pull tleyden5iwx/cbfs
ExecStart=/bin/bash -c 'ip=$(hostname -i | tr -d " ") && /usr/bin/docker run --name cbfs -v /var/lib/cbfs/data:/var/lib/cbfs/data --net=host tleyden5iwx/cbfs cbfs -nodeID=$ip -bucket=cbfs -couchbase=http://$ip:8091/ -root=/var/lib/cbfs/data -viewProxy'
ExecStop=/usr/bin/docker stop cbfs

[X-Fleet]
Conflicts=cbfs_node.*.service
```
