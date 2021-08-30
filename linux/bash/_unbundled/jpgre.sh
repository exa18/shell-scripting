#!/bin/bash
#
SH_SPIN="/-\|"

r="40"
[ -n "$1" ] && r="${1}"

readarray -t arr <<< "$(ls -1 *.jpg | grep -E -v '*_re*')"

x=0
lc=${#arr[@]}

if [ -n "$lc" ]; then
	for i in "${arr[@]}"; do
		echo -ne "\r${SH_SPIN:x++%${#SH_SPIN}:1} ${x} / $(( x *100 / lc )) %"
		convert "$i" -resize "${r}%" -sharpen 0x1 -quality 95 "${i%.*}_re${r}.jpg"
	done
fi

echo -ne "\r \n"
