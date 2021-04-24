#!/bin/bash
#
#	Show the total time the computer was ON
#

	dateGetTime () {
		s=$(date -d "${1}" +%s)
		e=$(date -d "${2}" +%s)
		echo "$(( (e - s) / 60 ))"
	}
	dateGetMonth () {
		echo "${1:5:2}"
	}

### actual year and month
d=("$(date '+%Y')" "$(date '+%-m')")

### get inputs
inp=$(zenity --forms --title="How long is ON" --width=300 \
--text="Enter date:" \
--separator="-" \
    --add-entry="Year" \
    --add-entry="Month"
)

#
# make array from input
#
if [ "$inp" == "-" ]
then
	inp="${d[0]}-${d[1]}"
fi

IFS='-' read -ra arr <<< "$inp"
#
# core
#
if [ $inp ]
then
	#
	# process inputs
	#
	### when year only
	if [ ${#arr[@]} -lt "2" ] 
	then
		arr[1]="${d[1]}"
	fi
	### process array with inputs
	x=0	
	for i in "${arr[@]}"
	do
		if [ -z "$i" ]
		then
			i=${d[$x]}
		else
			if [ "$i" -lt "10" ]
			then
				i="0"${i}
			fi
		fi
		if [ "$x" -eq "0" ]
		then
			yr=${i}
			i=${i}"-"
		fi
		is=${is}${i}
		x=$((x+1))
	done
			mt=${i}
	#
	# extract reboot times (when comp was ON)
	#	
	readarray -t arr <<< $(last -x runlevel --time-format iso | grep -Eo ".*${is}.*" | awk '{print $6"."$8}')

	### get last day of month
	last=$(echo $(cal ${mt} ${yr}) | awk '{print $NF}')
	### prepare start and end month
	ms="${is}-01T00:00:00"
	me="${is}-${last}T23:59:59"
	### total minutes in month
	gtot=$(( $last*24*60 ))
	#
	# Count result
	#
		#x=0
	g=0
	for i in "${arr[@]}"
	do
		### check if prev/next month
		IFS='.' read -ra av <<< "${i}"
		dl=$(bc <<< "$(dateGetMonth "${av[0]}") - ${mt}")
		dr=$(bc <<< "$(dateGetMonth "${av[1]}") - ${mt}")

	if [ $dl -eq $dr ];then
		### same month
		aa=$(dateGetTime "${av[0]}" "${av[1]}")
	else
		if [ $dl -eq 0 ];then
			### ends in next month
			aa=$(dateGetTime "${av[0]}" "${me}")
		else
			### starts in prev month
			aa=$(dateGetTime "${ms}" "${av[1]}")
		fi
	fi
		#echo "${x}///${aa}///${av[0]}///${av[1]}///"
		g=$(( g + aa ))
		#x=$(( x+1 ))
	done
	#
	# show
	#
	gd=$(( ( g / 60 ) / 24 ))
	gh=$(( ( g / 60 ) - ( gd *24 ) ))
	gm=$(( g - ( gh * 60 + gd * 24 * 60 ) ))
	### calculate percent of month used
	gpr=$(echo "scale=2 ; $g / $gtot *100" | bc)
	gpr=${gpr%.*}
	### display info
	zenity  --info --width=300 --text "Couting for ${is}\nComputer was turned on by . . . ${gd}D ${gh}h ${gm}m\nthis is . . . ${gpr}% of month"
fi
