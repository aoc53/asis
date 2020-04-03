#!/bin/bash

#Autores:
#   -Alonso del Rincón de la Villa (783252)
#   -Ángel Oliveros Cartagena (698691)

echo "Introduzca el nombre de un directorio: "              #pregunta al usuario el nombre del directorio a inspeccionar
read directorio                                             #espera a que el usuario introduzca por la entrada estandar 
                                                            #el directorio
if [ "$(stat "$directorio" --printf=%F)" = "directorio" ]   #se comprueba en stat si es un directorio
then
    echo "El numero de ficheros y directorios en "$directorio" es de "$(ls -l "$directorio" | grep "^-" | wc -l)" y "$(ls -l "$directorio" | grep "^d" | wc -l)", respectivamente"
    #se saca por la salida estandar el número de 
    #lineas de la salida ls -l que empiezan por
    #- (ficheros) y el numero de lineas que 
    #empiezan por d (directorios)
else
    echo "$directorio" "no es un directorio"        #si stat dice que no es un directorio se 
                                                    #comunica por la salida estandar
fi