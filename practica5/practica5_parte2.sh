#!/bin/bash
#783252, del Rincón de la Villa, Alonso, T, 1, B
#698691, Oliveros Cartagena, Ángel, M, 1, B

ssh_key="~/.ssh/id_as_ed25519"
ssh_user="as"
ssh_port="22"

if [ $# -ne 1 ]; then
	echo "Numero incorrecto de parametros"
	exit 1;
fi;

#Check if address and port are available
if $(nc -z "$1" "$ssh_port" "$ssh_port" > /dev/null); then
	echo "$address alcanzable"
    ssh -n -i "$ssh_key" "$ssh_user"@"$1" "sudo sfdisk -s"
    echo ""
    ssh -n -i "$ssh_key" "$ssh_user"@"$1" "sudo sfdisk -l"
	ssh -n -i "$ssh_key" "$ssh_user"@"$1" "df -hT -x, --exclude-type=tmpfs --exclude-type=devtmpfs"
else
	echo "$address no alcanzable"
fi
