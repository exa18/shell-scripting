#!/bin/bash
#
#	Shamir's Secret Sharing Scheme
#	UI
#

# Check system
ver=$(uname -av)
mac=$(echo $ver | grep -i darwin | wc -c)
linux=$(echo $ver | grep -i linux | wc -c)
windows=$(echo $ver | grep -i w64_nt | wc -c)

# IF gt 0 then inside terminal (CLI)
terminal=$(echo $TERM | grep -i xterm | wc -c)

#whiptail / dialog

# create keys
secret=$(echo "secret to share" | base64)
#if $(echo $secret | wc -c) -le 128 AND -gt 0 THEN do
##echo $secret | ssss-split -t 2 -n 2 -Q | while read key; do k=${key%-*}; k=${k#*-}; echo $key > key${k}.txt; done
#	GET next key number
#	key=myid-1-1918f92ba4e9b07111e95325 OR 1-1918f92ba4e9b07111e95325
#	k=${key%-*}; k=${k#*-}


# combine keys and decode
##echo -e "key1\nkey2" | ssss-combine -t 2 -Q 2>&1 | base64 -d

#row=$(zenity --forms --title="Create user" --text="Add new user" --add-entry="Shares to recondtruct"  --add-entry="Shares to create" --add-entry="Secret")

row=$(zenity --text-info --text="TEXT" --height=200 --editable --extra-button="COMBINE" --extra-button="CREATE")
echo $row | wc -l