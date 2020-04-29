#!/bin/sh

[ `uci get nswa.flags.enable_early_dial` != "1" ] && exit

if [ `uci get network.netkeeper.username` = '' ]; then
	logger -t earlydial "blank netkeeper username blocked earlydial"
	exit 0
fi

${NSWA_PREFIX}/libexec/waitrun 0 ${NSWA_PREFIX}/libexec/earlydial &
exit 0
