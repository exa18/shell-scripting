#!/bin/bash
#
#   Server imap cleaner
#
flag="${1}"
shift
#   prepare paths
verbose=    # verbose if arg starts with --
[[ -n "${1}" ]] && domain="${1#--*}" && verbose="${1::2}" # set domain name
[[ -z "${domain}" ]] && domain="*"
#
#   // Real path on server
#
dir="${HOME}/imap/${domain}"
d="${dir}/*/Maildir/cur/"
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
[[ ${2} -gt 6 ]]  && [[ -n "${2}" ]] && at=${2}
# size minimum 2 MB
[[ ${3} -gt 1 ]]  && [[ -n "${3}" ]] && as=${3}

case "${flag}" in
    "scan" )
#
#   Check savings
##
echo "Domain: ${domain}"
echo "Counting for: ${d}"
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
        a=$(echo $(find $d -maxdepth 1 -type f -name "*" -mtime +${at} -size +${as}M -printf "%s+";echo 0) | bc)
        printf "%0.1f" $(bc <<< "scale=1; $a / 1024^3")   # calculate in GB
        echo -ne "\t"
    done
    # Count less than MB
    echo -ne "\n<${as} :\t"
    for at in "${ft[@]}";do
        a=$(echo $(find $d -maxdepth 1 -type f -name "*" -mtime +${at} -size -${as}M -printf "%s+";echo 0) | bc)
        printf "%0.1f" $(bc <<< "scale=1; $a / 1024^3")   # calculate in GB
        echo -ne "\t"
    done
    echo -e "\n"
done
    ;;
    "clean" )
#
#   Cleaning
#
[[ -d $dir ]] || exit 1
#
[[ "${verbose}" = "--" ]] && echo -e "Start cleaning for domain: ${domain}\n...making ZIParhive: ${t}.zip"
#
#   REMOVE and archive files less than limit and also clean up old .zip
[[ "${verbose}" = "--" ]] && echo -n "Archive files older than ${at} days and less than ${as} MB"
find $d -maxdepth 1 -type f -name "*" -mtime +${at} -size -${as}M -print | zip -@q9 ${arh}${t}.zip
find $arh -maxdepth 1 -type f -name "*.zip" -mtime +${at} | xargs -r rm
[[ "${verbose}" = "--" ]] && echo " also remove them."
find $d -maxdepth 1 -type f -name "*" -mtime +${at} -size -${as}M | xargs -r rm
#
#   REMOVE LARGE files
#
[[ "${verbose}" = "--" ]] && echo "Remove files older than ${at} days and greater then ${as} MB"
find $d -maxdepth 1 -type f -name "*" -mtime +${at} -size +${as}M | xargs -r rm
[[ "${verbose}" = "--" ]] && echo "DONE."
    ;;
    "help" | * )
cat << _EOF_

Working with directory:
${d}

-- directory structure true for hekko/cyberfolks

clean domain
Files older than ${at} days
#   and less than ${as} MB make .zip and remove
#   and greater than ${as} MB just remove
#   .zip stored at ${arh}

scan (domain)
#   checks how many GB saved with given days and size

Usage:
<command> (domain OR "*") (days > 6) (size > 1)

_EOF_
esac
