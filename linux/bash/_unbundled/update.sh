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
echo ... Check and upgrade those kept back
# upgrade packages witch kept back
#   list upgradable with removed warnings -> remove first line -> print all lines thru '/' ->
#   -> for each: upgrade and mark as installed,automatic
apt list --upgradable 2>/dev/null | sed 1d | awk -F/ '{print $1}' |
    while read pkg; do
        ${s}apt upgrade -y $pkg
        ${s}apt-mark auto $pkg
    done

echo 
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

echo ... Autoremove
${s}apt autoremove -y
echo ... Purge residual configs
set -u
dpkg -l | grep '^rc' | awk '{print $2}' | xargs -r ${s}dpkg --purge
set +u

echo DONE.

