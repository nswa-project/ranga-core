#!/bin/sh

a=`uci show mwan3 | grep 'md[a-zA-Z0-9]*=interface' | sed 's/^[^\.]*\.\(md[^=]*\)=.*/\1/g'`
a=`echo -n "$a" | tr '\n' ' '`
uci set firewall.@zone[1].network="wan netkeeper ${a}"
uci commit firewall
