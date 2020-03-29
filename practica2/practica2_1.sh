#! /bin/bash

#Autores:
#   -Alonso del Rincón de la Villa (783252)
#   -Ángel Oliveros Cartagena (698691)

r="r"           #
w="w"           #se guardan los distintos caracteres a concatenar con el mensaje
x="x"           #que se imprimirá en variables para hacer posible la concatenación
SinPermiso="-"  #
read fichero        #se lee de la entrada estandar el nombre del fichero a comprobar sus permisos 
                    #y se guarda en una variable

mensaje="Los permisos del archivo "$fichero" son: "     #se guarda en una variable el mensaje a mostrar

if [ -e "$fichero" ]        #se comprueba la existencia del fichero
then
    if [ -r "$fichero" ]                #si el fichero tiene permisos de lectura
    then
        mensaje=$mensaje$r              #se concatena r
    else
        mensaje=$mensaje$SinPermiso     #si no, se concatena - al mensaje
    fi
    if [ -w "$fichero" ]                #si el fichero tiene permisos de escritura
    then
        mensaje=$mensaje$w              #se concatena al mensaje w
    else
        mensaje=$mensaje$SinPermiso     #si no, se concatena -
    fi
    if [ -x "$fichero" ]                #si el fichero tiene permisos de ejecución
    then
        mensaje=$mensaje$x              #se concatena x al mensaje
    else
        mensaje=$mensaje$SinPermiso     #si no, se concatena -
    fi
    echo "$mensaje"                     #se imprime por la salida estandar el mensaje con todos sus permisos concatenados
else  
    echo "$fichero no existe"           #si no existe el fichero, se informa de ello por la salida estandar. 
fi