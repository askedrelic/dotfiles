# Bashrc: only bash settings
# - Colors
# - History
# - Misc
# - Imports

# If not running interactively, don't do anything, to stop bind errors
[ -z "$PS1" ] && return

# UTF-8 everything
# Prefer US English and use UTF-8
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Colors -----------------------------------------------------------------------

export TERM=xterm-color
# export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
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
    #export LS_OPTIONS="--color=always"
    export LS_OPTIONS=""
fi

# History -----------------------------------------------------------------------

# 1. Whenever displaying the prompt, reload history and write the previous line to disk, and update the term title
# 2. Don't overwrite existing prompt commands
MY_PROMPT='history -a; history -n; echo -ne "\033]0; ${PWD/$HOME/~}\007"'
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} ${MY_PROMPT}"
# Ignore common things
export HISTIGNORE="ls:ll:l:cd:p:[bf]g:exit:.:..:...:....:.....:cd -:pwd:exit:date:* --help"
# Ignore duplicates and lines beginnging a space in the history file
export HISTCONTROL=ignoreboth
# Larger bash history (allow 32³ entries; default is 500)
export HISTSIZE=32768
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

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

export EDITOR="vim"
export PAGER=less
export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'

# Python
export PIP_RESPECT_VIRTUALENV=true
#export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache

# Ruby
# Using rbenv currently
#export RBENV_ROOT=/usr/local/var/rbenv
#if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Python
# Ditto for pyenv
#export PYENV_ROOT=/usr/local/var/pyenv
#if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

#if [[ -e ~/.gopath/bin ]]; then
#   export PATH=~/.gopath/bin:$PATH
#fi

# Only auto-update every 7 days
export HOMEBREW_AUTO_UPDATE_SECS=604800

# Prompt -----------------------------------------------------------------------------------------------

#PS1='$(gbt $?)'
# __GIT_PROMPT_DIR=~/.bash-git-prompt/
# source ~/.bash-git-prompt/gitprompt.sh

# https://starship.rs/
eval "$(starship init bash)"

# Imports ----------------------------------------------------------------------------------------------

# Add fuzzy finder scripts
# https://github.com/junegunn/fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# enable python virtualenv wrapper
# [ -f /usr/local/bin/virtualenvwrapper.sh ] && source /usr/local/bin/virtualenvwrapper.sh

# enable python autoenv
[ -f /usr/local/opt/autoenv/activate.sh ] && source /usr/local/opt/autoenv/activate.sh

# Local bash file for machine specific tweaks/passwords
[ -f ~/.bash_local ] && source ~/.bash_local

# try enabling brew autojump
if [[ -n $(command -v brew) && -f $(brew --prefix)/etc/autojump.sh ]] ; then
    source $(brew --prefix)/etc/autojump.sh
fi

# import any local bash scripts
for file in ~/.bash/*.sh; do
  if [ -f "$file" ] ; then
    source "$file"
  fi
done

# try enable bash cbash_scriptsompletion
[ -f /etc/bash_completion ] && source /etc/bash_completion

# try enable from homebrew
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
#if [[ -n $(command -v brew) ]] ; then
#    for file in $(brew --prefix)/etc/bash_completion.d/* ; do
#        if [ -f "$file" ] ; then
#	    echo ".......... $file"
#            source "$file"
#        fi
#    done
#fi

# Add local tmuxinator bash completion
# [ -f ~/.tmuxinator.bash ] && source ~/.tmuxinator.bash
