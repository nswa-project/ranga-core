#!/bin/sh

. ${NSWA_PREFIX}/lib/mwan.sh
mwan_is_enabled || exit

${NSWA_PREFIX}/libexec/create-rvlan.sh
logger -t wanup-hook "Reverse VLAN created, result: $?"

exit 0
