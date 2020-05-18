#!/bin/bash

#volume group
grv="$1"

#second parameter becomes $1
shift
part="$1"
shift

#search for the partition to add to de volume
sudo vgdisplay "$grv" > /dev/null
if [ "$?" -ne "0" ]; then
	exit 1
fi

for var in "$@"
do
	#unmount if mounted
	mount | grep "$var"
	if [ "$?" == "0" ]; then
		sudo umount "$var"
	fi
	
	#create physical volume and add to volume group
	sudo pvcreate "$var"
	sudo vgextend "$grv" "$var"
done
