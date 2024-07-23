#!/bin/bash
#
#
getinstalled() {
	readarray -t pkg <<< "$(dpkg -l |awk '/^ii/{print $2}')"
}
setonhold() {
	if [[ "$(apt-mark showhold| grep ${p}|wc -l)" -eq "0" ]];then
		${s}apt-mark hold ${p} >/dev/null 2>&1
		ch=$(echo "${lc} - $(echo ${p}|wc -c) + 3"|bc)
		echo -e "\r${1}${p}  /+/$(spacefill)"
		lc=0
	fi
}
showpointer() {
	tput cnorm
}
spacefill() {
	# cover previous with spaces if shorter
	lc=$(echo ${p}|wc -c)
	while [[ "$ch" -ge "0" ]]; do
		echo -n "."
		ch=$((ch -1))
	done
}
#
#
s='sudo '
${s}ls >/dev/null
#
# Unhold all
${s}apt-mark unhold $(apt-mark showhold)
#
getinstalled

trap showpointer EXIT
tput civis
if [[ -n "${pkg[0]}" ]];then
	t=${#pkg[@]}
	x=1
	lc=0
    for p in "${pkg[@]}"; do
	if [[ -n "${p##*nvidia*}" ]];then
		# If NOT contain "nvidia" then check dependencies
		if [[ "$(apt depends ${p} 2>/dev/null|grep -P "Depends|Recomends"|grep -c nvidia)" -gt "0" ]];then
			setonhold ":::"
		else
			echo -ne "\r${x}/${t}   ${p}"
			ch=$(echo "${lc} - $(echo ${p}|wc -c)"|bc)
			spacefill
		fi
	else
		# nvidia detected
		setonhold "..."
	fi
	x=$((x +1))
    done
fi

p="Completed."
# compute spaces
ch=$(echo "( ${lc} + $(echo ${x}${t}|wc -c) + 3 ) - $(echo ${p}|wc -c)"|bc)
echo -ne "\r${p}$(spacefill)\n"