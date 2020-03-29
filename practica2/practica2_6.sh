#!/bin/bash
#Alonso del Rincon de la Villa 783252
#Angel Oliveros Cartagena 698691


#Get user home directory
if [ ! -r "/etc/passwd" ]; then
       echo "No permission to read user info";
       exit 1;
fi;

homeDir=$(cat "/etc/passwd" | grep -e "^$USER" | cut -d: -f6);

if [ ! -d "$homeDir" -o ! -w "$homeDir" ]; then
	echo "Unable to work on home directory";
      	exit 2;
fi;

#Get directory if exists
directory=$(find "$homeDir" -maxdepth 1 \
	| grep -E "/bin[0-9a-zA-Z]{3}$" \
	| xargs stat -c %Y,%n 2>/dev/null \
	| sort -g \
	| cut -d, -f2 \
	| head -n1)
#No matching directory / no access to write
if [ -z "$directory" -o ! -d "$directory" -o ! -w "$directory" ]; then
        #Directory doesn't exist, create it
	directory=$(mktemp -d --tmpdir="$homeDir" -t binXXX);
	if [ -d "$directory" ]; then
		echo "Se ha creado el directorio $directory";
	else
		echo "Unable to create directory $directory";
		exit 3;
	fi;
fi;

echo "Directorio destino de copia: $directory";

count=0
for file in $(ls -p | grep -v /); do
	cp -f "$file" "$directory";
	echo "./$file ha sido copiado a $directory"
	count=$(($count +1))
done;
if [ $count -gt 0 ]; then
	echo "Se han copiado $count archivos";
else
	echo "No se ha copiado ningun archivo";
fi;

exit 0;
