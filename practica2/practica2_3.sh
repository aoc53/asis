#! /bin/bash

#Autores:
#   -Alonso del Rincón de la Villa (783252)
#   -Ángel Oliveros Cartagena (698691)

if [ $# -eq 1 ]     #se comprueba si el número de argumetos es 1
then
    if [ "$(stat "$1" --printf=%F)" = "fichero regular" ] && [ -e "$1" ]    #se comprueba si stat dice que es un fichero 
                                                                            #regular y si existe
    then
        chmod go+x "$1"            #de ser así, se da permiso de ejecución al grupo y propietario del fichero
        stat "$1" --printf=%A      #se stat imprime por la salida estandar los permisos
        echo                       #(salto de linea)
    else
        echo "$1" "no existe"      #si no existe como fichero regular se comunica por la salida estandar 
    fi
else
    echo "Sintaxis: practica2_3.sh <nombre_archivo>"        #si se pasa un número de argumentos distinto de 1 
                                                            #se comunica por la salida estandar la sintaxis de 
                                                            #la ejecución del script
fi