#!/bin/bash

alias "ls"="ls --color=always"
alias "grep"="grep --color=auto"
alias "gpg"="gpg2"
#export LS_OPTIONS="--color=always"
#alias "su"="su -"
alias "ipython"="ipython3"

export EDITOR="/usr/bin/vim"
export HISTCONTROL="ignoredups"
export HISTSIZE=100000
export HISTFILESIZE=100000
# append to the history file, don't overwrite it
shopt -s histappend
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Warn if trying to exit with background jobs
shopt -s checkjobs
# Tabcompletions for hostnames from ${HOSTFILE}
shopt -s hostcomplete
# Populate with hosts to complete
HOSTFILE="${HOME}/.ssh/quick_hosts"

###########################################################
# If not running interactively, don't do anything past this
[ -z "$PS1" ] && return
###########################################################

# scale based on dpi
export QT_AUTO_SCREEN_SCALE_FACTOR=1
# colors in less
export LESS="--RAW-CONTROL-CHARS"
[[ -f ~/.config/less/termcap ]] && . ~/.config/less/termcap

# Get rid of ugly coloring
unset COLORFGBG

# These break on noninterative shells
# Turn off bell
echo -e "\033[11;0]"

# up/down for prefix search in history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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

###############################
# Activate default virtualenv #
###############################

export DEFAULT_VIRTUAL_ENV="${HOME}/venvs/std3"
if [[ -f "${DEFAULT_VIRTUAL_ENV}/bin/activate" ]]
then
    source "${DEFAULT_VIRTUAL_ENV}/bin/activate"
fi

###################################################################
# The following section allows tabcompletion of hostnames for ssh #
###################################################################

_ssh_complete() {
	local cur prev opts hosts completing
	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}
	opts="-e -X -C"
    # known hosts didn't work
    if [[ -e $HOME/.ssh/quick_hosts ]]
    then
        hosts=`cat $HOME/.ssh/quick_hosts`
    else
        hosts=""
    fi
	completing="$opts"" $hosts"
	COMPREPLY=($(compgen -W "${completing}" -- "${cur}"))
}
complete -F _ssh_complete ssh


#############################################################
# The following section allows passwordfree logins over ssh #
#############################################################

# FIXME: too late. gpg agent needs to be started earlier.
## start ssh agent, if configured
#if [[ -z ${ISSERVER} ]]; then
#    if [ -f ~/.gnupg/S.gpg-agent.ssh ]; then
#    . "$HOME/.gpgagentrc"
#    elif [[ -f "$HOME/.sshagentrc" ]]; then
#    . "$HOME/.sshagentrc"
#    fi
#fi

############################################################
# Real-time command history, to better fit long lived shells
# Could add history -n (which would sortof broadcast history between shells)
# but that could be unwanted so better run it manually
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
