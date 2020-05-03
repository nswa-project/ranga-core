#!/bin/sh

_info() {
	echo "[upgrade] $1" >> /tmp/sysupgrade.log
}

errquit() {
	_info "error: $1"
	rm -rf /tmp/nswafw/
	exit 0
}

reboot="$1"

_info "Unpacking firmware..."
rm -rf /tmp/nswafw/
tar xzf /tmp/nswa-patch.tar.gz ./nswafw -C /tmp > /dev/null
rm /tmp/nswa-patch.tar.gz

[ -d "/tmp/nswafw" ] || errquit "firmware invalid"

_info "Installing..."

[ -f /tmp/nswafw/basevcn-osv ] || errquit "This patch is NOT suitable for current NSWA Ranga systems (Open-source versions)"
package_basevcn=`head -1 /tmp/nswafw/basevcn-osv`
best_basevcn='1'
[ "$package_basevcn" -lt "$best_basevcn" ] && errquit "This patch is NOT suitable for current NSWA Ranga systems (Open-source versions)"

[ -f /tmp/nswafw/noreboot ] && reboot='0'

/tmp/nswafw/patch.sh >> /tmp/sysupgrade.log
[ "$?" != "0" ] && errquit "Patcher exited with unhandled error(s)."
_info "Patcher exited, no errors reported."

rm -rf /tmp/nswafw/

if [ "$reboot" = "1" ]; then
	_info "Rebooting..."
	(sleep 2; reboot) < /dev/null > /dev/null 2>&1 &
fi

exit 0
