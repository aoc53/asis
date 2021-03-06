#!/bin/bash

#Autores:
#   -Alonso del Rincón de la Villa (783252)
#   -Ángel Oliveros Cartagena (698691)

backup_dir="/extra/backup"

if [ $EUID -ne 0 ]; then
	echo "Este script necesita privilegios de administracion";
	exit 1;
fi;
if [ $# -ne 2 ]; then
	echo "Numero incorrecto de parametros"
	exit 2;
fi;
if [ ! -d "$backup_dir" ]; then
	mkdir -p "$backup_dir";
fi;
function delete_user (){
	user=$(echo $1 | cut -d, -f1);
	#Get info about user to delete from /etc/passwd
	info=$(cat /etc/passwd | grep -e "^$user:");
	if [ -z "$info" ]; then
		echo "$user no es un usuario";
	else
		home_dir=$(echo $info | cut -d: -f6 &2> /dev/null);
		usermod -i 1 -L "$user";
		pkill -9 -u "$user";
		tar -zcf "$user".tar "$home_dir" &> /dev/null;
		if [ $? -eq 0 ]; then
                	mv -f "$user".tar "$backup_dir";
                	userdel -r "$user" &> /dev/null;
                	echo "usuario $name eliminado";
		fi;
	fi;
}

function add_user(){
	user=$(echo $1 | cut -d, -f1)
	password=$(echo $1 | cut -d, -f2)
	name_user=$(echo $1 | cut -d, -f3)
	if [ $user = "" ] && [ $password = "" ] && [ $name_user = "" ]
	then
		echo "Campo invalido" 1>&2
		exit
	fi
	grep ^"$user": /etc/passwd > /dev/null; 
	if [ $? -ne 0 ]
	then
		useradd "$user" -c "$name_user" -f 30 -K UID_MIN=1815 -U -k /etc/skel -m 
		echo "$user:$password" | chpasswd
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

cat "$2" | while read row;
do
	$function "$row";
done;
