#!/bin/sh

WAN=`uci get network.wan.ifname`
nrvl=`uci get nswa.misc.rvlan`

[ "$nrvl" -gt '0' ] || exit 0

nrvl=$((${nrvl}-1))

for i in `seq 0 ${nrvl}` ; do
	[ -d "/sys/class/net/vlan$i" ] && continue
	ip link add link "${WAN}" name "vlan$i" type macvlan
	[ "$?" != "0" ] && exit 1
done

exit 0
