#!/bin/sh

_info() {
	echo "[patch] $1"
	logger -t nswa-upgrade-script "$1"
}

rm -f /tmp/nswafw/basevcn-osv
rm -rf /tmp/_full

#model=`cat /tmp/nswafw/model`
#cur=`cat /tmp/sysinfo/model`

#if [ "$model" = "$cur" ]; then
	_info "Fullpack patching util started..."

	if [ ! -f /tmp/.fp_earse_configure ]; then
		for i in `ls /tmp/nswafw/hooks/`; do
			echo "hook: run $i"
			"/tmp/nswafw/hooks/$i" /tmp/nswafw
			if [ "$?" != "0" ]; then
				echo "hook '$i' failed, upgrade mode disabled,"
				echo "patcher will failback to reinstall mode."
				touch /tmp/.fp_earse_configure
				break
			fi
		done
	fi

	mv /tmp/nswafw /tmp/_full
	
	echo "Installation is starting, please wait for rebooting"

	if [ -f /tmp/.fp_earse_configure ]; then
		echo "WARN => reinstall actived, configurations will be earsed."
		echo "WARN => reinstall actived, configurations will be earsed."
		echo "WARN => reinstall actived, configurations will be earsed."
		echo "After reboot, navigate to webcon-gate (http://192.168.1.1/)."
	else
		echo "After reboot, try webcon-gate (http://192.168.1.1/ if you not change LAN bridge IP)."
	fi


	(sleep 3; /tmp/_full/flashfw.sh) < /dev/null > /dev/null 2>&1 1000>&1 &
	exit 0
#fi

#rm -rf /tmp/nswafw
#_info "Wrong firmware, your device is '$cur', but the firmware is for '$model'"
#_info "Installation aborted"

#exit 0
