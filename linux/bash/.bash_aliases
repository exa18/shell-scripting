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
#
#	apt & update
#
alias i='sudo apt -y install'
alias I='sudo apt -y reinstall'
alias S='apt show'
alias s='apt list'
alias r='sudo apt -y remove'
alias u='[ -e ~/update.sh ] && sudo ~/update.sh'
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
alias e='ex(){ if [ -z "$1" ];then ls -F | awk "/\*$/{print}" | sed "s/.$//"; else [ -e "$1" ] && bash $@; fi; };ex'
alias kc='[ -e ~/kc.sh ] && ~/kc.sh || echo "KC.sh not found"'

