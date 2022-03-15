#!/bin/bash

sudo ls >/dev/null
echo Performing UPDATE...
echo 
echo ... Update
sudo apt update -y
echo ... Upgrade
sudo apt upgrade -y
echo ... Autoremove
sudo apt autoremove -y
echo 
echo ... Removes old revisions of snaps
# CLOSE ALL SNAPS BEFORE RUNNING THIS
set -eu

LANG=en_US.UTF-8 snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done

echo ... Purge residual configs
set -u
dpkg -l | grep '^rc' | awk '{print $2}' | xargs -r dpkg --purge
set +u

echo DONE.

