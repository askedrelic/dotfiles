#Colors ------------------------------------------------------------
export TERM=xterm-color
export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
export CLICOLOR=1 

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
export PROMPT_COMMAND='history -n;history -a'
export HISTIGNORE="ls:l:cd:p:[bf]g:exit"
export HISTSIZE=30000
export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S - '
# Concatenate multi-line commands
shopt -s cmdhist

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
export PAGER=/usr/bin/less
# Make perl localization work
export LC_ALL=C
export LANGUAGE=en_US
export EDITOR="vim"

# Prompts ----------------------------------------------------------------------- 
#PS1="\h:\W\$ "
export PS1='\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#export PS1="\[${COLOR_GREEN}\]\w > \[${COLOR_NC}\]" # Primary prompt with only a path

# export PS1="\[${COLOR_RED}\]\w > \[${COLOR_NC}\]" # Primary prompt with only a path, for root, need condition to use this for root
# export PS1="\[${COLOR_GRAY}\]\u@\h \[${COLOR_GREEN}\]\w > \[${COLOR_NC}\]" # Primary prompt with user, host, and path
 
# This runs before the prompt and sets the title of the xterm* window. If you set the title in the prompt
# weird wrapping errors occur on some systems, so this method is superior
# export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*} ${PWD}"; echo -ne "\007"' # user@host path
# Is this overriding prompt history command?
 
export PS2='> ' # Secondary prompt
export PS3='#? ' # Prompt 3
export PS4='+' # Prompt 4
 
function xtitle { # change the title of your xterm* window
  unset PROMPT_COMMAND
  echo -ne "\033]0;$1\007"
}


# Other files ----------------------------------------------------------------------------------------------
source ~/.svn_bash_completion
source ~/.django_bash_completion
source ~/.bash_app_specific
source ~/.bash_machines
source ~/.bash_aliases
