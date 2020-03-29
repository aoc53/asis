#!/bin/bash
#Alfonso del Rincon de la Villa 783252
#Angel Oliveros Cartagena 698691


echo "Introduzca una tecla: ";

read input;
letter="${input:0:1}";

case "$letter" in
	[0-9])
		echo "$letter es un numero";;
	[a-zA-Z])
		echo "$letter es una letra";;
	*)
		echo "$letter es un caracter especial";;
esac

exit 0;
