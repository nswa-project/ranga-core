#!/bin/bash

for i in ../feeds-patches/*.patch; do
	echo "Applying $i"
	patch -p1 < "$i"
done
