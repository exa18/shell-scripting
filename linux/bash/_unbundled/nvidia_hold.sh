#!/bin/bash
#
# >>>
#
getinstalled() {
	readarray -t pkg <<< "$(dpkg -l |awk '/^ii/{print $2}')"
}
setonhold() {
	if [[ "$(apt-mark showhold| grep ${p}|wc -l)" -eq "0" ]];then
		${s}apt-mark hold ${p} >/dev/null 2>&1
		ch=$(echo "${lc} + $(echo ${pr}|wc -c) - ( $(echo ${1}${p}|wc -c) + 5 )"|bc)
		echo -e "\r${1}${p}  /+/$(spacefill)"
		lc=0
	fi
}
onexit() {
	tput cnorm
}
spacefill() {
	# cover previous with spaces if shorter
	lc=$(echo ${p}|wc -c)
	while [[ $ch -ge 0 ]]; do
		echo -n " "
		ch=$((ch -1))
	done
}
#
# <<<
#
s='sudo '
${s}ls >/dev/null
#
# Unhold all
${s}apt-mark unhold $(apt-mark showhold)
#
# case arg="--" just unmark
[[ "${1}" == "--" ]] && exit 0
#
getinstalled

trap onexit EXIT
tput civis
if [[ -n "${pkg[0]}" ]];then
	t=${#pkg[@]}
	x=1
	lc=0
    for p in "${pkg[@]}"; do
	if [[ -n "${p##*nvidia*}" ]];then
		# If NOT contain "nvidia" then check dependencies
		if [[ "$(apt depends ${p} 2>/dev/null|grep -P "Depends|Recomends"|grep -c nvidia)" -gt "0" ]];then
			# nvidia dependencies detected
			setonhold ":::"
		else
			pr="${x}/${t}   "
			echo -ne "\r${pr}${p}"
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
ch=$(echo "( ${lc} + $(echo ${pr}|wc -c) +1 ) - $(echo ${p}|wc -c)"|bc)
echo -e "\r${p}$(spacefill)"