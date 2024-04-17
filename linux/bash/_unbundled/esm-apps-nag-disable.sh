#!/bin/bash
#
#	ESM Apps related to Ubuntu Pro -> remove nag durring update
#
s='sudo '
${s}ls >/dev/null
#sudo mkdir /etc/apt/apt.conf.d/off
#sudo mv -f /etc/apt/apt.conf.d/20apt-esm-hook.con* /etc/apt/apt.conf.d/off
	pro="ubuntu-advantage"
for f in /etc/apt/apt.conf.d/*apt-esm-hook.con*;do
	[[ ! -d ${f%/*}/off ]] && ${s}mkdir ${f%/*}/off
	[[ -e $f ]] && ${s}mv -f $f ${f%/*}/off
	${s}systemctl is-enabled ${pro} >/dev/null && ${s}systemctl disable ${pro}
done