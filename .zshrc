# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

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
# DISABLE_UPDATE_PROMPT="true"

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

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  autojump
  common-aliases
  extract
  fzf
  git
  git-auto-fetch
  gitfast # git completiions https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gitfast
  github
  osx
  tmux
  zsh_reload
)

source $ZSH/oh-my-zsh.sh

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias brewr="arch -x86_64 /usr/local/bin/brew $@"
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

# ls colors
export CLICOLOR=1

# History -----------------------------------------------------------------------
# https://zsh.sourceforge.io/Doc/Release/Options.html#Options

# Ignore common things
export HISTIGNORE="ls:ll:l:cd:p:[bf]g:exit:.:..:...:....:.....:cd -:pwd:exit:date:* --help"
# ignore lines beginnging a space in the history file
setopt HIST_IGNORE_SPACE
# Larger history
export HISTSIZE=100000

# Misc -------------------------------------------------------------------------
#fix color/control character issues with git, enable wrapping
#defaut : export LESS="-FXRS"
export LESS="-FXR"

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

export EDITOR="vim"
export PAGER=less
export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'

# Only auto-update every 7 days
export HOMEBREW_AUTO_UPDATE_SECS=604800



# Imports ----------------------------------------------------------------------------------------------

# enable python autoenv
[ -f /usr/local/opt/autoenv/activate.sh ] && source /usr/local/opt/autoenv/activate.sh

# Local bash file for machine specific tweaks/passwords
[ -f ~/.bash_local ] && source ~/.bash_local

# enable brew autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# import any local bash scripts
for file in ~/.bash/*.sh; do
  if [ -f "$file" ] ; then
    source "$file"
  fi
done
