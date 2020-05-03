#!/bin/bash

BASEDIR=$(dirname "$0")
OUTPUT_NAME="${2:-nswafw.bin}"
OPENWRT_IMG="$1"

fwdir='/tmp/nswa_mkfw_workdir/nswafw'
workdir="/tmp/nswa_mkfw_workdir"

dlurl_prefix="https://tienetech.tk/nswa/full/${CHANNEL}"

rm -rf "$workdir"
mkdir -p "$workdir"
cp -r "$BASEDIR/nswafw_fullpack" "$fwdir"
###FIXME echo ... > "$fwdir/model"
cp "$OPENWRT_IMG" "$fwdir/_fw.bin"
echo '1' > "$fwdir/basevcn-osv"

(cd "${fwdir}"; tar czvf "${workdir}/nswaupd.tar.gz" "." --transform "s/^\./.\/nswafw/" --owner 0 --group 0)
mv "${workdir}/nswaupd.tar.gz" "$OUTPUT_NAME"
