# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
		*i*) ;;
			*) return;;
esac

HISTCONTROL=ignoreboth
HISTSIZE=
HISTFILESIZE=

shopt -s checkwinsize
shopt -s autocd
shopt -s histappend

# simple oneline twoline
PROMPT_STYLE=twoline

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
		test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
		alias ls='ls --color=auto --time-style=iso'
		alias grep='grep --color=auto'
		alias fgrep='fgrep --color=auto'
		alias egrep='egrep --color=auto'
fi

if [ -f ~/.bash_aliases ]; then
		. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi
#
#   ----------- MODS
#
# enable terminal linewrap
setterm -linewrap on

# colorize man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
export LESSHISTFILE=-
# remove autocd output
exec {BASH_XTRACEFD}>/dev/null
#
#   ------------ PROMPT
#
#show_host='╱\h'	# uncomment to show HOST
nc='\[\e[0m\]'
# color: blue
prompt='\[\e[1;34m\]'
info='\[\e[30;44m\]'
path='\[\e[0;96m\]'
pathcheck='\[\e[1;96m\]'
user="\u"
if [[ $UID -eq 0 ]]; then
	# color: red
	prompt='\[\e[0;31m\]'
	info='\[\e[30;41m\]'
	path='\[\e[0;91m\]'
	pathcheck='\[\e[1;91m\]'
	user="@"
fi
user="$nc$info $user$show_host $nc"

parse_forhome(){ [[ "${a:0:${#HOME}}" == "${HOME}" ]] && a="${a/${HOME}/\~}"; r="${a##*/}"; }
parse_prompt(){
	psgit=
	[[ ! $UID -eq 0 ]] && [[ -n $(command -v git) ]] && psgit="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
	d="$(pwd -P)"
	if [[ -n "$psgit" ]]; then
		g="$(git rev-parse --show-toplevel)"
		a="${g}"; parse_forhome
		psprompt="$prompt$psgit $nc$path${a%%${r}}$pathcheck$r$nc$path${d#${g}}"
	else
		a="${d}"; parse_forhome
		psprompt="$path${a%%${r}}$nc$pathcheck$r"
	fi
	printf "$nc$psprompt$nc"
}
set_prompt(){
	case "$PROMPT_STYLE" in
	twoline)
		# TWOLINE
		#┌── user╱host ──┤~│
		#└─┤
		PS1="\r$nc$prompt┌──$user$prompt──┤$(parse_prompt)$prompt│\n$prompt└─┤$nc"
		;;
	oneline)
		# ONELINE
		# user╱host ─┤~│ 
		PS1="\r$nc$user$prompt─┤$(parse_prompt)$prompt│$nc"
		;;
	simple|*)
		# SIMPLE Oneline
		# user╱host ~ >>
		PS1="\r$nc$user $path$(parse_prompt) $path>$pathcheck>$nc"
		;;
	esac
}
PROMPT_COMMAND="set_prompt; $PROMPT_COMMAND"