#!/bin/sh

. /etc/diag.sh
[ -f /lib/ranga/lib/mwan.sh ] && . /lib/ranga/lib/mwan.sh

ckev() {
	if [ "$1" = "0" ]; then	
		return
	fi

	logger -t ranga-flash "Flash firmware failed!!"
	rm -rf /tmp/_full
	rm -rf /tmp/_workdir
	/etc/init.d/uhttpd start
	exit 0
}

rm -rf /tmp/_full/patch.sh /tmp/_full/hooks

mwan_is_enabled && mwan3 stop
ifdown netkeeper
for i in `uci show network | grep "^network.md.*=interface$" | sed 's/^[^\.]*\.\([^=]*\)=.*/\1/g'`; do
	ifdown "$i"
done
/etc/init.d/uhttpd stop
/etc/init.d/odhcpd stop
/etc/init.d/dnsmasq stop
/etc/init.d/cron stop
set_state failsafe

ifconfig ra0 down
ifconfig rai0 down
wifi down

touch /etc/ranga/fullpackfail

if [ -f /etc/efc/.nswa ]; then
	cd /tmp
	ckev $?
	rm -rf _workdir
	mkdir -p _workdir/etc
	ckev $?
	cp -r /etc/efc/ _workdir/etc/
	ckev $?

	if [ ! -f /tmp/.fp_earse_configure ]; then
		cp -r /etc/config/ _workdir/etc/
		ckev $?

		uci -c _workdir/etc/config set wireless.radio0.disabled=1 > /dev/null 2>&1
		uci -c _workdir/etc/config set wireless.radio1.disabled=1 > /dev/null 2>&1
		uci -c _workdir/etc/config commit

		cp -r /etc/crontabs/ _workdir/etc/
		mkdir -p _workdir/etc/dnsmasq.d/
		cp /etc/dnsmasq.d/ipmac.conf _workdir/etc/dnsmasq.d/
		mkdir _workdir/etc/ranga
		cp /etc/ranga/def-resolv _workdir/etc/ranga
		cp -r /etc/ranga/ucibak _workdir/etc/ranga
		cp -r /etc/seth _workdir/etc/

		touch _workdir/etc/.ranga-upgrade
		ckev $?
		mwan_is_enabled && echo 'mwan-enable' >> _workdir/etc/.ranga-upgrade
		[ -x /lib/ranga/libexec/config/mtk ] && {
			/lib/ranga/libexec/config/mtk cur-mode | grep "rt2860" && echo "mtk-rt2860" >> _workdir/etc/.ranga-upgrade
		}
		/etc/init.d/odhcpd enabled && echo "odhcpd-enable" >> _workdir/etc/.ranga-upgrade
	fi

	tar czf efc.tar.gz . -C _workdir/
	ckev $?
	sysupgrade -f efc.tar.gz -n /tmp/_full/_fw.bin
	ckev $?
else
	sysupgrade -n /tmp/_full/_fw.bin
	ckev $?
fi
