# Bashrc: only bash settings
# - Colors
# - History
# - Misc
# - Prompts
# - Imports

# If not running interactively, don't do anything, to stop bind errors
[ -z "$PS1" ] && return

# UTF-8 everything
#export LANG="en_US.utf8"
#export LANGUAGE="en_US.utf8"
#export LC_ALL="en_US.utf8"
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Colors -----------------------------------------------------------------------

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

if [ `uname` = FreeBSD ]; then
    export LS_OPTIONS='-G'
else
    # Probably have GNU utils installed
    export LS_OPTIONS='--color=auto'
fi

# History -----------------------------------------------------------------------

# Whenever displaying the prompt, reload history and write the previous line to disk, and update the term title
export PROMPT_COMMAND='history -a; history -n; echo -ne "\033]0; ${PWD/$HOME/~}\007"'
# Ignore common things
export HISTIGNORE="ls:ll:l:cd:p:[bf]g:exit:.:..:...:....:....."
# Ignore duplicates and lines beginnging a space in the history file
export HISTCONTROL=ignoreboth
# Store a large amount of history
export HISTSIZE=50000
# Store a timestamp of when the cmd was run, for graphing/timing purposes
export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S - '
# Concatenate multi-line commands
shopt -s cmdhist
# Append to the history, rather than overwriting it
shopt -s histappend histreedit histverify

# Misc -------------------------------------------------------------------------

# auto-completion shows stats similiar to ls -F
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


#fix color/control character issues with git, enable wrapping
#defaut : export LESS="-FXRS"
export LESS="-FXR"

export EDITOR="vim"
export PAGER=less
export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'

# Python
export PIP_RESPECT_VIRTUALENV=true
export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache

# Ruby
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
export GEM_HOME="$(brew --prefix)"

# Prompts -----------------------------------------------------------------------

source ~/.bash_prompt

# Imports ----------------------------------------------------------------------------------------------

# Turn on advanced bash completion if the file exists locally
[ -f /etc/bash_completion ] && source /etc/bash_completion

# Or if in OSX with homebrew
if $BREW_EXISTS; then
    if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
    fi
fi

# enable python virtualenv wrapper
[ -f /usr/local/bin/virtualenvwrapper.sh ] && source /usr/local/bin/virtualenvwrapper.sh

# enable python autoenv
[ -f /usr/local/opt/autoenv/activate.sh ] && source /usr/local/opt/autoenv/activate.sh

# Local bash file for machine specific tweaks/passwords
[ -f ~/.bash_local ] && source ~/.bash_local

#my imports
source ~/.bash_machines
source ~/.bash_aliases

#local version of autojump
source ~/.autojump.bash

#crazy imports
source ~/.bash_app_specific

# django 1.4 complete (because I'm always using django)
source ~/.django_bash_completion

# import any local bash completion scripts
# for f in `brew --prefix`/etc/bash_completion.d/*; do source $f; done
# for file in ~/.bash_completion; do
#     #ignore directory itself
#     if [ -f $file ]; then
#         # source $file
#         echo
#     fi
# done
