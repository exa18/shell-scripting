#
#	VARIABLES (settings)
#
export SH_MSX="$HOME/Music"
export SH_JPGRE="40"
export SH_SPIN="/-\|"
export SH_MSXPLAYER="mocp"	#tizonia|mocp
fn_spin(){ echo "${SH_SPIN:x++%${#SH_SPIN}:1}"; }
#
#	ALIASES
#
#   common
#
alias sudo='sudo '
if [[ -n $(command -v exa) ]];then
	alias l='exa -F'
	alias l.='exa -dF .*'
	alias ll='exa -alFh'
else
	alias l='ls -CF'
	alias l.='ls -dF .*'
	alias ll='ls -alFh'
fi
[[ -n $(command -v netstat) ]] && alias ip='ip -c'
alias dff='df -h | grep -P "^(File|\/dev\/)" --color=never'
alias dus='du -h --max-depth=1 --exclude="lost+found"'
[[ -n $(command -v rsync) ]] && alias cp='rsync -rav --progress'
alias hist='cat $HOME/.bash_history | grep -E'
#
#	apt & update
#
alias i='sudo apt -y install'
alias I='sudo apt -y reinstall'
alias S='apt show'
alias s='apt list 2>/dev/null | grep -E'
alias r='sudo apt -y remove'
alias U='sudo apt update >/dev/null 2>&1;apt upgrade -s 2>/dev/null | grep -E "(^Inst|upgraded)"|awk '"'"'{if (NR>2) {print $2" .. "$3" to "$4")"} else {print}}'"'"';'
#alias u='fn_getkeptback(){ readarray -t pkg <<< "$(apt list --upgradable 2>/dev/null | sed 1d | awk -F/ '"'"'{print $1}'"'"')";}; s="sudo "; pro="ubuntu-advantage"; for f in /etc/apt/apt.conf.d/*apt-esm-hook.con*;do [[ ! -d ${f%/*}/off ]] && ${s}mkdir ${f%/*}/off; [[ -e $f ]] && ${s}mv -f $f ${f%/*}/off; ${s}systemctl is-enabled ${pro} >/dev/null && ${s}systemctl disable ${pro}; done; ${s}apt update -y; ${s}apt upgrade -y; ${s}apt autoremove -y; set -eu; LANG=en_US.UTF-8 snap list --all | awk '"'"'/disabled/{print $1, $3}'"'"' | while read snapname revision; do ${s}snap remove "$snapname" --revision="$revision"; done; set -u; dpkg -l | grep "^rc" | awk '"'"'{print $2}'"'"' | xargs -r ${s}dpkg --purge; set +u; fn_getkeptback; if [[ -n "${pkg[0]}" ]];then ${s}apt --fix-missing update -y; ${s}aptitude safe-upgrade --full-resolver -y; fn_getkeptback; if [[ -n "${pkg[0]}" ]];then for p in "${pkg[@]}"; do [[ -n "${p##*nvidia*}" ]] && ${s}apt upgrade -y ${p}; [[ -z "${p##*nvidia-kernel-common-*}" ]] &&  ${s}apt upgrade -y ${p}; done; fi; fi; ${s}apt autoremove -y; [[ -n $(command -v nvidia-smi) ]] && [[ $(nvidia-smi | grep -io failed | wc -m) -gt 0 ]] && echo "*** NVIDIA updated: RESTART"'
alias u='s="sudo "; ${s}apt update; u=$(apt upgrade -s 2>/dev/null |grep upgraded|awk '"'"'{t=$1+$3}END{print t}'"'"'); if [[ $u -gt 0 ]];then if [[ -n $(command -v timeshift) ]];then if [[ $(${s}timeshift --list|grep "Status"|grep -c "OK") ]];then d=$(date '"'"'+%Y-%m-%d'"'"'); x=0; tag=" --tags D"; while read t; do [[ "${t}" == "D" ]] && tag=""; x=$((x+1)); done < <(${s}timeshift --list|awk -v f="${d}" '"'"'$0~f{print $4}'"'"'); [[ $x -le 1 ]] && ${s}timeshift --create --comments "before update ${x}"${tag};fi;fi; ${s}apt upgrade -y; ${s}apt autoremove -y; set -u; dpkg -l | grep "^rc" | awk '"'"'{print $2}'"'"' | xargs -r ${s}dpkg --purge; set +u; fi'
#
#	video
#
[[ -n $(command -v ffmpeg) ]] && alias ffavi='fn_ffa(){ [[ -e "./${1}" ]] && ffmpeg -i "./${1}" -map 0 -pix_fmt yuv420p -c:v libx264 -crf 21 -c:a libmp3lame -b:a 128k "./${1%.*}_h264.mkv";};fn_ffa'
#
#	gfx
#
if [[ -n $(command -v convert) ]];then
alias psd2jpg='x=1 ; echo -n " "; for i in *.psd ; do echo -ne "\b$(fn_spin)"; convert "$i[0]" -background white -flatten -quality 97 "${i%.*}.jpg" ; done ; echo -ne "\b"'
alias jpgre='re(){ r="${SH_JPGRE}"; [[ -n "$1" ]] && r="${1}"; readarray -t arr <<< $(ls -1 *.jpg | grep -E -v "*_re*"); x=0; lc=${#arr[@]}; if [[ -n "$lc" ]]; then for i in "${arr[@]}"; do echo -ne "\r$(fn_spin) ${x} / $(( x *100 / lc )) %"; convert "$i" -resize "${r}%" -sharpen 0x1 -quality 95 "${i%.*}_re${r}.jpg"; done; fi ; echo -ne "\r \n"; };re'
fi
[[ -n $(command -v pdfseparate) ]] && alias pdf2pdf='fn_pdfs(){ [[ -e "./${1}" ]] && pdfseparate "${1}" "${1/.pdf/_%04d.pdf}";};fn_pdfs'
[[ -n $(command -v soffice) ]] && alias doc2pdf='fn_soffice(){ v=$(soffice --version | grep -oP "\d\.\d\.\d\.\d" | tr -d ".");[[ $v -ge 5262 ]] && [[ -e "${1}" ]] && soffice --headless --convert-to pdf "${1}" --outdir .;};fn_soffice'
[[ -n $(command -v gs) ]] && alias pdfnopass='fn_pdfnp(){ [[ -e "${1}" ]] && [[ -n "${2}" ]] && gs -dNOPAUSE -dBATCH -q -sDEVICE=pdfwrite -sPDFPassword="${2}" -sOutputFile="${1%.*}_np.pdf" -f "${1}";};fn_pdfnp'
#
#	msx
#
case $SH_MSXPLAYER in
tizonia)
	#
	#	TIZONIA
	#
	if [[ -n $(command -v $SH_MSXPLAYER) ]];then
