#!/bin/bash

IFACE="proseka"

echo "Waiting for $IFACE..."

until ip link show dev "$IFACE" 2>/dev/null | grep -q '<[^>]*UP'; do
    sleep 1
done

echo "$IFACE is UP"
