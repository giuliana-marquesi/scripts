#!/bin/bash

instala_dependencias() {
	#Instalando as dependencias, se necessário
	if which $1
	then
		echo "$1 já está instalado"
	else
		if ! $c_instalador $1
		then
			echo "não foi possível instalar $1!"
			exit 1
		fi
		echo "$1 foi instalado com sucesso"
	fi
}

permissiona() {
	chmod 644 pomodoro.desktop
	chown root pomodoro.desktop
	chmod 751 pomodoro.sh
	chwon $USER pomodoro.sh
	chmod 644 pomodoro.png
	chwon $USER pomodoro.png
}

echo "Qual é a base da distribuição?"
read base_distro

if [ $base_distro == "debian" ]
then
	c_instalador="sudo apt-get install -y"
	# atualizando no debian
	echo "			----- "
	echo "Atualizando antes das instalações"
	echo " "
	echo Atualizando repositórios..
	if ! sudo apt-get update
	then
    	echo "Não foi possível atualizar os repositórios. Verifique seu arquivo /etc/apt/sources.list"
    	exit 1
	fi
	echo "Atualização feita com sucesso"
	#
	echo "Atualizando pacotes já instalados"
	if ! sudo apt-get dist-upgrade -y
	then
    	echo "Não foi possível atualizar pacotes."
	    exit 1
	fi
	echo "Atualização de pacotes feita com sucesso"
elif [ $base_distro == "arch" ]
then
	c_instalador="pacman -S --noconfirm"
	# atualizando no arch
	echo "			----- "
	echo "Atualizando antes das instalações"
	echo " "
	if ! sudo pacman -Syu --noconfirm
	then
		echo "Não foi possível atualizar os repositórios. Verifique seu arquivo /etc/apt/sources.list"
    	exit 1
	fi
	echo "Atualização feita com sucesso"
else
	echo "			+++++ "
	echo "Não é nenhuma das opções: debian ou arch"
	echo " "
	exit
fi

instala_dependencias zenity
instala_dependencias paplay

if ! permissiona
then
	echo "Não foi possível modificar as permissões dos arquivos"
fi

if ! mkdir /opt/pomodoro
then
	echo "Não foi possível criar a pasta pomodoro no caminho /opt/"
	exit 1
fi
if ! mv pomodoro.png pomodoro.sh /opt/pomodoro/
then
	echo "Não foi possível mover os arquivos pomodoro.png e pomodoro.sh para o caminho /opt/pomodoro"
	exit 1
fi
if ! mv pomodoro.desktop /usr/share/applications/
then
	echo "Não foi possível mover o arquivo pomodoro.desktop para o caminho /usr/share/applications"
	exit 1
fi
