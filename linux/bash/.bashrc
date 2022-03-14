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
nc='\[\e[0m\]'
#PS1="\[\e[30;44m\]\u$nc"; [ "$UID" -eq "0" ] && PS1="\[\e[1;91m\]@$nc"
#PS1="$nc$PS1 \[\e[1;96m\]\w >\[\e[34m\]>$nc "

prompt='\[\e[1;34m\]'
info='\[\e[30;44m\]'
path='\[\e[1;96m\]'
if [ "$UID" -eq "0" ]; then
	prompt='\[\e[0;31m\]'
	info='\[\e[30;41m\]'
	path='\[\e[1;91m\]'
fi
#show_host='╱\h'

# TWOLINE
#┌── user╱host ──┤~│
#└─┤
PS1=$nc$prompt'┌──'$nc$info' \u${show_host} '$nc$prompt'──┤'$path'\w'$prompt'│\n'$nc$prompt'└─┤'$nc
# ONELINE
# user╱host ─┤~│ 
#PS1=$nc$info' \u '$nc$prompt'─┤'$path'\w'$prompt'│ '$nc
