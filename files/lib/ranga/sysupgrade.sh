#!/bin/sh

key="09810395519ba0fe"

denc() {
	aescrypt2 1 "$1" "$2" "$key" >/dev/null 2>&1
}

_info() {
	echo "[upgrade] $1" >> /tmp/sysupgrade.log
}

errquit() {
	_info "error: $1"
	rm -rf /tmp/nswafw/
	exit 0
}

reboot="$1"

_info "Decoding firmware..."
denc /tmp/nswaup.bin /tmp/nswaup.tar
rm -f /tmp/nswaup.bin

_info "Parsing firmware metadata..."
tar xvf /tmp/nswaup.tar -C /tmp > /dev/null
rm -f /tmp/nswaup.tar

[ -f "/tmp/nswaupd.tar.gz.sig" ] || errquit "firmware invalid"
[ -f "/tmp/nswaupd.tar.gz" ] || errquit "firmware invalid"

_info "Checking data integrity..."
pk_verify /pubkey-trust /tmp/nswaupd.tar.gz > /dev/null 2>&1
if [ "$?" != "0" ]; then
	errquit "firmware verify failed"
fi

_info "Unpacking firmware..."
rm -rf /tmp/nswafw/
tar xzvf /tmp/nswaupd.tar.gz -C /tmp > /dev/null

[ -d "/tmp/nswafw" ] || errquit "firmware invalid"

rm -f /tmp/nswaupd.tar.gz.sig
rm -f /tmp/nswaupd.tar.gz
_info "Installing..."

#if ! [ -f /tmp/nswafw/ranga_r2 ]; then
#	errquit "This patch is NOT suitable for NSWA 4.x Ranga systems"
#fi
#if [ "`cat /tmp/nswafw/ranga_r2 2>/dev/null`" != "3" ]; then
#	errquit "This patch is NOT suitable for current NSWA 4.x Ranga systems"
#fi
[ -f /tmp/nswafw/basevcn ] || errquit "This patch is NOT suitable for current NSWA Ranga systems"
package_basevcn=`head -1 /tmp/nswafw/basevcn`
best_basevcn='4'
[ "$package_basevcn" -lt "$best_basevcn" ] && errquit "This patch is NOT suitable for current NSWA Ranga systems"

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
