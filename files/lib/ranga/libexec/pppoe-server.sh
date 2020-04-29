#!/bin/sh

poll_link_status() {
	local n='0'
	while true ; do
		sleep 1
		n=$(($n+1))

		if [ -d "/sys/class/net/${ifname}" ]; > /dev/null; then
			ipaddr=`ifconfig "$1" | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1`
			if [ -n "${ipaddr}" ]; then
				return 0
			fi
		fi

		if [ "$n" = "8" ]; then
			return 1
		fi
	done
}

name="${1}"
ifname="pppoe-${name}"

echo '1' > /tmp/nk4-stat

cat /dev/null > /tmp/pppoe.log
killall pppoe-server > /dev/null 2>&1
pppoe-server -k -I br-lan

echo '2' > /tmp/nk4-stat

a='0'
while true ; do
	username="`grep 'AuthReq' /tmp/pppoe.log | grep 'user=' | tail -n 1`"
	if [ -n "$username" ]; then
		echo '3' > /tmp/nk4-stat
		username="${username#*user=\"}"
		username="${username%\" password=\"*}"
		username="${username//\\\"/\"}"
		username="`echo -e "$username"`"

		ifdown "${name}"
		echo -n "$username" > /tmp/nk-override
		logger -t ranga-pppoe-server "${name} dial with username '${username}'"
		ifup "${name}"

		killall pppoe-server > /dev/null 2>&1

		if ! poll_link_status "${ifname}" ; then
			ifdown "$2"
		fi
		
		echo '4' > /tmp/nk4-stat
		break
	fi
	sleep 2

	a=$((${a}+1))
	if [ "$a" = 30 ]; then
		echo '5' > /tmp/nk4-stat
		break
	fi
done

rm /tmp/pppoe.log

killall pppoe-server > /dev/null 2>&1
