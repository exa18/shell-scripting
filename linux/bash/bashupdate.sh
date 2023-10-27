#!/bin/bash
#
sudo ls >/dev/null

# list users with id 1000-1999 and if user info is filled
readarray -t arr <<< "$(awk -F: '{if ($3>999 && $3<2000 && length($5)>0) print $1}' /etc/passwd)"

lc=${#arr[@]}

if [[ $lc -gt 1 ]]; then
	for i in "${arr[@]}"; do
		if [[ ${i} != "${USER}" ]]; then
			d="/home/${i}/"
			if [[ -d "${d}" ]]; then
				sudo cp ~/.bashrc "${d}"
				sudo cp ~/.bash_aliases "${d}"
				sudo chown -f $i:$i "${d}.bashrc"
				sudo chown -f $i:$i "${d}.bash_aliases"
				sudo chmod g=rw "${d}.bashrc"
				sudo chmod g=rw "${d}.bash_aliases"
			fi
		fi
	done
fi

	sudo cp ~/.bashrc "/root/"
	sudo cp ~/.bash_aliases "/root/"

