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

source ~/.svn_bash_completion

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi


export PATH=/usr/local/bin:$PATH:.:/opt/local/bin:/opt/local/sbin
### Prompt variable
#PS1="\h:\W\$ "
PS1='\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

### Standard variables
#change the titlebar in xterms
PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'
#PROMPT_COMMAND='RET=$?; if [[ $RET = 0 ]]; then echo -ne "\033[0;32m$RET\033[0m ;)"; else echo -ne "\033[0;31m$RET\033[0m :("; fi; echo -n " "'
export PAGER=/usr/bin/less
export BROWSER='firefox'
export LS_OPTIONS='-F -h'
export CC=/usr/bin/gcc
#OSX color support
export CLICOLOR=1
# Make perl localization work
export LC_ALL=C
export LANGUAGE=en_US
alias p="pwd"
alias mate="mate -d"
alias vi=vim
alias vim=vim
alias pine=alpine
alias mail=alpine

# enable color support of ls and also add handy aliases (Linux)
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    export LS_OPTIONS='-F -h --color'
    alias dir='dir --color'
    alias vdir='vdir --color'
fi

### Standard Aliases
alias ls='ls $LS_OPTIONS'
#alias rm="rm -i"
alias ll="ls -l"
alias lo="ls -o"
alias lh="ls -lh"
alias la="ls -la"
alias sl="ls"
alias l="ls -CF"
alias s="ls"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias grep="egrep --color"
alias egrep='egrep --color'
alias G="grep"
alias paux="ps aux|grep -i"
alias c="clear"
alias bc='bc -lq'
alias man="man -a"
alias logout="clear; logout"
alias searchy="apt-cache search"
alias info="info --vi-keys"
alias nslookup="nslookup -sil"
alias ducks="du -ms *|sort -n"
alias duckshid="du -ms .*|sort -n"
alias watch="watch -d"
alias wget="wget -c"
alias xterm="xterm -bg black -fg white"
alias of="open ."
alias py="python"
alias h='history | tail -n 30'
alias H='history | G'

### Miniscripts
alias wgetdir="wget -r -nH --no-parent"
alias wgetmirror="wget --mirror -U Firefox/3.0 -p -erobots=off --html-extension --convert-links"
alias tree="ls -R | grep ':$' | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias svndiffvim='svn diff --diff-cmd ~/bin/svnvimdiff'

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

### Remote Machines
alias fury="ssh askedrlc@fury.csh.rit.edu -D 7025"
alias loki="ssh askedrelic@loki.rh.rit.edu -D 7025"

alias loki-mysql="ssh -L 3306:localhost:3306 askedrelic@loki.rh.rit.edu"
