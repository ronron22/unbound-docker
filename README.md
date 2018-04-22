# Unbound DNS Server Docker Image

From MatthewVance/unbound-docker, i add

* unbound-control for driving the main process
* some configuration files for forward to autoritative server, etccetera
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
docker run --name myunbound -d -p 53:53/udp  -p 127.0.0.1:8953:8953/udp -v /root/workspace/unbound-docker/1.7.0/conf.d:/opt/unbound/etc/unbound/unbound.conf.d --restart=always myunbound:latest 
```

## troubleshooting

```bash
docker logs instance
```

reload

```bash
docker exec -it instance bash kill -HUP 1
```
