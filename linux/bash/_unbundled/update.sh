#!/bin/bash
#
#
getkeptback() {
	readarray -t pkg <<< "$(apt list --upgradable 2>/dev/null | sed 1d | awk -F/ '{print $1}')"
}

#
#
s='sudo '
#
#${s}ls >/dev/null
#
# ESM Apps related to Ubuntu Pro -> remove nag durring update
#
	pro="ubuntu-advantage"
for f in /etc/apt/apt.conf.d/*apt-esm-hook.con*;do
	[[ ! -d ${f%/*}/off ]] && ${s}mkdir ${f%/*}/off
	[[ -e $f ]] && ${s}mv -f $f ${f%/*}/off
	${s}systemctl is-enabled ${pro} >/dev/null && ${s}systemctl disable ${pro}
done
#
# UPGRADING section
#
echo -e "\nPerforming UPDATE..."
echo "... Update repos"
${s}apt update -y
echo -e "\n... Upgrade"
${s}apt upgrade -y
${s}apt autoremove -y
#
# REMOVING section
#
echo -e "\n... Removes old revisions of snaps"
# CLOSE ALL SNAPS BEFORE RUNNING THIS
set -eu

LANG=en_US.UTF-8 snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        ${s}snap remove "$snapname" --revision="$revision"
    done

echo -e "\n... Purge residual configs"
set -u
dpkg -l | grep '^rc' | awk '{print $2}' | xargs -r ${s}dpkg --purge
set +u

echo -e "\n... Check and upgrade those kept back"
# upgrade packages witch kept back
#   list upgradable with removed warnings -> remove first line -> print all lines thru '/' ->
#   -> for each: upgrad/install-fix and mark as auto (installed,automatic)
	getkeptback
if [[ -n "${pkg[0]}" ]];then
    echo "...:... Safe upgrade packages have been kept back"
    ${s}apt --fix-missing update -y
    ${s}aptitude safe-upgrade --full-resolver -y
	getkeptback
	if [[ -n "${pkg[0]}" ]];then
	    echo "...:... Upgrade rest"
	    for p in "${pkg[@]}"; do
		if [[ -n "${p##*nvidia*}" ]];then
			${s}apt upgrade -y ${p}
#			    ${s}apt upgrade -y ${p} || ${s}apt install -y -f ${p}
#			    ${s}apt-mark auto ${p}
		fi
		# upgrade only kernel which upgrades rest
		[[ -z "${p##*nvidia-kernel-common-*}" ]] &&  ${s}apt upgrade -y ${p}
	    done
	fi
fi
    echo -e "\n... Clean and autoremove"
    ${s}apt autoremove -y

# Check Nvidia if updated then need restart
[[ -n $(command -v nvidia-smi) ]] && [[ $(nvidia-smi | grep -io failed | wc -m) -gt 0 ]] && echo "NVIDIA updated: NEED RESTART"

echo -e "\n... DONE."

