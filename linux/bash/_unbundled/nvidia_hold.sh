#!/bin/bash
#
#
getinstalled() {
	readarray -t pkg <<< "$(dpkg -l |awk '/^ii/{print $2}')"
}
setonhold() {
	if [[ "$(apt-mark showhold| grep ${p}|wc -l)" -eq "0" ]];then
		echo "${1}${p}  /+/"
		${s}apt-mark hold ${p} >/dev/null 2>&1
	fi
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
if [[ -n "${pkg[0]}" ]];then
    for p in "${pkg[@]}"; do
	if [[ -n "${p##*nvidia*}" ]];then
		# If NOT contain "nvidia" then check dependencies
		if [[ "$(apt depends ${p} 2>/dev/null|grep -P "Depends|Recomends"|grep -c nvidia)" -gt "0" ]];then
			setonhold ":::"
		else
			echo "   ${p}"
		fi
	else
		# nvidia detected
		setonhold "..."
	fi
    done
fi

apt-mark showhold