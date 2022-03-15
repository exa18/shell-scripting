#
#	VARIABLES (settings)
#
export SH_MSX="/media/hdd/WorkingBe/msx"
export SH_JPGRE="40"
export SH_SPIN="/-\|"
#
#	ALIASES
#
alias ll='ls -alFh'
alias l='ls -CF'
alias l.='ls -dF .*'
alias dff='df -h | grep -P "(^File|\/sd)" --color=never'
alias dus='du -h --max-depth=1 --exclude="lost+found"'
alias cp='rsync -rav'
alias hist='cat ~/.bash_history | grep'
alias psk='sudo grep psk= /etc/NetworkManager/system-connections/* | awk -F/ '"'"'{print $NF}'"'"' '
alias findusb='for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do ( syspath="${sysdevpath%/dev}"; devname="$(udevadm info -q name -p $syspath)"; [[ "$devname" == "bus/"* ]] && exit || eval "$(udevadm info -q property --export -p $syspath)"; [[ -z "$ID_SERIAL" ]] && exit || echo "/dev/$devname - $ID_SERIAL"; ); done'
#
#	apt & update
#
alias i='sudo apt -y install'
alias I='sudo apt -y reinstall'
alias S='apt show'
alias s='apt list'
alias r='sudo apt -y remove'
alias u='s="sudo "; ${s}apt update -y && ${s}apt upgrade -y && ${s}apt autoremove -y; set -eu; LANG=en_US.UTF-8 snap list --all | awk '"'"'/disabled/{print $1, $3}'"'"' | while read snapname revision; do ${s}snap remove "$snapname" --revision="$revision"; done; set -u; dpkg -l | grep "^rc" | awk '"'"'{print $2}'"'"' | xargs -r ${s}dpkg --purge; set +u'
#
#	gfx
#
alias psd2jpg='x=1 ; echo -n " "; for i in *.psd ; do echo -ne "\b${SH_SPIN:x++%${#SH_SPIN}:1}"; convert "$i[0]" -background white -flatten -quality 97 "${i%.*}.jpg" ; done ; echo -ne "\b"'
alias jpgre='re(){ r="${SH_JPGRE}"; [ -n "$1" ] && r="${1}"; readarray -t arr <<< $(ls -1 *.jpg | grep -E -v "*_re*"); x=0; lc=${#arr[@]}; if [ -n "$lc" ]; then for i in "${arr[@]}"; do echo -ne "\r${SH_SPIN:x++%${#SH_SPIN}:1} ${x} / $(( x *100 / lc )) %"; convert "$i" -resize "${r}%" -sharpen 0x1 -quality 95 "${i%.*}_re${r}.jpg"; done; fi ; echo -ne "\r \n"; };re'
#
#	msx
#
alias m='msx(){ if [ -z "$1" ] || [ "$1" = "--" ];then [ -d $SH_MSX/$2 ] && ls -1 "$SH_MSX/$2"; else [ -d $SH_MSX/$1 ] && tizonia "$SH_MSX/$1"; fi; };msx'
alias ms='tizonia --youtube-audio-search'
alias ml='tizonia --youtube-audio-playlist'
#
#	shortcuts
#
alias nmap='sudo nmap'
alias sc='shellcheck -S warning'
alias e='ex(){ if [ -z "$1" ];then readarray -t arr <<< $(ls -F1 | awk "/\*$/{print}" | sed "s/.$//"); [[ $(wc -w <<< "${arr[@]}") -gt 0 ]] && for v in "${arr[@]}"; do head -c 8 $v | grep -E "^#!" >/dev/null && echo $v; done; else if [ "$1" = "sudo" ];then s="$1 ";shift;fi; $s./$*; fi; };ex'
alias tm='tmdd(){ local arr=("${1::4}" "${1:4:2}" "${1:6:2}" "${1:8:2}" "${1:10:2}"); echo "${arr[@]}";}; tme(){ p=($(tmdd "${1}")); readarray -t list <<< "$(ls -1)"; if [ ${#list[@]} -gt 0 ]; then for f in "${list[@]}"; do pf=($(tmdd "$(date '"'"'+%Y%m%d%H%M'"'"' -r ${f})")); d=; x=0; for v in "${pf[@]}"; do [ ${#p[$x]} -gt 0 ] && a=${p[$x]} || a=${v}; d=${d}${a}; x=$((x+1)); done; touch -a -m -t $d $f; done; fi;};tme'
alias kc='[ -e ~/kc.sh ] && ~/kc.sh || echo "KC.sh not found"'
