#!/bin/bash

pastas=(`ls -F | grep "/"`)

for dir in "${pastas[@]}"
do
  echo "----------------------------------------"
  echo "atualizando o diretório $dir"
  cd $dir
  git pull -r
  cd ..
done

echo "-----------------------------------------"
echo "todos os diretórios foram atualizados"
