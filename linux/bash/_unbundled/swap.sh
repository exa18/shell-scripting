#!/bin/bash
#
# Make/Modify Swapfile
#
s='sudo '
${s}ls >/dev/null
#
gigs=2
if [[ -n "${1}" ]] && [[ $1 -gt 0 ]];then
	gigs=$1
fi
# If swap ON then OFF
sw=$(swapon --show | grep "/swapfile" | wc -l)
[[ $sw -gt 0 ]] && ${s}swapoff /swapfile
#
if [[ "${1}" == "--" ]];then
	# remove swap
	${s}rm /swapfile
	# and remove it from FSTAB
	awk '!/\/swapfile/' /etc/fstab > tempswp && ${s}mv tempswp /etc/fstab 
else
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
