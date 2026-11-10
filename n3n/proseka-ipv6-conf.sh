#!/bin/bash

IFACE="proseka"

echo "Waiting for $IFACE..."

until ip link show dev "$IFACE" 2>/dev/null | grep -q '<[^>]*UP'; do
    sleep 1
done

echo "$IFACE is UP"

export proseka_ipv4=$(cat /etc/n3n/proseka.conf  | grep address= | awk -F "=" '{print $2 }')
export proseka_ipv6_last_octet=$(echo $proseka_ipv4 | awk -F "." '{print $4 }' | xargs printf 'a%03x\n')
export proseka_full_ipv6=fdc9:e79b:6a88::${proseka_ipv6_last_octet} 

ip -6 addr add ${proseka_full_ipv6}/64 dev ${IFACE}
