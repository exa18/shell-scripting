#!/bin/bash
#
# >
	getDateArray() {
		#	YYYY MM DD hh mm
		local arr=("${1::4}" "${1:4:2}" "${1:6:2}" "${1:8:2}" "${1:10:2}")
		echo "${arr[@]}"
	}
# <
#
#

	p=($(getDateArray "${1}"))
	readarray -t list <<< "$(ls -1)"

if [ ${#list[@]} -gt 0 ]; then
	for f in "${list[@]}"; do
		pf=($(getDateArray "$(date '+%Y%m%d%H%M' -r ${f})"))
		d=
		x=0
		for v in "${pf[@]}"; do
			[ ${#p[$x]} -gt 0 ] && a=${p[$x]} || a=${v}
			d=${d}${a}
			x=$((x+1))
		done
		touch -a -m -t $d $f
		#echo "${f} -> ${d}"
	done
fi

