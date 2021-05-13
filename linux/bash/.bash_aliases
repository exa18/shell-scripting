#
#	VARIABLES (settings)
#
shMSX="/media/hdd/WorkingBe/msx"
shJPGRE="40"
#
#	ALIASES
#
alias ll='ls -alFh'
alias l='ls -CF'
alias dff='df -h | grep -P "(^File|\/sd)" --color=never'
alias dus='du -h --max-depth=1 --exclude="lost+found"'
alias cp='rsync -rav'
alias hist='cat ~/.bash_history | grep'
alias psk='sudo grep psk= /etc/NetworkManager/system-connections/* | awk -F/ '"'"'{print $NF}'"'"' '
#
#	apt & update
#
alias i='sudo apt -y install'
alias S='apt show'
alias s='apt list'
alias r='sudo apt -y remove'
alias u='[ -e ~/update.sh ] && sudo ~/update.sh'
#
#	gfx
#
alias psd2jpg='x=1 ; sp="/-\|" ; echo -n " "; for i in *.psd ; do echo -ne "\b${sp:x++%${#sp}:1}" ; convert "$i[0]" -background white -flatten -quality 97 "${i%.*}.jpg" ; done ; echo -ne "\b"'
alias jpgre='re(){ r="${shJPGRE}"; [ -n "$1" ] && r="${1}"; readarray -t arr <<< $(ls -1 *.jpg | grep -E -v "*_re*"); x=0; sp="/-\|"; lc=${#arr[@]}; if [ -n "$lc" ]; then for i in "${arr[@]}"; do convert "$i" -resize "${r}%" -sharpen 0x1 -quality 95 "${i%.*}_re${r}.jpg" && echo -ne "\r${sp:x++%${#sp}:1} ${x} / $(( x *100 / lc )) %"; done; fi ; echo -ne "\r \n"; };re'
#
#	msx
#
alias m='msx(){ if [ -z "$1" ] || [ "$1" = "--" ];then [ -d $shMSX/$2 ] && ls -1 "$shMSX/$2"; else [ -d $shMSX/$1 ] && tizonia "$shMSX/$1"; fi; };msx'
alias ms='tizonia --youtube-audio-search'
alias ml='tizonia --youtube-audio-playlist'
#
#	shortcuts
#
alias nmap='sudo nmap'
alias sc='shellcheck -S warning'
alias e='ex(){ if [ -z "$1" ];then ls -F | awk "/\*$/{print}" | sed "s/.$//"; else exe="./${1}"; [ -e "$exe" ] && bash $exe; fi; };ex'
alias kc='[ -e ~/kc.sh ] && ~/kc.sh || echo "KC.sh not found"'

