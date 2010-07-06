#Aliases and scripts

# History ----------------------------------------------------------------------------------------------
alias h='history | tail -n 30'
hf(){ grep "$@" ~/.bash_history; }

# Navigation ----------------------------------------------------------------------------------------------
#Silent pushd/popd functions below
alias cd='pushd'
alias b="popd"
pushd() {
    #If cd has no argument, goto home dir, like with normal cd
    if [ ! -n "$1" ]
    then
        cd ~
    else

        builtin pushd "$@" > /dev/null
    fi
}
popd() {
    builtin popd "$@" > /dev/null
}
alias ~="cd ~"
alias u="cd .."
alias d="dirs -v"
alias p="pwd"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

#cd and ls
cl() { cd $1; ls -la; }

#ls and its options
alias ls='ls $LS_OPTIONS -Fh'
alias la='ls -Al'          # show hidden files
alias lx='ls -lXB'         # sort by extension
alias lk='ls -lSr'         # sort by size, biggest last
alias lc='ls -ltcr'        # sort by and show change time, most recent last
alias lu='ls -ltur'        # sort by and show access time, most recent last
alias lt='ls -ltr'         # sort by date, most recent last
alias lr='ls -lR'          # recursive ls
alias lo="ls -o"

alias ll='tree --dirsfirst -ChAFL 1'
alias l="la"

#CD to bin
alias bin="cd ~/bin/"

#OSX: Open a Finder window at your current location
alias of="open ."

#OSX: cd's to frontmost window of Finder
cdf() {
    currFolderPath=$( /usr/bin/osascript << EOT
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


#OSX: change frontmost Finder window to the cwd
fdc() {
    if [ -n "$1" ]; then
        if [ "${1%%/*}" = "" ]; then
            thePath="$1"
        else
            thePath=`pwd`"$1"
        fi
    else
        thePath=`pwd`
    fi

    /usr/bin/osascript << EOT
        set myPath to ( POSIX file "$thePath" as alias )
        try
            tell application "Finder" to set the (folder of the front window) to myPath
        on error -- no open folder windows
            tell application "Finder" to open myPath
        end try
EOT
}

# Search ----------------------------------------------------------------------------------------------
alias a="ack"
alias g="grep"
#use findr.sh wrapper script; see ~/bin/findr.sh
alias f='findr.sh'

gns(){ # Case insensitive, excluding svn folders
      find . -path '*/.svn' -prune -o -type f -print0 | xargs -0 grep -I -n -e "$1"
}

# Other aliases ----------------------------------------------------------------------------------------------
#used to be called 'which', probably shouldn't override default linux programs

#goto the source dir of any python module
cdp () {
    cd "$(python -c "import os.path as _, ${1}; \
        print _.dirname(_.realpath(${1}.__file__[:-1]))"
    )"
}

# Show disk usage
alias df='df -h'

#apt shortcuts
alias birth="sudo aptitude install"
alias searchy="apt-cache search"

alias v=vim
alias vi=vim
# alias vim='~/bin/mvim'   
# alias mvim='~/bin/mvim -g'
alias c="clear"
# alias j='jobs -l'
alias py="python"
alias rscreen="screen -R"
alias pine=alpine

#show all types
alias type="type -a"
alias paux="ps -A|grep -i"
alias bc='bc -lq'
alias man="man -a"
alias logout="clear; logout"
alias info="info --vi-keys"
alias nslookup="nslookup -sil"
alias watch="watch -d"
alias wget="wget -c"
alias free="free -m"
alias svndiffvim='svn diff --diff-cmd ~/bin/svnvimdiff'

#osx personal aliases
alias mate="mate -d"

# Miniscripts -----------------------------------------------------------------------------------------------
# Shows most used commands, from: http://lifehacker.com/software/how-to/turbocharge-your-terminal-274317.php
alias profileme="history | awk '{print \$5}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"

# Share current dir
alias sharethisdir="echo 'now sharing cur directory at port 9000'; python -m SimpleHTTPServer 9000"

# Get all IPs OSX/Linux compatable
alias myip='curl "http://www.networksecuritytoolkit.org/nst/cgi-bin/ip.cgi"'

#copies folder and all sub files and folders, preserving security and dates
alias cp_folder="cp -Rpv"

# chown curren dir
alias own="sudo chown -R $USER"

#TODO: combine tree/simpletree
# nice alternative to 'recursive ls'
alias tree='tree -Csu'
#for when 'tree' isn't installed
alias simpletree="ls -aR | grep ':$' | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"

#great for finding the current "real" size of all folders/files
alias ducks='du -cks * | sort -rn | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done'

alias wgetdir="wget -r -nH --no-parent"
alias wgetmirror="wget --mirror -U Firefox/3.0 -p -erobots=off --html-extension --convert-links"
alias openapps='lsof -P -i -n'

#prints the path in a useful fashion
alias path="tr : '\n' <<<$PATH"

function extract()      # Handy Extract Program.
{
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *.7z)        7z x $1         ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

function ps() { /bin/ps $@ -u $USER -o pid,%cpu,%mem,command ; }
function pp() { ps -f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }

alias atop='watch -n 3 "free; echo; uptime; echo; ps aux  --sort=-%cpu | head -n 11; echo; who"'

function ii()   # Get current host related info.
{
    echo -e "\nYou are logged on ${COLOR_RED}$HOSTNAME"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${COLOR_RED}Users logged on:$NC " ; w -h
    echo -e "\n${COLOR_RED}Current date :$NC " ; date
    echo -e "\n${COLOR_RED}Machine stats :$NC " ; uptime
    echo -e "\n${COLOR_RED}Memory stats :$NC " ; free
    getip 2>&- ;
    echo -e "\n${COLOR_RED}Local IP Address :$NC" ; getip;
    echo -e "\n${COLOR_RED}Open connections :$NC "; netstat -pan --inet;
    echo
}
