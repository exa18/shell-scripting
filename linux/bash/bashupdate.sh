#!/bin/bash
#
sudo ls >/dev/null

readarray -t arr <<< $(ls -1 /home)

lc=${#arr[@]}

if [ $lc -gt 1 ]; then
	for i in "${arr[@]}"; do
		if [ ${i} != "${USER}" ]; then
			sudo cp ~/.bashrc "/home/${i}/"
			sudo cp ~/.bash_aliases "/home/${i}/"
		fi
	done
fi

	sudo cp ~/.bashrc "/root/"
	sudo cp ~/.bash_aliases "/root/"

