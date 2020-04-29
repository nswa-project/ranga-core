#!/bin/sh
num=`uci get nswa.misc.ttl_increase_number`
[ -z "${num}" -o "${num}" == "0" ] || {
	logger -t fw-hook "ttl increase to ${num}"
	iptables -t mangle -A PREROUTING -j TTL --ttl-inc "${num}"
}

flag=`uci get nswa.flags.allow_ipv6_inbound`
[ -z "${flag}" -o "${flag}" == "0" ] || {
	logger -t fw-hook 'allow ipv6 inbound'
	ip6tables -A forwarding_wan_rule -j zone_lan_dest_ACCEPT
}

exit 0
