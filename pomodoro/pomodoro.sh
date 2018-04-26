#!/bin/bash

DUR_POMODORO=15 #São 25 minutos = 1500 segundos divididos por 100, é a taxa de porcentagem
INTERVALO_CURTO=3 # 5 minutos = 300 segundos
INTERVALO_LONGO=9 # 15 minuto = 900 segundos
AGUARDA_RESPOSTA=2m #aqui usa o sleep simples, então simplifica usando minutos mesmo
TAMANHO_JANELA=150
NOME="POMODORO"
CAMINHO_SOM_POMODORI=/usr/share/sounds/freedesktop/stereo/message-new-instant.oga
CAMINHO_SOM_POMODORO=/usr/share/sounds/freedesktop/stereo/complete.oga
CAMINHO_SOM_INTERVALO=/usr/share/sounds/freedesktop/stereo/suspend-error.oga 

pomodoro() {
	timer $DUR_POMODORO "Pomodoro" $1
	zenity --title=$NOME --notification --text="Acabou o pomodoro $1"
	paplay $CAMINHO_SOM_POMODORO 
}

intervalo() {
	timer $2 "Intervalo" $1
	paplay $CAMINHO_SOM_INTERVALO
	zenity --title=$NOME --notification --text="Acabou o intervalo $1" 

}

pomodori() {
	for pom in {1..4}
	do
		executa_timer pomodoro $pom

		if [ $pom -lt 4 ]
		then
			executa_timer intervalo  $pom $INTERVALO_CURTO 
		else
			executa_timer intervalo $pom $INTERVALO_LONGO 
		fi
	done
}

timer() {
	for ((i=0;i<=100;i+=1))
	do
		echo "$i"
		sleep $1
	done | zenity --progress --title=$NOME --text="$2 $3" --percentage="0" --auto-close --auto-kill
}

executa_timer() {
	if pergunta $1 $2
	then
		$1 $2 $3
	fi
}

pergunta() {
	if zenity --question --title=$NOME --width=$TAMANHO_JANELA --text="Você deseja ir para $1 $2?"
	then
		return 0
	fi

	sleep $AGUARDA_RESPOSTA
	pergunta $1 $2
}

main() {
	pomodori_atual=1
	total_pomodoris=$(zenity --entry --title=$NOME --width=$TAMANHO_JANELA --text="Quantos pomodori você quer?")

	while [ $pomodori_atual -le $total_pomodoris ]
	do
		zenity --title=$NOME --notification --text="Iniciando o pomodori $pomodori_atual"
		paplay $CAMINHO_SOM_POMODORI 

		pomodori

		pomodori_atual=$(( $pomodori_atual + 1 ))
	done
}

main

