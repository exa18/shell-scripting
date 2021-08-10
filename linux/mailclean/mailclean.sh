#!/bin/bash
#
#   Remove mails older than 90 days
#	and older than 30 days and larger than 5 MB
#   -- directory structure true for hekko/cyberfolks
#
#   Setting to adjust
ad=90   # older than
as=5    # limit size of file in MB
al=30   # file greater than size and older than
#   prepare paths
verbose=    # verbose if arg starts with --
[ -n "${1}" ] && domain="${1#--*}" && verbose="${1::2}" # set domain name
[ -z "${domain}" ] && domain="*"
#
#   // Real path on server
#
d="${HOME}/imap/${domain}/*/Maildir/cur/"
#
t=$(date "+%Y%m%d")
arh="${HOME}/mail_arch/${t}.zip"
#
#
[ "${verbose}" = "--" ] && echo -e "Start cleaning for domain: ${domain}\n...making ZIParhive: ${arh}"
#
#   very OLD mail up to size limit and make archive
[ "${verbose}" = "--" ] && echo "Archive files older than ${ad} days and up to ${as} MB"
find $d -maxdepth 1 -type f -name "*" -mtime +${ad} -size -${as}M -print | zip -@q9 $arh
#
#   remove all very old files
[ "${verbose}" = "--" ] && echo "-- now remove them"
find $d -maxdepth 1 -type f -name "*" -mtime +${ad} | xargs rm
#   LARGE files remove
[ "${verbose}" = "--" ] && echo "Remove files older than ${al} days and over ${as} MB"
find $d -maxdepth 1 -type f -name "*" -mtime +${al} -size +${as}M | xargs rm
[ "${verbose}" = "--" ] && echo "DONE."

