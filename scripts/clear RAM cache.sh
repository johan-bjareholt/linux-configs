#!/bin/bash
function clear_ram() {
	sudo echo 3 > sudo /proc/sys/vm/drop_caches
	sleep 5
}

while :
do
	clear_ram
done
