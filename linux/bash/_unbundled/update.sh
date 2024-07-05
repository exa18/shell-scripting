#!/bin/bash
#
#
s='sudo '
#
#${s}ls >/dev/null
#
# ESM Apps related to Ubuntu Pro -> remove nag durring update
#
if [[ -n $(command -v snap) ]];then
for f in /etc/apt/apt.conf.d/*apt-esm-hook.con*;do
	[[ ! -d ${f%/*}/off ]] && ${s}mkdir ${f%/*}/off
	[[ -e $f ]] && ${s}mv -f $f ${f%/*}/off
done
	pro="ubuntu-advantage"
	${s}systemctl is-enabled ${pro} >/dev/null && ${s}systemctl disable ${pro}
fi
#
#
# UPGRADING section
#
echo -e "\nPerforming UPDATE..."
echo "... Update repos"
${s}apt update
echo -e "\n... Upgrade"
${s}apt upgrade -y
${s}apt autoremove -y

echo -e "\n... Purge residual configs"
set -u
dpkg -l | grep '^rc' | awk '{print $2}' | xargs -r ${s}dpkg --purge
set +u

echo -e "\n... DONE."

