# Bashrc
#
# Settings for bash only.
# File imports at the bottom.

#Colors ------------------------------------------------------------
export TERM=xterm-color
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1

# Setup some colors to use later in interactive shell or scripts
export COLOR_NC='\033[0m' # No Color
export NC=$COLOR_NC
export COLOR_WHITE='\033[1;37m'
export COLOR_BLACK='\033[0;30m'
export COLOR_BLUE='\033[0;34m'
export COLOR_LIGHT_BLUE='\033[1;34m'
export COLOR_GREEN='\033[0;32m'
export COLOR_LIGHT_GREEN='\033[1;32m'
export COLOR_CYAN='\033[0;36m'
export COLOR_LIGHT_CYAN='\033[1;36m'
export COLOR_RED='\033[0;31m'
export COLOR_LIGHT_RED='\033[1;31m'
export COLOR_PURPLE='\033[0;35m'
export COLOR_LIGHT_PURPLE='\033[1;35m'
export COLOR_BROWN='\033[0;33m'
export COLOR_YELLOW='\033[1;33m'
export COLOR_GRAY='\033[1;30m'
export COLOR_LIGHT_GRAY='\033[0;37m'
alias colorslist="set | egrep 'COLOR_\w*'" # lists all the colors

if [ `uname` = Darwin ]; then
    export LS_OPTIONS='-F'
else
    if [ `uname` = FreeBSD ]; then
        export LS_OPTIONS='-G'
    else
        # Probably Linux with GNU utils
        export LS_OPTIONS='--color=auto'
    fi
fi

# History -----------------------------------------------------------------------
export HISTCONTROL=ignoreboth
# Whenever displaying the prompt, reload history and write the previous line to disk:
export PROMPT_COMMAND='history -a;history -n'
export HISTIGNORE="ls:ll:l:cd:p:[bf]g:exit:.:..:...:....:....."
export HISTSIZE=15000
export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S - '
# Concatenate multi-line commands
shopt -s cmdhist
# Append to the history, rather than overwriting it
shopt -s histappend histreedit histverify

# Misc -------------------------------------------------------------------------
#auto-completion shows stats similiar to ls -F
shopt -s cdspell
# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize
#glob in case insensitive manner
shopt -s nocaseglob
# Necessary for programmable completion.
shopt -s extglob
shopt -s sourcepath
shopt -s no_empty_cmd_completion

shopt -s cdable_vars
shopt -s checkhash
# include dotfiles in globs
# (to make `mv *` include them)
shopt -s dotglob

# bash completion settings (actually, these are readline settings)
bind "set completion-ignore-case on" # note: bind used instead of sticking these in .inputrc
bind "set bell-style none" # no bell
bind "set show-all-if-ambiguous On" # show list automatically, without double tab

export PAGER=/usr/bin/less
#fix color/control character issues with git, enable wrapping
#defaut : export LESS="-FXRS"
export LESS="-FXR"
# Make perl localization work
export LC_ALL=C
export LANGUAGE=en_US

export EDITOR="vim"
export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'

# export GEM_HOME=/home/askedrelic/.gem/ruby/1.8

# Prompts -----------------------------------------------------------------------
#PS1="\h:\W\$ "
export PS1='\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#export PS1="\[${COLOR_GREEN}\]\w > \[${COLOR_NC}\]" # Primary prompt with only a path

# export PS1="\[${COLOR_RED}\]\w > \[${COLOR_NC}\]" # Primary prompt with only a path, for root, need condition to use this for root
# export PS1="\[${COLOR_GRAY}\]\u@\h \[${COLOR_GREEN}\]\w > \[${COLOR_NC}\]" # Primary prompt with user, host, and path

export PS2='> ' # Secondary prompt
export PS3='#? ' # Prompt 3
export PS4='+' # Prompt 4

# Imports ----------------------------------------------------------------------------------------------
# Turn on advanced bash completion if the file exists
# Get it here: http://www.caliban.org/bash/index.shtml#completion) or
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
# via OSX/macports: sudo port install bash-completion
if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi
#osx brew install of bash-completion
if [ -e /usr/local/bin/brew ]; then
    if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
    fi
fi

#local bashrc changes
if [ -f ~/.bash_local ]; then
    . ~/.bash_local
fi

#my imports
source ~/.bash_machines
source ~/.bash_aliases
#crazy imports
source ~/.bash_app_specific
source ~/.bash_help

# import any local bash completion scripts
# for file in ~/.bash_completion; do
#     #ignore directory itself
#     if [ -f $file ]; then
#         # source $file
#         echo
#     fi
# done

# source ~/.svn_bash_completion
# source ~/.django_bash_completion
# source ~/.git_bash_completion

#autojump
#This shell snippet sets the prompt command and the necessary aliases

#Copyright Joel Schaerer 2008, 2009
#This file is part of autojump

#autojump is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#autojump is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with autojump.  If not, see <http://www.gnu.org/licenses/>.
_autojump() 
{
        local cur
        cur=${COMP_WORDS[*]:1}
        while read i
        do
            COMPREPLY=("${COMPREPLY[@]}" "${i}")
        done  < <(autojump --bash --completion $cur)
}
complete -F _autojump j
AUTOJUMP='{ (autojump -a "$(pwd -P)"&)>/dev/null 2>>${HOME}/.autojump_errors;} 2>/dev/null'
if [[ ! $PROMPT_COMMAND =~ autojump ]]; then
  export PROMPT_COMMAND="${PROMPT_COMMAND:-:} && $AUTOJUMP"
fi 
alias jumpstat="autojump --stat"
function j { new_path="$(autojump $@)";if [ -n "$new_path" ]; then echo -e "\\033[31m${new_path}\\033[0m"; cd "$new_path";fi }
