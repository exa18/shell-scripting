#!/bin/sh
#
#
#SET
#
# default database file w/o ext
kdbx='KEEPASSDATABASE'
remote='REMOTE:'
remotepath='FOLDER/SUBFOLDER'
bak='/Backup_XC'
#
# check args
#
verbose=
if [ "$1" = "--" ]; then
	[ -z "$verbose" ] && verbose='yes' || verbose=
	shift
fi
[ -n "$1" ] && kdbx=${1}
#
#	Glue settings
#
cloud="${remote}${remotepath}"
#here=$(dirname "$(readlink -f $0)")
here=$HOME	# read env HOME to always do backup in one place
host=$(hostname)
u=$(id -un)
log=${here}/check.log
kbfile=${kdbx}.kdbx
kbloc=${here}/${kbfile}
kbrem=${cloud}/${kbfile}
#
# check if installed
#
if [ -z "$(command -v rclone)" ];then
	echo "Install RCLONE first!"
	exit 0
fi
#
# check if exists remote
#
if [ -z "$(rclone listremotes | grep ${remote})" ];then
	echo "REMOTE not created: ${remote}"
	exit 0
fi
#if [ ! -e "${kbloc}" ];then
#	echo "NOT FOUND local: ${kbfile}"
#	exit 0
#fi
[ -d "${here}${bak}" ] || mkdir -p "${here}${bak}"
#
# ================
#
# START
#
echo "Keepass: ${kdbx}"
#
rclone lsl "${kbrem}" --log-file "${log}" > "${log}"
error=$(cat "${log}" | awk '/ERROR.*not found/{print}')
rem=$([ -z "${error}" ] && cat "${log}" | grep "${kbfile}" | awk '{print $2 $3}' | cut -f1 -d"." | cut -f1-2 -d":" | tr -d "-" | tr -d ":")
loc=$([ -e "${kbloc}" ] && ls -lah --time-style=full-iso "${kbloc}" | awk '{print $6 $7}' | cut -f1 -d"." | cut -f1-2 -d":" | tr -d "-" | tr -d ":")

rclone check "${kbloc}" "${cloud}" --size-only --one-way --no-traverse --log-file "${log}"
tsys="$(date +%Y%m%d%H%M)"
logdif=$(cat ${log} | awk '/NOTICE.*differences/{print}')
dif=$(printf '%d' "$(echo "${logdif}" | grep -Fo '\:\s([0-9]+)' | awk '{print $NF}')" 2>/dev/null)
# get remote time and calc timezone
trem=$(echo "${logdif}" | awk -F: '{print $1 $2}'|tr -d "/"|tr -d " ")
tz=$(( ((tsys - trem)/100)*100 ))
rm "${log}"

[ -z "${rem}" ] && rem=0 || rem=$((rem + tz))
[ -z "${loc}" ] && loc=0
[ -n "${verbose}" ] && echo "Remote: /${rem}/  Local: /${loc}/  Diff: /${dif}/  TZ: /$((tz / 100))/"

if [ "${dif}" -gt "0" ]; then

	if [ "${rem}" -gt "${loc}" ]; then
		echo "Remote is new <- PULL"
		stamp=${loc}
		find "${here}${bak}"/* -mtime +30 -exec rm {} \;  >/dev/null 2>&1
		[ "${loc}" -gt "0" ] && rclone copyto "${kbloc}" "${here}${bak}/${kbfile}_${stamp}" >/dev/null 2>&1
		rclone copy "${kbrem}" "${here}" >/dev/null 2>&1
	fi

	if [ "${loc}" -gt "${rem}" ]; then
		echo "Local is new -> PUSH"
		stamp=${rem}
		[ "${rem}" -gt "0" ] && rclone copyto "${kbrem}" "${cloud}${bak}/${host}/${u}/${kbfile}_${stamp}" >/dev/null 2>&1
		rclone copy "${kbloc}" "${cloud}" >/dev/null 2>&1
	fi
else
	echo "Remote = Local"
	[ "${rem}" -eq "${loc}" ] && echo "*** This is origin ***"
fi

[ -n "${verbose}" ] && echo "Local backup: ${here}${bak}/"
[ -n "${verbose}" ] && echo "Remote backup: ${cloud}${bak}/${host}/${u}/"
exit 0
