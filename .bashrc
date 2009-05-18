#If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Concatenate multi-line commands
shopt -s cmdhist
# check the window size after each command and, if necessary,                                                                        
# update the values of LINES and COLUMNS.                                                                                            
shopt -s checkwinsize  

#single tab auto-completition
set show-all-if-ambiguous on
set completion-ignore-case on
#fix spelling errors in cd
shopt -s cdspell
#auto-completion shows stats similiar to ls -F
set visible-stats on

# Append to the history, rather than overwriting it
shopt -s histappend
# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth
# Whenever displaying the prompt, reload history and write the previous line to disk:
PROMPT_COMMAND='history -n;history -a'
export HISTIGNORE="&:ls:l:p:[bf]g:exit"
export HISTSIZE=20000
export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S - '

export EDITOR="vim"

source ~/.bash_global
source ~/.svn_bash_completion

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export PATH=/usr/local/bin:$PATH:.:/opt/local/bin:/opt/local/sbin
