#!/bin/bash
#
sudo ls >/dev/null

# list users with id 1000-1999 and if user info is filled
readarray -t arr <<< "$(awk -F: '{if ($3>999 && $3<2000 && length($5)>0) print $1}' /etc/passwd)"

lc=${#arr[@]}
rc=".bashrc"
al=".bash_aliases"

if [[ $lc -gt 1 ]]; then
	for i in "${arr[@]}"; do
		if [[ ${i} != "${USER}" ]]; then
			d="/home/${i}/"
			if [[ -d $d ]]; then
				sudo cp ~/$rc $d
				sudo cp ~/$al $d
				sudo chown -f $i:$i $d$rc
				sudo chown -f $i:$i $d$al
				sudo chmod g=rw $d$rc
				sudo chmod g=rw $d$al
			fi
		fi
	done
fi

	sudo cp ~/$rc /root/
	sudo cp ~/$al /root/

