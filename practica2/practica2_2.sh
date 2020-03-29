#!/bin/bash
#Alonso del Rincon de la Villa 783252
#Angel Oliveros Cartagena 698691

#$* todos los parametros
# ej: 1 "2 3" => 1 2 3

#"$*" todos los parametros juntos como unico parametro
#ej: 1 "2 3" => "1 2 3"

#$@: todos los parametros (se comporta igual que $*)
# ej: 1 "2 3" => 1 2 3 

#"$@": todos los parametros por respetando caracteres especiales
#ej: 1 "2 3" => 1 "2 3"

 for file in  "$@";
 do
	 #file exists and is regular: see man [
	 if [ -f "$file" ]; then
		 more "$file";
	 else
		 echo "$file no es un fichero";
	 fi;
 done;
