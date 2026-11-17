#!/bin/bash

IFACE="proseka"

echo "Waiting for $IFACE..."

until ip link show dev "$IFACE" 2>/dev/null | grep -q '<[^>]*UP'; do
    sleep 1
done

echo "$IFACE is UP"

# Add a route for v6
export proseka_ipv4=$(cat /etc/n3n/proseka.conf  | grep address= | awk -F "=" '{print $2 }')
export proseka_ipv6_last_octet=$(echo $proseka_ipv4 | awk -F "." '{print $4 }' | xargs printf 'a%03x\n')
export proseka_full_ipv6=fdc9:e79b:6a88::${proseka_ipv6_last_octet} 

ip -6 addr add ${proseka_full_ipv6}/64 dev ${IFACE}

# Prevent Tailscale transport packets (fwmark 0x80000)
# from using proseka, avoiding recursive overlay routing.
iptables -C OUTPUT    -o proseka   -m mark --mark 0x80000/0xff0000   -j DROP || iptables -I OUTPUT 1   -o proseka   -m mark --mark 0x80000/0xff0000   -j DROP
ip6tables -C OUTPUT    -o proseka   -m mark --mark 0x80000/0xff0000   -j DROP || ip6tables -I OUTPUT 1   -o proseka   -m mark --mark 0x80000/0xff0000   -j DROP
