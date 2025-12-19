#!/usr/bin/env bash
# Dependencies: bash>=3.2, coreutils, file, gawk

# Makes the script more portable
#readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Optional icon to display before the text
# Insert the absolute path of the icon
# Recommended size is 24x24 px
readonly ICON="${1}"

# Some settings
readonly INFO_COLOR="#0088f0"
readonly INFO_EXTRA=

# Read RAM
readonly RAM=$(free -b)
# outputs
#               total        used        free      shared  buff/cache   available
#Mem:     33618276352  4022575104 23018414080    42000384  7077269504 29595701248
#Swap:    36507217920           0 36507217920
#
# get lines Mem and Swap
readonly RAM_MEM=$(printf "$RAM" | awk '/^[Mm]em/')
readonly RAM_SWP=$(printf "$RAM" | awk '/^[Ss]wap/')

# Calculate RAM values
readonly GIGS=1073741824	# 1024*1024*1024
readonly UNIT="GB"

# round Total to integer
readonly TOTAL=$(printf "$RAM_MEM" | awk '{$2 = $2 / 1048576/1000; printf "%.0f", $2}')
readonly USED=$(printf "$RAM_MEM" | awk -v g=$GIGS '{$3 = $3 / g; printf "%.2f", $3}')
readonly FREE=$(printf "$RAM_MEM"  | awk -v g=$GIGS '{$4 = $4 / g; printf "%.2f", $4}')
readonly SHARED=$(printf "$RAM_MEM" | awk -v g=$GIGS '{$5 = $5 / g; printf "%.2f", $5}')
readonly CACHED=$(printf "$RAM_MEM" | awk -v g=$GIGS '{$6 = $6 / g; printf "%.2f", $6}')
readonly AVAILABLE=$(printf "$RAM_MEM" | awk -v g=$GIGS '{$7 = $7 / g; printf "%.2f", $7}')

# Swap Values
if [[ -n $(printf "$RAM_SWP") ]]; then
readonly SWP_TOTAL=$(printf "$RAM_SWP" | awk -v g=$GIGS '{$2 = $2 / g; printf "%.0f", $2}')
readonly SWP_USED=$(printf "$RAM_SWP" | awk -v g=$GIGS '{$3 = $3 / g; printf "%.2f", $3}')
readonly SWP_FREE=$(printf "$RAM_SWP" | awk -v g=$GIGS '{$4 = $4 / g; printf "%.2f", $4}')
fi

# Panel
if hash xfce4-taskmanager &> /dev/null; then
	INFO_TASK="xfce4-taskmanager"
elif hash xfce4-terminal &> /dev/null; then
	if hash htop &> /dev/null; then
		INFO_TASK="xfce4-terminal -e htop"
	fi
fi

if [[ $(file -b "${ICON}") =~ PNG|SVG ]]; then
	INFO="<img>${ICON}</img>"
	[[ $INFO_TASK ]] && INFO+="<click>${INFO_TASK}</click>"
else
	[[ $INFO_TASK ]] && INFO+="<txtclick>${INFO_TASK}</txtclick>"
fi
INFO+="<txt>"
[[ $INFO_COLOR ]] && INFO+="<span foreground='${INFO_COLOR}'>"
INFO+="${USED}"
[[ $INFO_EXTRA ]] && INFO+="／${TOTAL}"
INFO+=" ${UNIT}"
[[ $INFO_COLOR ]] && INFO+="</span>"
INFO+="</txt>"

# Tooltip
MORE_INFO="<tool>"
MORE_INFO+="┌ RAM\t\t${UNIT}\n"
MORE_INFO+="├─ Used\t\t${USED}\n" 
MORE_INFO+="├─ Free\t\t${FREE}\n"
MORE_INFO+="├─ Shared\t${SHARED}\n"
MORE_INFO+="├─ Cache\t\t${CACHED}\n"
MORE_INFO+="└─ Total\t\t${TOTAL}"
MORE_INFO+="\n\n"
MORE_INFO+="┌ SWAP"
if [[ $SWP_TOTAL -gt 0 ]]; then
MORE_INFO+="\t\t${UNIT}\n"
MORE_INFO+="├─ Used\t\t${SWP_USED}\n"
MORE_INFO+="├─ Free\t\t${SWP_FREE}\n"
MORE_INFO+="└─ Total\t\t${SWP_TOTAL}"
else
MORE_INFO+="\n└─ disabled"
fi
MORE_INFO+="</tool>"

# Panel Print
echo -e "${INFO}"

# Tooltip Print
echo -e "${MORE_INFO}"
