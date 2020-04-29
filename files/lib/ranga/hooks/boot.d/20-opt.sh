#!/bin/sh

for i in `ls /etc/ranga/opt.rc.d`  ; do
	logger -t ranga-opt "starting opt service $i"
	"/etc/ranga/opt.rc.d/$i" start
done
exit 0
