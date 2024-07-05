#!/bin/bash
#
#
s='sudo '
#
#${s}ls >/dev/null
#
# ESM Apps related to Ubuntu Pro -> remove nag durring update
#
for f in /etc/apt/apt.conf.d/*apt-esm-hook.con*;do
	[[ ! -d ${f%/*}/off ]] && ${s}mkdir ${f%/*}/off
	[[ -e $f ]] && ${s}mv -f $f ${f%/*}/off
done
	pro="ubuntu-advantage"
	${s}systemctl is-enabled ${pro} >/dev/null && ${s}systemctl disable ${pro}
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
if [[ -n $(command -v snap) ]];then
echo -e "\n... Removes old revisions of snaps"
# CLOSE ALL SNAPS BEFORE RUNNING THIS
set -eu
LANG=en_US.UTF-8 snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        ${s}snap remove "$snapname" --revision="$revision"
    done
fi

echo -e "\n... Purge residual configs"
set -u
dpkg -l | grep '^rc' | awk '{print $2}' | xargs -r ${s}dpkg --purge
set +u

echo -e "\n... DONE."

