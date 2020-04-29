#!/bin/sh
[ `uci get nswa.flags.enable_captive_portal` != "1" ] && exit

ip=`uci get network.lan.ipaddr`
[ -z "$ip" ] && ip = "192.168.1.1"

${NSWA_PREFIX}/captive/captive stop
iptables -t nat -D PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -D PREROUTING -p tcp ! -d "$ip" --dport 80 -j REDIRECT --to-ports 81
exit 0
