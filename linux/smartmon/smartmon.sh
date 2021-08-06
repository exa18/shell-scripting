#!/bin/bash
#
#
    run="$(command -v smartctl)"
    [ -z "$run" ] && echo "...need to install: smartmontools" && exit
#
    [ $UID != 0 ] && echo "Please run this with sudo" && exit
    sudo ls >/dev/null
#
#
# > SET
#
    netip="192.168"
    tempalert=45
    testperiod=31
   
    mailsend=8
    mailssl=
    mailsmtp=''
    mailfrom=''
    mailpass=''
    mailto=''
    
    smssend=24
    smsnumber='+48'
    smsuserid=
    smskey='textbelt'
# <
# 
# > FUNCTIONS
#
    mailsend=$((mailsend*60))
    smssend=$((smssend*60))
    testperiod=$((testperiod*24))
    [ ${#smsuserid} -gt 0 ] && smsapi='--data-urlencode userid='$smsuserid' \'
    if [ ${#mailssl} -gt 0 ];then
        mailurls='s'
        mailurlssl=':485 --ssl-reqd'
    else
        mailurls=
        mailurlssl=':587'
    fi
#
    function sendMail(){
        curl --url smtp$mailurls://$mailsmtp$mailurlssl \
        --mail-from $mailfrom \
        --mail-rcpt $mailto \
        --user $mailfrom:$mailpass \
        -T <(echo -e "From: ${mailfrom}\nTo: ${mailto}\nSubject: ${mailsub}\n\n${mailmsg}")
    }
    #
    #   Free version permits only one per day
    #
    function sendSMS(){
        curl -X POST https://textbelt.com/text \
        --data-urlencode phone=$smsnumber \
	$smsapi
        --data-urlencode message=$smsmsg \
        -d key=$smskey
    }
# <
#
#

    infip="$(ip a | awk '/inet '$netip'/{print $2}')"
    infip="${infip##*.}"
    infhead="${USER^^}/${infip%%/*}//"

    readarray -t devs <<< "$(smartctl --scan | awk '{print $1}')"

    for i in "${devs[@]}";do
        d="${i##*/}"
        disk="${d: -1}"
        f="dev_${d}.log"
        echo "$(smartctl -a ${i})" > $f
        poh=$(cat $f | grep Power_On_Hours | awk '{print $NF}')
        lasttest=$(cat $f | grep "# 1" | awk '{print $(NF-1)}')
        period=$(bc <<< "${poh}-${lasttest}")
        # do short test after 48h
        if [ $period -gt $testperiod ];then
            w=$(echo "$(smartctl -t short ${i})" | awk '/^P.*wait [0-9]+/{print $3}')
            sleep ${w}m
            echo "$(smartctl -a ${i})" > $f
        fi
        #
        #   check health
        #
        #health=$(echo "$(smartctl -H ${i})" | awk '/: /{print $NF}')
        health=$(cat $f | awk '/-health/{print $NF}')
        #
        #   check errors
        #
        readarray -t err <<< "$(cat $f | awk '!/Spin_/ && (/Pre-fail/ && /Always/){print $2"="$10-$6}')"
        #errors=0
        txt_err=
        for j in "${err[@]}";do
            # shortcut
            d=$(echo ${j%%=*} | awk -F_ '{for(a=0;++a <= NF;) printf substr($a,1,1)}')
            # get value
            e="${j##*=}"
            #errors=$(bc <<< "${e} + ${errors}")
            # if counts error then make error string
            [ $e -gt 0 ] && txt_err+="${d}:${e} "
        done
        #
        #   check temperature
        #
        txt_temp=
        readarray -t temp <<< "$(cat $f | awk '/Temperature/{print $10}')"
        devtemp=${temp[0]}
        [ $((devtemp +1)) -gt $tempalert ] && txt_temp="T:${devtemp} "
        #
        # begin checks if errors and send info
        #
        ffsms=$(find "$(pwd)" -maxdepth 1 -type f -name 'checksms' -mmin -$smssend)
        [ ${#ffsms} -eq 0 ] && [ -e 'checksms' ] && rm checksms
        ffmail=$(find "$(pwd)" -maxdepth 1 -type f -name 'checkmail' -mmin -$mailsend)
        [ ${#ffmail} -eq 0 ] && [ -e 'checkmail' ] && rm checkmail

        if [ "${health}" != "PASSED" ] || [ ${#txt_err} -gt 0 ] || [ ${#txt_temp} -gt 0 ];then
            # send sms
            smsmsg="${infhead}${disk}:${health} ${txt_temp}${txt_err}"
            if [ ${#ffsms} -eq 0 ];then
                echo "${smsmsg}" > checksms
                #sendSMS
            fi
            # send mail
            if [ ${#ffmail} -eq 0 ];then
                mailsub="${smsmsg}"
                mailmsg=$(cat $f)
                echo "${mailsub}" > checkmail
                #sendMail
            fi

        fi


    done

