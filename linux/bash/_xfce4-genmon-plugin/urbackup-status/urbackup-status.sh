#!/usr/bin/env bash
# Dependencies: bash>=3.2, coreutils, file, gawk, (tela-icon-theme), urbackup-client
#

if hash urbackupclientctl &> /dev/null; then

readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

readonly URB=$(urbackupclientctl status)

readonly URB_LBT=$(printf "$URB"|grep last_backup_time|awk '{printf "%u",$NF}')
readonly URB_CONNECTED=$(printf "$URB"|grep internet_connected|grep -o true|wc -l)
readonly URB_SERVER=$(printf "$URB"|grep \"name\"|sed 's/"//g'|awk '{printf "%s",$NF}')
readonly URB_PDONE=$(printf "$URB"|grep percent_done|awk '{printf "%u",$NF}')
readonly URB_STAT=$(printf "$URB"|grep internet_status|grep -oE "(connected|wait|fail)")

#readonly ICO_ERROR="/usr/share/icons/Tela-dark/22/emblems/emblem-error.svg"
#readonly ICO_OFF="/usr/share/icons/Tela-dark/22/emblems/emblem-unavailable.svg"
#readonly ICO_WORK="/usr/share/icons/Tela-dark/22/emblems/emblem-synchronizing.svg"
#readonly ICO_OK="/usr/share/icons/Tela-dark/22/emblems/emblem-success.svg"

readonly ICO_ERROR="${DIR}/urbackup_bad.svg"
readonly ICO_OFF="${DIR}/urbackup_progress-pause.svg"
readonly ICO_WORK="${DIR}/urbackup_progress.svg"
readonly ICO_OK="${DIR}/urbackup_ok.svg"

case "${URB_STAT}" in
	"connected")
		INFO+"<img>${ICO_OK}</img>"
		#INFO+="<span fgcolor='Green'>()</span>"
	;;
	"wait")
		INFO="<img>${ICO_OFF}</img>"
	;;
	"fail")
		INFO="<img>${ICO_ERROR}</img>"
	;;
	*)
		INFO="<img>${ICO_ERROR}</img>"
	;;
esac
[[ ${URB_PDONE} -gt 0 ]] && INFO="<img>${ICO_WORK}</img>"

INFO+="<txt>"
INFO+="</txt>"

MORE_INFO="<tool>"
[[ ${URB_PDONE} -gt 0 ]] && MORE_INFO+="--> working: ${URB_PDONE}%\n\n"
MORE_INFO+="last backup:\n$(date -d @$URB_LBT +%c)"
MORE_INFO+="\n\n--> connected: "
[[ ${URB_CONNECTED} -gt 0 ]] && MORE_INFO+="internet" || MORE_INFO+="local"
MORE_INFO+="\n--> ${URB_SERVER}"
MORE_INFO+="</tool>"

echo -e "${INFO}"
echo -e "${MORE_INFO}"

else
	# not installed
	echo -e "<txt>ERROR!</txt>"
fi
