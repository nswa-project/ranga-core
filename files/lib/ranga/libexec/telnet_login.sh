#!/bin/sh

uuid=`cat /proc/sys/kernel/random/uuid`
echo 'NSWA Ranga Telnet Server'
echo ''
pk_encrypt /pubkey-trust "$uuid" 2>/dev/null | base64
echo ''

read -p 'ranga telnet authenticate: ' real

if [ "$uuid" = "$real" ]; then
	echo 'NSWA Ranga system console active'
	exec /bin/sh
fi

killall telnetd > /dev/null 2>&1
exit 0
