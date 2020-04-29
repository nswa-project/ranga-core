#!/bin/sh
[ "`uci get nswa.flags.enable_forever_nkserver`" != '1' ] && exit
pgrep -x -n scdiald && exit
exec -a scdiald pppoe-server -I br-lan -O /etc/ppp/scdial-options -k -x 1
