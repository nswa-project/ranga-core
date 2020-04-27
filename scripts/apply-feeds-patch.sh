#!/bin/bash

cd openwrt || exit 1

for i in `ls ../feefs-patches/`; do
	patch -p1 < "../feefs-patches/$i"
done
