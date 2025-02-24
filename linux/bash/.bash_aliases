### v. 20250205
#
#
#	VARIABLES (settings)
#
export SH_MSX="$HOME/Music"
export SH_JPGRE="40"
export SH_SPIN="/-\|"
export SH_MSXPLAYER="mocp"	#tizonia|mocp
export TIME_STYLE="+%Y.%m.%d %H:%M"
SH_IM=
[[ -n $(command -v magick) ]] && SH_IM="magick"	#IM7
[[ -n $(command -v convert) && -z $SH_IM ]] && SH_IM="convert"	#IM6
export SH_IM
#
fn_spin(){ echo "${SH_SPIN:x++%${#SH_SPIN}:1}"; }
fn_bitrate(){
	# LAME Bitrate / CBR Encoding
	# b = 8, 16, 24, 32, 40, 48, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320
	# x = 0,  1,  2,  3,  4,  5,  6,  7,  8,   9,  10,  11,  12,  13,  14,  15
	# i = 1,  2,  3,  4,  5,  6,  1,  2,  3,   4,   5,   1,   2,   3,   4,   1
	# m = 8 .................... 16  .................. 32 ................ 64
	# d = 0 .................... 48 .................. 128 ............... 256
	x=0		# counter
	i=1		# increment
	m=8		# multiply at stage
	d=0		# stage value
	#
	b=8		# bitrate
	if [[ $1 -gt 8 ]];then
		while [[ $b -lt $1 && $x -lt 16 ]];do
			if [[ $x -eq 6 || $x -eq 11 || $x -eq 15 ]];then
				m=$(( m *2 ))
				i=1
				d=$b
			fi
			b=$(( d + m * i ))
			i=$(( i +1 ))
			x=$(( x +1 ))
		done
	fi
	echo "${b}k"
}
fn_usbcheck(){ lsblk /dev/$1 -n -d -o TYPE,SUBSYSTEMS|awk '{if ($1=="disk" && match($2,"usb") ){print "Y"}}'; }
fn_waitany(){ read -n 1 -p "Any key to continue..?"; }
#
#	ALIASES
#
#   common
#
alias sudo='sudo '
if [[ -n $(command -v exa) ]];then
	alias l='exa -F'
	alias l.='exa -dF .*'
	alias ll='exa -lFh'
	alias la='exa -alFh'
