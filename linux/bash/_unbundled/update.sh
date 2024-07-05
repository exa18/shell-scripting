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
echo -e "\n... Upgrade"
${s}apt upgrade -y
${s}apt autoremove -y

echo -e "\n... Purge residual configs"
set -u
dpkg -l | grep '^rc' | awk '{print $2}' | xargs -r ${s}dpkg --purge
set +u

echo -e "\n... DONE."

