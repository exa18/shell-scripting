#!/bin/bash
#
SH_SPIN="/-\|"
x=1
#
# RAW extension
raw=.cr2
#
logg=./log_$(date '+%Y%m%d_%H%M')
#
find . -type f -name "f*${raw}" | while read fff;do
	faa=$(date -r $fff '+%Y%m%d%H%M%S')
	i=0
	f=$(find ${fff%/*} -type f -name "f*.jpg")
		while read ggg;do
			gaa=$(date -r $ggg '+%Y%m%d%H%M%S')
			[[ $faa -eq $gaa ]] && break
			i=$((i + 1))
		done <<< "$f"
	#
	echo -ne "\r${SH_SPIN:x++%${#SH_SPIN}:1} ${x}"
	#
	folder=${faa::8}
	name=${faa:8:6}
	mkdir -p $folder
	#
	# Check it
	check=1
	while [[ $check -gt 0 ]];do
	check=$(find ./$folder -name "${folder}_${name}${raw}" -print | wc -l)
	if [[ $check -gt 0 ]];then
		check=$(diff -q $fff ./${folder}/${folder}_${name}${raw} 2>/dev/null | wc -l)
		if [[ $check -gt 0 ]];then
			# +1 to number with base 10
			name=$((10#$name +1))
			# has to be 6 chars
			name=$(printf "%06d\n" $name)
		else
		# do not copy while file are same
			check=-1
		fi
	else
	# do copy
		check=0
	fi
	done

	fullname=${folder}_${name}
	if [[ $check -eq 0 ]];then
		cp $fff "./${folder}/${fullname}${raw}" 2>/dev/null || echo " / MISSING: RAW / $ggg ... $fullname" >> $logg
		cp $ggg "./${folder}/${fullname}.jpg" 2>/dev/null || echo " / MISSING: JPG / $fff ... $fullname" >> $logg
	fi

done
echo " "


