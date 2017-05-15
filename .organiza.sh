#!/bin/bash

arquivos=(`ls -p | grep -v "/"`)
var=0

for arq in ${arquivos[@]}
do
	echo "-------------------------------------------------"
	echo "   trabalhando com o arquivo $arq"
	echo "-------------------------------------------------"
	dir=`echo $arq | cut -c1-3`
	novo_nome=`echo $arq | cut -d- -f2-`

	echo "busca pelo diretório $dir"
	if [ -e $dir ]
	then
		echo "achou diretorio"
		echo "alterado o arquivo para o nome: $novo_nome"
		mv $arq $novo_nome
		echo "movido $novo_nome para $dir"
		mv $novo_nome $dir
	else
		echo "criando diretorio $dir"
		mkdir $dir
		echo "alterando o arquivo para o nome: $novo_nome"
		mv $arq $novo_nome
		echo "movido $novo_nome para $dir"
		mv $novo_nome $dir
	fi
done
