# Bashrc
# Settings for bash only.
# File imports at the bottom.

#Colors ------------------------------------------------------------
export TERM=xterm-color
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1 

# Setup some colors to use later in interactive shell or scripts
export COLOR_NC='\033[0m' # No Color
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
NC=$COLOR_NC
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

export PAGER=/usr/bin/less
#fix color/control character issues with git
export LESS="-FXRS"
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
# (get it here: http://bash-completion.alioth.debian.org/ )
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
#osx brew install of bash completion
if [ `uname` = Darwin ]; then
    if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
    fi
fi

#virtualenv wrapper
#broken on linux?
# if [ -f `which virtualenvwrapper.sh` ]; then
#     . `which virtualenvwrapper.sh`
# fi

#my imports
source ~/.bash_machines
source ~/.bash_aliases

#app specific imports
source ~/.svn_bash_completion
source ~/.django_bash_completion
source ~/.git_bash_completion

#crazy imports
source ~/.bash_app_specific
source ~/.bash_help
