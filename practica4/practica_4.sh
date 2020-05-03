#!/bin/bash

#Autores:
#   -Alonso del Rincón de la Villa (783252)
#   -Ángel Oliveros Cartagena (698691)

backup_dir="/extra/backup"
ssh_key="~/.ssh/id_as_ed26619"
ssh_user="as"
ssh_port="22"

if [ $# -ne 3 ]; then
	echo "Numero incorrecto de parametros"
	exit 1;
fi;

function check_backup_dir (){
	if [ ! -d "$backup_dir" ]; then
		mkdir -p "$backup_dir";
	fi;
}

function delete_user (){
	user=$(echo $1 | cut -d, -f1);
	#Get info about user to delete from /etc/passwd
	info=$(ssh -n -i "$ssh_key" "$ssh_user"@"$2" "cat /etc/passwd" | grep -e "^$user:");
	if [ -z "$info" ]; then
		echo "$user no es un usuario";
	else
		home_dir=$(echo $info | cut -d: -f6 &2> /dev/null);
		ssh -n -i "$ssh_key" "$ssh_user"@"$2" "sudo usermod -i 1 -L '$user'";
		ssh -n -i "$ssh_key" "$ssh_user"@"$2" "sudo pkill -9 -u '$user'";
		ssh -n -i "$ssh_key" "$ssh_user"@"$2" "sudo tar -zcf '$user'.tar '$home_dir'" &> /dev/null;
		if [ $? -eq 0 ]; then
                	ssh -n -i "$ssh_key" "$ssh_user"@"$2" "mv -f '$user'.tar '$backup_dir'";
                	ssh -n -i "$ssh_key" "$ssh_user"@"$2" "sudo userdel -r '$user'" &> /dev/null;
                	echo "usuario $name eliminado";
		fi;
	fi;
}

function add_user(){
	echo "add_user $1"
	user=$(echo $1 | cut -d, -f1)
	password=$(echo $1 | cut -d, -f2)
	name_user=$(echo $1 | cut -d, -f3)
	if [ $user = "" ] && [ $password = "" ] && [ $name_user = "" ]
	then
		echo "Campo invalido" 1>&2
		exit
	fi
	ssh -n -i "$ssh_key" "$ssh_user"@"$2" "grep -e '^$user:' /etc/passwd" > /dev/null;
	if [ $? -ne 0 ]
	then
		ssh -n -i "$ssh_key" "$ssh_user"@"$2" "sudo useradd '$user' -c '$name_user' -f 30 -K UID_MIN=1815 -U -k /etc/skel -m"
		ssh -n -i "$ssh_key" "$ssh_user"@"$2" "echo '$user':'$password' | sudo chpasswd"
		echo "$name_user ha sido creado"
	else
		echo "El usuario "$user" ya existe"
	fi
}

if [ "$1" = "-a" ]; then
	function="add_user";
elif [ "$1" = "-s" ]; then
	function="delete_user";
else
	echo "Opcion invalida" 1>&2;
fi;

if [ ! -r "$2" ]; then
	exit 3;
fi;
cat "$3" | while read address;
do
	#Check if address and port are available
	if $(nc -z "$address" "$ssh_port" "$ssh_port" > /dev/null); then
		echo "$address alcanzable"
		cat "$2" | while read row;
		do
			echo "bucle $row";
			$function "$row" "$address";
		done;
	else
		echo "$address no alcanzable"
	fi
done;
