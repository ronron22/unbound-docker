# Unbound DNS Server Docker Image

From MatthewVance/unbound-docker, i add

* unbound-control for driving the main process
* some configuration files for forward to autoritative server, etcetera
* dnstap support

## Tree

```bash
.
├── conf.d
│   ├── control.conf
│   ├── forward.conf
│   ├── logging.conf
│   └── minimal.conf
├── Dockerfile
├── unbound.conf
└── unbound.sh
```

## Build

```bash
docker build -t myunbound .
```

## run

```bash
docker run --name myunbound -d -p 53:53/udp  -p 127.0.0.1:8953:8953/udp -v \
/root/workspace/unbound-docker/1.7.0/conf.d:/opt/unbound/etc/unbound/unbound.conf.d --restart=always myunbound:latest 
```

## troubleshooting

```bash
docker logs instance
# ou
docker logs --tail 10 -t  89cdbc7caee4
```

```bash
docker export "instance" |tar x --to-stdout opt/unbound/etc/unbound/unbound.conf
```
## exploitation

### reload

```bash
docker exec -it instance bash kill -HUP 1
```

### limit number of requests, global and per ip

```bash
/opt/unbound/sbin/unbound-control set_option ratelimit: 1000
/opt/unbound/sbin/unbound-control set_option ip-ratelimit: 40
```

### get statistic 

```bash
/opt/unbound/sbin/unbound-control stats
...
thread0.recursion.time.avg=0.011461
total.num.queries=3875
total.num.queries_ip_ratelimited=1175
total.num.cachehits=3874
total.num.cachemiss=1
total.num.recursivereplies=1
...
```

### get forwarded

```bash
/opt/unbound/sbin/unbound-control list_forwards
unigo.fr. IN forward 172.17.0.1
mugairyu.fr. IN forward 172.17.0.1
opendns.io. IN forward 172.17.0.1
architux.com. IN forward 172.17.0.1
kartooch.com. IN forward 172.17.0.1
```

## benchmark 

Testing ratelimit

```bash
while true ; do sleep 0.1 ;  dig opendns.io  @ns1.architux.com ; done 
```
