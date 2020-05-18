#!/bin/bash
#783252, del Rincón de la Villa, Alonso, T, 1, B
#698691, Oliveros Cartagena, Ángel, M, 1, B

#volume group
grv="$1"

#second parameter becomes $1
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
	#will create the physical volume no mater its previous contents
	sudo pvcreate -f "$var" 
	sudo vgextend "$grv" "$var"
done
