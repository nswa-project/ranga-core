#!/bin/bash

for i in `ls ../feefs-patches/`; do
	patch -p1 < "../feefs-patches/$i"
done
