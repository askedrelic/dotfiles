# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="ys"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
export DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# do not add % to highlight partial lines
export PROMPT_EOL_MARK=''

export ZSH_DISABLE_COMPFIX="true"

# plugins here: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
plugins=(
  autojump
  common-aliases
  extract
  fzf
  git
  git-auto-fetch
  gitfast # git / tig completiions https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gitfast
  macos
  tmux
)

source $ZSH/oh-my-zsh.sh

alias rm=rm

# User configuration

# use slow autofetch? seconds
GIT_AUTO_FETCH_INTERVAL=300

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias ibrew="arch -x86_64 /usr/local/bin/brew $@"
alias brewr=ibrew
alias leg="arch -x86_64 $@"

# Use acctivator for python venvs
# https://github.com/Yelp/aactivator
eval "$(aactivator init)"

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

# Prompt -----------------------------------------------------------------------------------------------

# https://starship.rs/
eval "$(starship init zsh)"

# Colors -----------------------------------------------------------------------

# set colors for displaying directories and files when the ls command is used
export LSCOLORS='GxFxCxDxBxegedabagaced'
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
setopt EXTENDED_HISTORY
# Ignore common things; bash only?
export HISTIGNORE="ls:ll:l:cd:p:[bf]g:exit:.:..:...:....:.....:cd -:pwd:exit:date:* --help"
# ignore lines beginning with a space in the history file
setopt HIST_IGNORE_SPACE
# Larger history
export HISTSIZE=100000

# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST
# # do not store duplications
setopt HIST_IGNORE_DUPS
# #ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# # removes blank lines from history
setopt HIST_REDUCE_BLANKS

# share history across multiple zsh sessions
setopt SHARE_HISTORY
# # append to history
setopt APPEND_HISTORY
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY

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
