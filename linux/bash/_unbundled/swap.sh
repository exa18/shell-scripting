#!/bin/bash
#
# Make/Modify Swapfile
#
s='sudo '
${s}ls >/dev/null
#
# If swap ON then OFF
sw=$(${s}swapon --show | grep "/swapfile" | wc -l)
[[ $sw -gt 0 ]] && ${s}swapoff /swapfile
#
if [[ "${1}" == "--" ]];then
	# remove swap
	${s}rm /swapfile
	# and remove it from FSTAB
	awk '!/\/swapfile/' /etc/fstab > tempswp && ${s}mv tempswp /etc/fstab 
else
	# Check total ram and add 2GB as swapfile size
	gigs=$(echo "$(cat /proc/meminfo | grep MemTotal | awk '{print $2}') / 1000 / 1024 +2"|bc)
	if [[ -n "${1}" ]] && [[ $1 -gt 0 ]];then
		gigs=$1
	fi
	# Redefine swap
	${s}dd if=/dev/zero of=/swapfile bs=1024 count=$((gigs * 1024 *1024)) status=progress
	${s}chmod 600 /swapfile
	${s}mkswap /swapfile
	${s}swapon /swapfile
	# IF swapfile is in FSTAB
	sw=$(cat /etc/fstab | grep "/swapfile" | wc -l)
	# /OR/ : /swapfile swap swap defaults 0 0
	[[ $sw -eq 0 ]] && echo "/swapfile none swap sw 0 0" | ${s}tee -a /etc/fstab
fi
