# User configuration


# Prefer US English and use UTF-8
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"


# do not add % to highlight partial lines
export PROMPT_EOL_MARK=''

export ZSH_DISABLE_COMPFIX="true"
export DISABLE_AUTO_TITLE='true'

# Antidote --------------------------------------------------------------------

# use slower 5m interval
GIT_AUTO_FETCH_INTERVAL=300

# Enable completions from brew
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  autoload -Uz compinit && compinit
fi

# init antidote from brew
# https://getantidote.github.io/install
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

# reset rm -i flag from common-aliases plugin
alias rm=rm

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias ibrew="arch -x86_64 /usr/local/bin/brew $@"
alias brewr=ibrew
alias leg="arch -x86_64 $@"

# enable emacs bindings for ctrl-a/ctrl-e
bindkey -e

# reverse history serach
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# Setup useful history format
alias history="history -i"
export HIST_STAMPS="yyyy-mm-dd"

# Prompt -----------------------------------------------------------------------------------------------

# https://starship.rs/
eval "$(starship init zsh)"

# Use acctivator for python venvs
# https://github.com/Yelp/aactivator
eval "$(aactivator init)"

# Colors -----------------------------------------------------------------------

# set colors for displaying directories and files when the ls command is used
# export LSCOLORS='GxFxCxDxBxegedabagaced'

LS_COLORS='di=1;36:ln=1;35:so=1;32:pi=1;33:ex=1;31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=34;43'
export LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
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

# History -----------------------------------------------------------------------
# https://zsh.sourceforge.io/Doc/Release/Options.html#Options

export HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
# Ignore common things; bash only?
export HISTIGNORE="ls:ll:l:cd:p:[bf]g:exit:.:..:...:....:.....:cd -:pwd:exit:date:* --help"
# remove unnecessary blanks
setopt HIST_IGNORE_SPACE
# ignore lines beginning with a space in the history file
setopt HIST_REDUCE_BLANKS
# record command start time
setopt EXTENDED_HISTORY
# append command to history file immediately after execution
setopt INC_APPEND_HISTORY_TIME
# Larger history
export HISTSIZE=1000000
export SAVEHIST=1000000

# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY

# https://stackoverflow.com/questions/26292192/zsh-shell-does-not-recognize-git-head
# Let me use git HEAD^
unsetopt nomatch

# Misc -------------------------------------------------------------------------
export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'

# Only auto-update every 7 days
export HOMEBREW_AUTO_UPDATE_SECS=604800

# Identify OS and Machine -----------------------------------------
export OS=`uname -s | sed -e 's/ *//g;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
export OSVERSION=`uname -r`; OSVERSION=`expr "$OSVERSION" : '[^0-9]*\([0-9]*\.[0-9]*\)'`
export MACHINE=`uname -m | sed -e 's/ *//g;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
export PLATFORM="$MACHINE-$OS-$OSVERSION"

# Imports ----------------------------------------------------------------------------------------------

# enable python autoenv
[ -f /usr/local/opt/autoenv/activate.sh ] && . /usr/local/opt/autoenv/activate.sh

# Local bash file for machine specific tweaks/passwords
[ -f ~/.bash_local ] && . ~/.bash_local

# enable brew autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# import any local bash scripts
for file in ~/.bash/*.sh; do
  if [ -f "$file" ] ; then
    source "$file"
  fi
done

# Hello Messsage --------------------------------------------------
echo -e "Kernel Information: " `uname -smr`
#echo -e "${COLOR_BROWN}`bash --version`"
echo -ne "${COLOR_GRAY}Uptime: "; uptime
echo -ne "${COLOR_GRAY}Server time is: "; date
