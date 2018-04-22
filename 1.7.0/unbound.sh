#! /bin/sh

reserved=12582912
availableMemory=$((1024 * $( (fgrep MemAvailable /proc/meminfo || fgrep MemTotal /proc/meminfo) | sed 's/[^0-9]//g' ) ))
if [ $availableMemory -le $(($reserved * 2)) ]; then
    echo "Not enough memory" >&2
    exit 1
fi
availableMemory=$(($availableMemory - $reserved))
msg_cache_size=$(($availableMemory / 3))
rr_cache_size=$(($availableMemory / 3))
nproc=$(nproc)
if [ $nproc -gt 1 ]; then
    threads=$(($nproc - 1))
else
    threads=1
fi

mkdir -p /opt/unbound/etc/unbound/unbound.conf.d/ && \
mkdir -p /opt/unbound/log/ && \
chown _unbound:_unbound /opt/unbound/log/

mkdir -p /opt/unbound/etc/unbound/dev && \
cp -a /dev/random /dev/urandom /opt/unbound/etc/unbound/dev/

mkdir -p -m 700 /opt/unbound/etc/unbound/var && \
chown _unbound:_unbound /opt/unbound/etc/unbound/var && \
/opt/unbound/sbin/unbound-anchor -a /opt/unbound/etc/unbound/var/root.key

exec /opt/unbound/sbin/unbound -d -c /opt/unbound/etc/unbound/unbound.conf
