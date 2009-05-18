#Colors ------------------------------------------------------------
export TERM=xterm-color
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1 

alias ls='ls -F -h'
if [ "$OS" = "linux" ] ; then
  alias ls='ls --color=auto' # For linux, etc
  alias dir='dir --color'
  alias vdir='vdir --color'
  eval "`dircolors -b`"
  # ls colors, see: http://www.linux-sxs.org/housekeeping/lscolors.html
  #export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rb=90' #LS_COLORS is not supported by the default ls command in OS-X
else
  alias ls='ls -G' # OS-X SPECIFIC - the -G command in OS-X is for colors, in Linux it's no groups
fi
 
# Setup some colors to use later in interactive shell or scripts
export COLOR_NC='\e[0m' # No Color
export COLOR_WHITE='\e[1;37m'
export COLOR_BLACK='\e[0;30m'
export COLOR_BLUE='\e[0;34m'
export COLOR_LIGHT_BLUE='\e[1;34m'
export COLOR_GREEN='\e[0;32m'
export COLOR_LIGHT_GREEN='\e[1;32m'
export COLOR_CYAN='\e[0;36m'
export COLOR_LIGHT_CYAN='\e[1;36m'
export COLOR_RED='\e[0;31m'
export COLOR_LIGHT_RED='\e[1;31m'
export COLOR_PURPLE='\e[0;35m'
export COLOR_LIGHT_PURPLE='\e[1;35m'
export COLOR_BROWN='\e[0;33m'
export COLOR_YELLOW='\e[1;33m'
export COLOR_GRAY='\e[1;30m'
export COLOR_LIGHT_GRAY='\e[0;37m'
alias colorslist="set | egrep 'COLOR_\w*'" # lists all the colors

# History -----------------------------------------------------------------------
export HISTCONTROL=ignoreboth
# Append to the history, rather than overwriting it
shopt -s histappend
# Whenever displaying the prompt, reload history and write the previous line to disk:
PROMPT_COMMAND='history -n;history -a'
export HISTIGNORE="ls:l:cd:p:[bf]g:exit"
export HISTSIZE=20000
export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S - '
# Concatenate multi-line commands
shopt -s cmdhist

alias h='history | tail -n 30'
alias hf='history | G'

# Misc -------------------------------------------------------------------------
#single tab auto-completition
set show-all-if-ambiguous on
#fix spelling errors in cd
set completion-ignore-case on
#auto-completion shows stats similiar to ls -F
shopt -s cdspell
set visible-stats on
# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize  
# Turn on advanced bash completion if the file exists (get it here: http://www.caliban.org/bash/index.shtml#completion)
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
#
export PAGER=/usr/bin/less
# Make perl localization work
export LC_ALL=C
export LANGUAGE=en_US

# Prompts ----------------------------------------------------------------------- 
#PS1="\h:\W\$ "
export PS1='\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#export PS1="\[${COLOR_GREEN}\]\w > \[${COLOR_NC}\]" # Primary prompt with only a path

# export PS1="\[${COLOR_RED}\]\w > \[${COLOR_NC}\]" # Primary prompt with only a path, for root, need condition to use this for root
# export PS1="\[${COLOR_GRAY}\]\u@\h \[${COLOR_GREEN}\]\w > \[${COLOR_NC}\]" # Primary prompt with user, host, and path
 
# This runs before the prompt and sets the title of the xterm* window. If you set the title in the prompt
# weird wrapping errors occur on some systems, so this method is superior
export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*} ${PWD}"; echo -ne "\007"' # user@host path
 
export PS2='> ' # Secondary prompt
export PS3='#? ' # Prompt 3
export PS4='+' # Prompt 4
 
function xtitle { # change the title of your xterm* window
  unset PROMPT_COMMAND
  echo -ne "\033]0;$1\007"
}


# Navigation ----------------------------------------------------------------------------------------------
cl() { cd $1; ls -la; }
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ll="ls -l"
alias la="ls -la"
alias lo="ls -o"
alias lh="ls -lh"
alias l="ls -CF"
alias p="pwd"

alias of="open ."
# cdf: cd's to frontmost window of Finder
cdf () 
{
    currFolderPath=$( /usr/bin/osascript <<"    EOT"
        tell application "Finder"
            try
                set currFolder to (folder of the front window as alias)
            on error
                set currFolder to (path to desktop folder as alias)
            end try
            POSIX path of currFolder
        end tell
    EOT
    )
    echo "cd to \"$currFolderPath\""
    cd "$currFolderPath"
}

# Editors ----------------------------------------------------------------------------------------------
export EDITOR="vim"
alias vi=vim
alias vim=vim
alias mate="mate -d"


# Search ----------------------------------------------------------------------------------------------
alias grep="egrep --color"
alias egrep='egrep --color'
alias G="grep"

gns(){ # Case insensitive, excluding svn folders
      find . -path '*/.svn' -prune -o -type f -print0 | xargs -0 grep -I -n -e "$1"
  }

# Other aliases ----------------------------------------------------------------------------------------------
#alias rm="rm -i"
alias m='more'
alias paux="ps aux|grep -i"
alias c="clear"
alias bc='bc -lq'
alias man="man -a"
alias logout="clear; logout"
alias searchy="apt-cache search"
alias info="info --vi-keys"
alias nslookup="nslookup -sil"
alias ducks='du -cksh * | sort -rn|head -11' # Lists folders and files sizes in the current folder
alias watch="watch -d"
alias wget="wget -c"
alias py="python"
alias pine=alpine

# Shows most used commands, cool script I got this from: http://lifehacker.com/software/how-to/turbocharge-your-terminal-274317.php
alias profileme="history | awk '{print \$5}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"

### Miniscripts
alias wgetdir="wget -r -nH --no-parent"
alias wgetmirror="wget --mirror -U Firefox/3.0 -p -erobots=off --html-extension --convert-links"
alias tree="ls -R | grep ':$' | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias svndiffvim='svn diff --diff-cmd ~/bin/svnvimdiff'


# Other files ----------------------------------------------------------------------------------------------
source ~/.svn_bash_completion
source ~/.bashrc_app_specific


### Remote Machines
alias fury="ssh askedrlc@fury.csh.rit.edu -D 7025"
alias loki="ssh askedrelic@loki.rh.rit.edu -D 7025"

alias loki-mysql="ssh -L 3306:localhost:3306 askedrelic@loki.rh.rit.edu"
