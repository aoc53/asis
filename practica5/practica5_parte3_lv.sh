
#!/bin/bash
OldIFS=$IFS
IFS=,
read VolGroupName LogicVolName Size FileSysType MountDir
IFS=$OldIFS

#Buscamos el grupo volumen, si no esta no seguimos
sudo vgscan | grep "$VolGroupName"
if [ "$?" -ne 0 ]; then
	echo "error: volume group $VolGroupName not found"
	exit 1
fi
sudo lvscan | grep "$LogicVolName" &>/dev/null
if [ "$?" -eq 0 ]; then #Si lo encontramos solo extendemos
	echo "$LogicVolName found, extending..."
	DM=$(cat /etc/fstab | grep "$VolGroupName" | cut -d ' ' -f2 )
	echo "$DM"
	sudo umount "/dev/$VolGroupName/$LogicVolName" &>/dev/null
	sudo lvresize -L "+$Size" -r "/dev/$VolGroupName/$LogicVolName" #&>/dev/null 
	sudo mount "/dev/$VolGroupName/$LogicVolName" "$DM" &>/dev/null
	echo "Done"
else #sino creamos
	echo "$LogicVolName not found, creating..."
	sudo cat /proc/filesystems | grep "$FileSysType" &>/dev/null
	if [ "$?" -ne 0 ]; then
		echo "Error, file system not supported" 
		exit 1
	fi
	echo "file system correct"
	sudo mkdir -p "$MountDir"  &>/dev/null
	sudo lvcreate -L"$Size" -n "$LogicVolName" "$VolGroupName" #&>/dev/null
	echo "Done. Creating $FileSysType file system..."
	sudo mkfs -t "$FileSysType" "/dev/$VolGroupName/$LogicVolName" #&>/dev/null
	sudo mount "/dev/$VolGroupName/$LogicVolName" "$MountDir" &>/dev/null
	cat /etc/fstab | grep "dev/$VolGroupName/$LogicVolName" &>/dev/null
	if [ "$?" -ne 0 ]; then
		echo "/dev/$VolGroupName/$LogicVolName $MountDir $FileSysType defaults 0 0" | sudo tee -a /etc/fstab &>/dev/null
	fi
	echo "Done"
fi

