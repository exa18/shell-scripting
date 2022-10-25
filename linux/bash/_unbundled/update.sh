#!/bin/bash
s='sudo '
#
${s}ls >/dev/null
#
# UPGRADING section
#
echo Performing UPDATE...
echo 
echo ... Update
${s}apt update
echo ... Upgrade
${s}apt upgrade -y
${s}apt autoremove -y
echo ... Check and upgrade those kept back
# upgrade packages witch kept back
#   list upgradable with removed warnings -> remove first line -> print all lines thru '/' ->
#   -> for each: upgrad/install-fix and mark as auto (installed,automatic)
readarray -t pkg <<< $(apt list --upgradable 2>/dev/null | sed 1d | awk -F/ '{print $1}')
if [[ -n "${pkg}" ]];then
    echo ...:... Reinstall broken
    ${s}apt --fix-missing update
    ${s}apt update
    while read pkg; do
        # upgrade and in case broken do install with fix
            [[ -n "${pkg##*nvidia*}" ]] && ${s}apt install -y -f ${pkg} && ${s}apt-mark auto ${pkg}
    done
echo 
fi
#
# REMOVING section
#
echo ... Removes old revisions of snaps
# CLOSE ALL SNAPS BEFORE RUNNING THIS
set -eu

LANG=en_US.UTF-8 snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        S{s}snap remove "$snapname" --revision="$revision"
    done

echo ... Purge residual configs
set -u
dpkg -l | grep '^rc' | awk '{print $2}' | xargs -r ${s}dpkg --purge
set +u

echo ... Autoremove
${s}apt autoremove -y
${s}apt autoclean
echo DONE.

