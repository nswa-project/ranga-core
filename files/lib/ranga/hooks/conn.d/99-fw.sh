#!/bin/sh

[ `uci get nswa.flags.enable_captive_portal` != "1" ] && exit

iptables -t nat -D PREROUTING -p tcp ! -d 192.168.1.1 --dport 80 -j REDIRECT --to-ports 81
exit 0
