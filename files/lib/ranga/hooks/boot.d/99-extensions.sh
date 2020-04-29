#!/bin/sh

token=`dd if=/dev/urandom bs=10 count=1`
token=`echo "$token" | sha256sum`
token=${token%% *}
echo -n "${token}" > /tmp/ranga_etoken

mkdir /tmp/_ext
chown 1000:1000 /tmp/_ext

${NSWA_PREFIX}/libexec/su 1000 /extensions/ranga.ext.base/update-caches.sh

${NSWA_PREFIX}/libexec/extensions-hook "boot"
exit 0
