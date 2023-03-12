#!/bin/bash
#
#   Server imap cleaner
#
flag="${1}"
shift
#
[[ -n "${1}" ]] && domain="${1#--*}" && dozip="${1::2}" # set domain name
[[ -z "${domain}" ]] && domain="*"
if [[ "${dozip}" = "--" ]];then
    dozip="make .zip and "
else
    dozip=
fi
#
#   // Real path on server
#
dir="${HOME}/imap/${domain}"
d="${dir}/*/Maildir/"
#   find only CUR folders which contains mails
readarray -t cur <<< "$(find $d -type d -name "cur" -print)"
#
t=$(date "+%Y%m%d")
arh="${HOME}/mail_arch/"
[[ -d $arh ]] || mkdir -p $arh

# file size in MB
fs=( 3 5 10 15 20 )
# file time older than in days
ft=( 30 45 90 180 360 )

#   default setting and optimal
at=${ft[-1]}
as=${fs[0]}
# days minimum 7
if [[ ${2} -gt 6 ]]  && [[ -n "${2}" ]];then
	at=${2}
	ft=(${ft[@]} ${at})
fi
# size minimum 2 MB
if [[ ${3} -gt 1 ]]  && [[ -n "${3}" ]];then
	as=${3}
	fs=(${fs[@]} ${as})
fi

case "${flag}" in
#
#   Fix date from file after copy
#
    "datefix" )
#
    echo "Fixing modification date: ${domain}"
    x=0
    for dd in "${cur[@]}";do
        readarray -t ff <<< "$(find "${dd}" -maxdepth 1 -type f -name "*" -print)"
        if [[ ${#ff[@]} -gt 0 ]];then
            for f in "${ff[@]}";do
                if [[ -e "${f}" ]];then
                    dat="$(head -n 20 "${f}" | grep "Delivery-date: " | awk -F ": " '{print $NF}')"
                    if [[ -n "${dat}" ]];then
                        touch -a -m --date="${dat}" "${f}" &&  x=$((x+1)) && echo -ne "\r${x}" 
                    fi
                fi
            done
        fi
    done
    echo -e "\nDONE."
    ;;
#
#   Check savings
#
    "scan" )
#
echo "Start scaning: ${domain}"
echo "Counting in GB for files greater or less in MB"

    # print days header
    echo -ne "\nD> :"  
    for at in "${ft[@]}";do
        echo -ne "\t${at}"
    done
    echo -e "\n"
for as in "${fs[@]}";do
    # Count greater than MB
    echo -ne ">${as} :\t"
    for at in "${ft[@]}";do
        a=$(echo $(for dd in "${cur[@]}";do find "${dd}" -maxdepth 1 -type f -name "*" -mtime +${at} -size +${as}M -printf "%s+";done;echo 0) | bc)
        printf "%0.1f" $(bc <<< "scale=1; $a / 1024^3")   # calculate in GB
        echo -ne "\t"
    done
    # Count less than MB
    echo -ne "\n<${as} :\t"
    for at in "${ft[@]}";do
        a=$(echo $(for dd in "${cur[@]}";do find "${dd}" -maxdepth 1 -type f -name "*" -mtime +${at} -size -${as}M -printf "%s+";done;echo 0) | bc)
        printf "%0.1f" $(bc <<< "scale=1; $a / 1024^3")   # calculate in GB
        echo -ne "\t"
    done
    echo -e "\n"
done
    ;;
#
#   Cleaning
#
    "clean" )
#
[[ -d $dir ]] || exit 1
#
echo "Start cleaning for: ${domain}"
#
#   REMOVE and archive files less than limit and also clean up old .zip
if [[ -n "${dozip}" ]];then
    echo -n "Archive files older than ${at} days and less than ${as} MB to ${t}.zip"
    echo "$(for dd in "${cur[@]}";do find "${dd}" -maxdepth 1 -type f -name "*" -mtime +${at} -size -${as}M -print;done;)" | zip -@q9 "${arh}${t}.zip"
    find "${arh}" -maxdepth 1 -type f -name "*.zip" -mtime +${at} -delete
fi
[[ -n "${dozip}" ]] && echo " also remove them." || echo "Remove files older than ${at} days and greater than ${as} MB"
for dd in "${cur[@]}";do
    #   REMOVE SMALL
    #find "${dd}" -maxdepth 1 -type f -name "*" -mtime +${at} -size -${as}M -delete
    if [[ -n "${dozip}" ]];then
        #   REMOVE ALL
        find "${dd}" -maxdepth 1 -type f -name "*" -mtime +${at} -delete
    else
        #   REMOVE LARGE only
        find "${dd}" -maxdepth 1 -type f -name "*" -mtime +${at} -size +${as}M -delete
    fi
done
#
echo "DONE."
    ;;
#
#   HELP
#
    "help" | * )
#
cat << _EOF_

Working with directory:
${d}

Domain prefixed with "--" will turn on making ZIP
for smaller files.

clean domain
Files older than ${at} days
#   and less than ${as} MB ${dozip}do remove
#   and greater than ${as} MB do remove
#   .zip stored at ${arh}

scan (domain)
#   checks how many GB saved with given days and size

datefix (domain)
#   fix modification date to inside delivery instead current
#   which was taken after copy

Usage:
<command> (domain OR "*") (days > 6) (size > 1)

_EOF_
esac
