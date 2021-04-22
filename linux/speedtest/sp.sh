#!/bin/bash
#
#   Speedtest and save result to file
#
r='sp_result'
temp='sp_temp'
csv="${r}.csv"  #formated for Excel
txt="${r}.txt"  #raw
history=91  # days
#
# test if installed
#
run=''
command -v speedtest >/dev/null || run="SPEEDTEST-CLI"
[ -n "${run}" ] && echo "...need to install ${run}" && exit

    # date D U
    addCsv () {
        local s="${1}"
        s="${1:8:2}-${1:5:2}-${1::4} ${1:(-5)}"
        echo "${s};${2//./,};${3//./,}" >> ${csv}
    }
    addTxt () {
        echo -e "${1}\t${2}\t${3}" >> ${txt}
    }
    getDate () {
        [ -z "${1}" ] && echo "$(date '+%Y-%m-%d %H:%M')" || echo "$(date '+%Y-%m-%d' -d "${1} day ago")"
    }
#
#   start
#
if [ -z "${1}" ] && [ "$1" != "-r" ];then
    #
    #   Pick net speed D/U
    #
    [ -e ${csv} ] || echo "time;D;U" > ${csv}
    [ -e ${txt} ] || echo -e "time\tD\tU" > ${txt}
    d=$(getDate)
    speedtest --secure --simple > ${temp}
    readarray -t arr <<< $(cat ${temp} | grep -E '([0-9]{1,3}\.[0-9]{2})\s(Mbit\/s)' | awk '{print $2}')
    addCsv "${d}" "${arr[0]}" "${arr[1]}"
    addTxt "${d}" "${arr[0]}" "${arr[1]}"

else
    #
    #   Removes old data from logs
    #	/ option -r  -> second arg modify history long
    #
    [ -n "${2}" ] && [ ${2} -gt 1 ] && history=${2}
    d=$(getDate ${history})
    #
    # Year remove if apply
    #
        readarray -t arr < ${txt}
        da=$(echo "${arr[1]}" | awk '{print $1}')
        da=${da::4}
        if [ ${d%%-*} -eq ${da} ];then
            grep -v "${da}-" ${txt} > ${temp}; mv ${temp} ${txt}
        fi
    #
    # Remove day by day
    #
    while [ -n "${d}" ];do
        readarray -t arr < ${txt}
        da=$(echo "${arr[1]}" | awk '{print $1}')
        s=${da% *} && s=${s//-/}
        if [ ${s} -lt ${d//-/} ];then
            grep -v "${da}" ${txt} > ${temp}; mv ${temp} ${txt}
        else
            break
        fi
    done
    #
    # Rebuild CSV from TXT
    #
    i=1
    readarray -t arr < ${txt}
    for va in "${arr[@]}"; do
        if [ -n "${i}" ];then
            echo "time;D;U" > ${csv}
            i=''
        else
            da=$(echo "${va}" | awk '{print $1" "$2}')
            d=$(echo "${va}" | awk '{print $3}')
            u=$(echo "${va}" | awk '{print $4}')
            addCsv "${da}" "${d}" "${u}"
        fi
    done
fi
# end & clear temps
rm ${temp}
