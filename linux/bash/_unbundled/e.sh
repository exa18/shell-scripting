#!/bin/bash
#
#
if [ -z "$1" ];then
    readarray -t arr <<< $(ls -F1 | awk "/\*$/{print}" | sed "s/.$//")
    if [[ $(wc -w <<< "${arr[@]}") -gt 0 ]];then
        for v in "${arr[@]}"; do
            head -c 8 $v | grep -E "^#!" >/dev/null && echo $v
        done
    fi
else
    if [ "$1" = "sudo" ];then
        s="$1 "
        shift
    fi
    $s./$*
fi
