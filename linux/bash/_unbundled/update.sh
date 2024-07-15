#!/bin/bash
#
#
s='sudo '
#
#${s}ls >/dev/null
#
# UPGRADING section
#
echo -e "\nPerforming UPDATE..."
echo "... Update repos"
${s}apt update
echo -e "\n... Check if upgrade"
u=$(apt upgrade -s 2>/dev/null |grep upgraded|awk '{t=$1+$3}END{print t}')

if [[ $u -gt 0 ]];then
	#
	# Perform snapshot
	#
	if [[ -n $(command -v timeshift) ]];then
		if [[ $(${s}timeshift --list|grep "Status"|grep -c "OK") ]];then
			echo -e "\n... Timeshift run"
			d=$(date '+%Y-%m-%d')
			x=0
			tag=" --tags D"
			while read t; do
				[[ "${t}" == "D" ]] && tag=""
				x=$((x+1))
			done < <(${s}timeshift --list|awk -v f="${d}" '$0~f{print $4}')
			[[ $x -le 1 ]] && ${s}timeshift --create --comments "before update ${x}"${tag}
		fi
	fi
	#
	# Then do updates
	#
	echo -e "\n... Upgrade"
	${s}apt upgrade -y
	${s}apt autoremove -y

	echo -e "\n... Purge residual configs"
	set -u
	dpkg -l | grep '^rc' | awk '{print $2}' | xargs -r ${s}dpkg --purge
	set +u
else
	echo -e "\n... Uptodate"
fi
echo -e "\n... DONE."

