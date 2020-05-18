#!/bin/bash
#783252, del Rincón de la Villa, Alonso, T, 1, B
#698691, Oliveros Cartagena, Ángel, M, 1, B

#read params: change separator to ","
OldIFS=$IFS;
IFS=','
read VolGroupName LogicVolName Size FileSysType MountDir;
IFS=$OldIFS;

#check volume group exists before continuing
sudo vgdisplay "$VolGroupName" &> /dev/null
if [ "$?" -ne 0 ]; then
	echo "error: volume group $VolGroupName not found"
	exit 1
fi

#check logic volume exists
sudo lvdisplay "$LogicVolName" &>/dev/null
if [ "$?" -eq 0 ]; then #Volume exists, resize
	echo "$LogicVolName found, extending..."
	DM=$(cat /etc/fstab | grep "$VolGroupName" | cut -d ' ' -f2 )
	echo "$DM"
	#unmount before resizing
	sudo umount "/dev/$VolGroupName/$LogicVolName" &>/dev/null
	sudo lvresize -L "+$Size" -r "/dev/$VolGroupName/$LogicVolName" #&>/dev/null 
	sudo mount "/dev/$VolGroupName/$LogicVolName" "$DM" &>/dev/null
	echo "Done"
else #Volume doesn't exist, create
	echo "$LogicVolName not found, creating..."
	#Check filesystem is supported
	sudo cat /proc/filesystems | grep "$FileSysType" &>/dev/null
	if [ "$?" -ne 0 ]; then
		echo "Error, file system not supported" 
		exit 2
	fi
	echo "file system correct"
	sudo mkdir -p "$MountDir"  &>/dev/null
	sudo lvcreate -L"$Size" -n "$LogicVolName" "$VolGroupName" #&>/dev/null
	#Don't continue if something failed when creating the volume
	if [ "$?" -ne "0" ]; then
		echo "Error, something went wrong creating the volume";
		exit 3;
	fi
	echo "Done. Creating $FileSysType file system..."
	#create directory, file system and mounting
	sudo mkdir -p "$MountDir" &>/dev/null
	sudo mkfs -t "$FileSysType" "/dev/$VolGroupName/$LogicVolName" #&>/dev/null
	sudo mount "/dev/$VolGroupName/$LogicVolName" "$MountDir" &>/dev/null

	cat /etc/fstab | grep "dev/$VolGroupName/$LogicVolName" &>/dev/null
	if [ "$?" -ne 0 ]; then
		echo "/dev/$VolGroupName/$LogicVolName $MountDir $FileSysType defaults 0 0" | sudo tee -a /etc/fstab &>/dev/null
	fi
	echo "Done"
fi