else
	alias l='ls -CF'
	alias l.='ls -dF .*'
	alias ll='ls -lFh'
	alias la='ls -alFh'
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
# used with ubuntu
#alias u='fn_getkeptback(){ readarray -t pkg <<< "$(apt list --upgradable 2>/dev/null | sed 1d | awk -F/ '"'"'{print $1}'"'"')";}; s="sudo "; pro="ubuntu-advantage"; for f in /etc/apt/apt.conf.d/*apt-esm-hook.con*;do [[ ! -d ${f%/*}/off ]] && ${s}mkdir ${f%/*}/off; [[ -e $f ]] && ${s}mv -f $f ${f%/*}/off; ${s}systemctl is-enabled ${pro} >/dev/null && ${s}systemctl disable ${pro}; done; ${s}apt update -y; ${s}apt upgrade -y; ${s}apt autoremove -y; set -eu; LANG=en_US.UTF-8 snap list --all | awk '"'"'/disabled/{print $1, $3}'"'"' | while read snapname revision; do ${s}snap remove "$snapname" --revision="$revision"; done; set -u; dpkg -l | grep "^rc" | awk '"'"'{print $2}'"'"' | xargs -r ${s}dpkg --purge; set +u; fn_getkeptback; if [[ -n "${pkg[0]}" ]];then ${s}apt --fix-missing update -y; ${s}aptitude safe-upgrade --full-resolver -y; fn_getkeptback; if [[ -n "${pkg[0]}" ]];then for p in "${pkg[@]}"; do [[ -n "${p##*nvidia*}" ]] && ${s}apt upgrade -y ${p}; [[ -z "${p##*nvidia-kernel-common-*}" ]] &&  ${s}apt upgrade -y ${p}; done; fi; fi; ${s}apt autoremove -y; [[ -n $(command -v nvidia-smi) ]] && [[ $(nvidia-smi | grep -io failed | wc -m) -gt 0 ]] && echo "*** NVIDIA updated: RESTART"'
alias u='s="sudo "; ${s}apt update; u=$(apt upgrade -s 2>/dev/null |grep upgraded|awk '"'"'{t=$1+$3}END{print t}'"'"'); if [[ $u -gt 0 ]];then if [[ -n $(command -v timeshift) ]];then if [[ $(${s}timeshift --list|grep "Status"|grep -c "OK") ]];then d=$(date '"'"'+%Y-%m-%d'"'"'); x=0; tag=" --tags D"; while read t; do [[ "${t}" == "D" ]] && tag=""; x=$((x+1)); done < <(${s}timeshift --list|awk -v f="${d}" '"'"'$0~f{print $4}'"'"'); [[ $x -le 1 ]] && ${s}timeshift --create --comments "before update ${x}"${tag};fi;fi; ${s}apt upgrade -y; ${s}apt autoremove -y; set -u; dpkg -l | grep "^rc" | awk '"'"'{print $2}'"'"' | xargs -r ${s}dpkg --purge; set +u; fi'
#
#	video
#
if [[ -n $(command -v ffmpeg) ]];then
alias ffavi='fn_ffa(){ [[ -e "./${1}" ]] && ffmpeg -i "./${1}" -map 0 -pix_fmt yuv420p -c:v libx264 -crf 21 -c:a libmp3lame -b:a 128k "./${1%.*}_h264.mkv";};fn_ffa'
alias ffmp3='fn_ffmp3(){ [[ -e "./${1}" ]] && ffmpeg -i "./${1}" -c:a libmp3lame -b:a $bt -map a "./${1%.*}.mp3";}; fn_ffmp3ch(){ if [[ -e "./${1}" ]];then ff="${1}"; shift; fi; [[ -z $1 ]] && bt="192k" || bt=$(fn_bitrate $1); if [[ -n $ff ]];then fn_ffmp3 "$ff"; else for i in *.mp4 ; do fn_ffmp3 "$i"; done; fi;}; fn_ffmp3ch'
fi
#
#	gfx
#
if [[ -n $SH_IM ]];then
alias psd2jpg='x=1 ; echo -n " "; for i in *.psd ; do echo -ne "\b$(fn_spin)"; $SH_IM "$i[0]" -background white -flatten -quality 97 "${i%.*}.jpg" ; done ; echo -ne "\b"'
alias jpgre='fn_re(){ r="${SH_JPGRE}"; [[ -n "$1" ]] && r="${1}"; readarray -t arr <<< $(ls -1 *.jpg | grep -E -v "*_re*"); x=0; lc=${#arr[@]}; if [[ -n "$lc" ]]; then for i in "${arr[@]}"; do echo -ne "\r$(fn_spin) ${x} / $(( x *100 / lc )) %"; $SH_IM "$i" -resize "${r}%" -sharpen 0x1 -quality 95 "${i%.*}_re${r}.jpg"; done; fi ; echo -ne "\r \n"; };fn_re'
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
alias e='fn_ex(){ if [[ -z "$1" ]];then readarray -t arr <<< $(ls -F1 | awk "/\*$/{print}" | sed "s/.$//"); [[ $(wc -w <<< "${arr[@]}") -gt 0 ]] && for v in "${arr[@]}"; do head -c 8 $v | grep -E "^#!" >/dev/null && echo $v; done; else if [[ "$1" = "sudo" ]];then s="$1 ";shift;fi; $s./$*; fi; };fn_ex'
alias tm='fn_tmdd(){ local arr=("${1::4}" "${1:4:2}" "${1:6:2}" "${1:8:2}" "${1:10:2}"); echo "${arr[@]}";}; fn_tme(){ p=($(fn_tmdd "${1}")); readarray -t list <<< "$(ls -1)"; if [[ ${#list[@]} -gt 0 ]]; then for f in "${list[@]}"; do pf=($(fn_tmdd "$(date '"'"'+%Y%m%d%H%M'"'"' -r ${f})")); d=; x=0; for v in "${pf[@]}"; do [[ ${#p[$x]} -gt 0 ]] && a=${p[$x]} || a=${v}; d=${d}${a}; x=$((x+1)); done; touch -a -m -t $d $f; done; fi;};fn_tme'
[[ -e $HOME/kc.sh ]] && alias kc='shift; $HOME/kc.sh $@'
alias psk='sudo grep psk= /etc/NetworkManager/system-connections/* | awk -F/ '"'"'{print $NF}'"'"' '
alias findusb='for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do ( syspath="${sysdevpath%/dev}"; devname="$(udevadm info -q name -p $syspath)"; [[ "$devname" == "bus/"* ]] && exit || eval "$(udevadm info -q property --export -p $syspath)"; [[ -z "$ID_SERIAL" ]] && exit || echo "/dev/$devname - $ID_SERIAL"; ); done'
alias version='fn_version(){ head -n 1 ~/$1 | awk '"'"'{print $NF}'"'"';}; echo -e "$($SHELL --version | grep version | head -n 1)\n alias: $(fn_version .bash_aliases)\n rc: $(fn_version .bashrc)";'
#
#	tools for USB device write
#
alias ddw='fn_ddww(){ [[ -e $2 ]] && [[ -n "${1}" ]] && [[ -e /dev/$1 ]] && [[ -n "$(fn_usbcheck ${1})" ]] && fn_waitany && sudo dd bs=4M if=$2 of=/dev/$1 oflag=sync status=progress; };fn_ddww'
alias ddc='fn_ddcc(){ [[ -n "${1}" ]] && [[ -e /dev/$1 ]] && [[ -n "$(fn_usbcheck ${1})" ]] && fn_waitany && sudo dd bs=4M if=/dev/zero of=/dev/$1 oflag=sync status=progress; };fn_ddcc'
#
#	editor
#
[[ -n $(command -v nvim) ]] && alias vi='nvim'
[[ -n $(command -v micro) ]] && alias mi='micro'
[[ -n $(command -v nano) ]] && alias na='nano'
