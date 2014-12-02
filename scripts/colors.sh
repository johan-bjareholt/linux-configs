#!/usr/bin/env bash
function printcolor(){
	printf "\x1b[38;5;$1mcolor$1 $2"
}

for i in {0..25} ; do
    for l in {0..10} ; do
		if (( l == 9 )) ; then
			ending="\n"
		else
			ending="   \t"
		fi
		printcolor $((i*10+l)) $ending
	done
done
