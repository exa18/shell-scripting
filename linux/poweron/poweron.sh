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
	getData () {
		x=1
		log='/var/log/wtmp'
		arr=
		while [ -e $log ];do
			readarray -t trr <<< "$(last -x runlevel --time-format iso -f $log | grep -Eo ".*${1}.*" | awk '{print $6"."$8}')"
			arr+=("${trr[@]}")
			log=${log}'.'${x}
			x=$((x+1))
		done
	}

### actual year and month
d=("$(date '+%Y')" "$(date '+%-m')")
dcur="$(date +%Y-%m-%dT%H:%M:%S)"
dcmon="$(date +%m)"

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
	[ ${#arr[@]} -lt "2" ] && arr[1]="${d[1]}"
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
	getData "${is}"

	### get last day of month
	#last=$(echo $(cal ${mt} ${yr}) | awk '{print $NF}')
	#
	# implement from PHP
	# src: https://www.php.net/manual/en/function.cal-days-in-month.php
	#
	if [ $mt -eq 2 ];then
		if [[ $(bc <<< "${yr} % 4") -gt 0 ]];then
			last=28
		else
			if [[ $(bc <<< "${yr} % 100") -gt 0 ]];then
				last=29
			else
				[[ $(bc <<< "${yr} % 400") -gt 0 ]] && last=28 || last=29
			fi
		fi
	else
		[[ $(bc <<< "(${mt}-1) % 7 % 2") -gt 0 ]] && last=30 || last=31
	fi

	### prepare start and end month
	ms="${is}-01T00:00:00"
	me="${is}-${last}T23:59:59"
	### total minutes in month
	gtot=$(( $last * 24 * 60 ))

	### check if other month then replace current date with given month
	[ "${mt}" != "${dcmon}" ] && dcur="${me}"
	#
	# Count result
	#
	### if array empty in case non-stop run
	[[ -z "${arr[*]}" ]] && getData "running"
		#x=0
	g=0
	for i in "${arr[@]}"
	do
		### check if prev/next month
		IFS='.' read -ra av <<< "${i}"
		dl=$(bc <<< "$(dateGetMonth "${av[0]}") - ${mt}")
		[ "${av[1]}" = "running" ] && av[1]="${dcur}"
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
		### add 1 hour and 1 minute
		g=$(( g + 61 ))
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