alias m='fn_msx(){ if [[ -z "$1" ]] || [[ "$1" = "--" ]];then [[ -d $SH_MSX/$2 ]] && ls -1 "$SH_MSX/$2"; else [[ -d $SH_MSX/$1 ]] && tizonia "$SH_MSX/$1"; fi; };fn_msx'
alias ms='tizonia --youtube-audio-search'
alias ml='tizonia --youtube-audio-playlist'
	fi;;
mocp)
	#
	#	MOCP
	#
	if [[ -n $(command -v $SH_MSXPLAYER) ]];then
fn_msxserver(){
	mocp -S > /dev/null 2>&1
}
fn_msxserver
alias m='fn_msx(){ fn_msxserver; [[ $# -eq 0 ]] && mocp --info | grep -E --color=never "^(State|File|Title|TotalTime|TimeLeft)" && echo "*";if [[ -z "$1" ]] || [[ "$1" = "--" ]];then [[ -d $SH_MSX/$2 ]] && ls -1 "$SH_MSX/$2"; else [[ -d $SH_MSX/$1 ]] && mocp -c && mocp --append $SH_MSX/$1 && mocp --play; fi; };fn_msx'
alias ms='mocp --toggle-pause'
alias mS='[[ $(mocp --info | grep STOP | wc -l) -gt 0 ]] && mocp --play || mocp --stop'
alias mx='fn_msxserver;[[ -e $HOME/.moc/playlist.m3u ]] && [[ $(mocp --info | grep STOP | wc -l) -gt 0 ]] && mocp --play;mocp'
alias mn='mocp --next'
alias mp='mocp --previous'
alias mX='mocp -x'
	fi;;
esac
#
#	tools
#
[[ -n $(command -v nmap) ]] && alias nmap='sudo nmap'
[[ -n $(command -v shellcheck) ]] && alias sc='shellcheck -S warning'
alias e='ex(){ if [[ -z "$1" ]];then readarray -t arr <<< $(ls -F1 | awk "/\*$/{print}" | sed "s/.$//"); [[ $(wc -w <<< "${arr[@]}") -gt 0 ]] && for v in "${arr[@]}"; do head -c 8 $v | grep -E "^#!" >/dev/null && echo $v; done; else if [[ "$1" = "sudo" ]];then s="$1 ";shift;fi; $s./$*; fi; };ex'
alias tm='tmdd(){ local arr=("${1::4}" "${1:4:2}" "${1:6:2}" "${1:8:2}" "${1:10:2}"); echo "${arr[@]}";}; tme(){ p=($(tmdd "${1}")); readarray -t list <<< "$(ls -1)"; if [[ ${#list[@]} -gt 0 ]]; then for f in "${list[@]}"; do pf=($(tmdd "$(date '"'"'+%Y%m%d%H%M'"'"' -r ${f})")); d=; x=0; for v in "${pf[@]}"; do [[ ${#p[$x]} -gt 0 ]] && a=${p[$x]} || a=${v}; d=${d}${a}; x=$((x+1)); done; touch -a -m -t $d $f; done; fi;};tme'
[[ -e $HOME/kc.sh ]] && alias kc='shift; $HOME/kc.sh $@'
alias psk='sudo grep psk= /etc/NetworkManager/system-connections/* | awk -F/ '"'"'{print $NF}'"'"' '
alias findusb='for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do ( syspath="${sysdevpath%/dev}"; devname="$(udevadm info -q name -p $syspath)"; [[ "$devname" == "bus/"* ]] && exit || eval "$(udevadm info -q property --export -p $syspath)"; [[ -z "$ID_SERIAL" ]] && exit || echo "/dev/$devname - $ID_SERIAL"; ); done'
#
#	tools for USB device write
#
alias ddw='ddww(){ [[ -e $1 ]] && [[ -n "${2}" ]] && [[ -e /dev/$2 ]] && sudo dd bs=4M if=$1 of=/dev/$2 oflag=sync status=progress; };ddww'
alias ddc='ddcc(){ [[ -n "${1}" ]] && [[ -e /dev/$1 ]] && sudo dd bs=4M if=/dev/zero of=/dev/$1 oflag=sync status=progress; };ddcc'
#
#	editor
#
[[ -n $(command -v nvim) ]] && alias vi='nvim'
[[ -n $(command -v micro) ]] && alias mi='micro'
[[ -n $(command -v nano) ]] && alias na='nano'
