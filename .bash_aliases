#Aliases and scripts

alias v=vim
alias vi=vim
alias vg="vim -g"

alias py="python"
alias gx='gitx'
alias sourcetree='open -a SourceTree'
alias st=sourcetree

alias c="clear"

#apt shortcuts
alias birth="sudo aptitude install"
alias searchy="apt-cache search"

alias rscreen="screen -R"
alias pine=alpine
#show all types
alias type="type -a"
alias paux="ps -A|grep -i"
# human disk usage
alias df='df -h'
alias bc='bc -lq'
alias man="man -a"
alias logout="clear; logout"
alias info="info --vi-keys"
alias nslookup="nslookup -sil"
alias watch="watch -d"
alias wget="wget -c"
alias free="free -m"
alias svndiffvim='svn diff --diff-cmd ~/bin/svnvimdiff'
alias dig='dig +nocomments +nocmd +nostats'

#osx personal aliases
alias mate="mate -d"
alias mou="open -a Mou.app $*"

# QuickFolders  ----------------------------------------------------------------------------------------------

alias bin="cd ~/bin/"
alias vimbundle="cd ~/.vim/bundle/"

# History ----------------------------------------------------------------------------------------------

alias h='history | tail -n 30'
hf(){ grep "$@" ~/.bash_history; }

# Navigation ----------------------------------------------------------------------------------------------
#Silent pushd/popd functions below
alias cd='pushd'
alias b="popd"
pushd() {
    # If cd has no argument, goto home dir, like with normal cd
    if [ ! -n "$1" ]
    then
        cd ~
    else
        builtin pushd "$@" > /dev/null
    fi
    # init python autoenv manually
    [ "`type -t autoenv_init`" = 'function' ] && autoenv_init
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
alias ls="ls -Fh $LS_OPTIONS"
alias la='ls -al'          # show hidden files
alias ll='ls -al'          # show hidden files
alias lx='ls -lXB'         # sort by extension
alias lk='ls -lSr'         # sort by size, biggest last
alias lc='ls -ltcr'        # sort by and show change time, most recent last
alias lu='ls -ltur'        # sort by and show access time, most recent last
alias lt='ls -ltr'         # sort by date, most recent last
alias lr='ls -lR'          # recursive ls
alias lo="ls -o"

# alias ll='tree --dirsfirst -ChAFL 1'
alias l="la"

# OSX: Open a Finder window at your current location
alias of="open ."

# OSX: cd's to frontmost window of Finder
# eg; change finder directory
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

# OSX: change frontmost Finder window to the cwd
# eg; finder directory change
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
# Use ack for grepping and find if ack is available
if type -P ack &>/dev/null ; then
  g() {
    ag "$*" --smart-case
  }
  gw() {
    ag "$*" --smart-case --word-regexp
  }
  f() {
    #ack 1.X doesn't support case insensitive file searching, switching back to find
    #ack -i -g ".*$*[^\/]*$" | highlight blue ".*/" green "$*[^/]"
    # find . -ipath "*$**" | highlight blue ".*/" green "$*[^/]"
    ag -g "$*" -t --nocolor | highlight blue ".*/" green "$*[^/]"
  }
else
  g() {
    grep -Ri "$1" *
  }
  f() {
    find . -iname "*$**" | highlight blue ".*/" green "$*[^/]"
  }
fi

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
#for when 'tree' isn't installed
alias tree='tree -Csu'
alias simpletree="ls -aR | grep ':$' | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"

#great for finding the current "real" size of all folders/files
alias ducks="du -k | sort -n | tail -n 200 | perl -ne 'if ( /^(\d+)\s+(.*\$)/){\$l=log(\$1+.1);\$m=int(\$l/log(1024)); printf (\"%6.1f\t%s\t%25s %s\n\",(\$1/(2**(10*\$m))),((\"K\",\"M\",\"G\",\"T\",\"P\")[\$m]),\"*\"x (1.5*\$l),\$2);}' "
# old style, for comparison
# alias ducks='du -cks * | sort -rn | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done'

alias wgetdir="wget -r -nH --no-parent"
alias wgetmirror="wget --mirror -U Firefox/3.0 -p -erobots=off --html-extension --convert-links"

# Open files for open apps!
alias openapps='lsof -P -i -n'

# Print $PATH in a useful way
function path(){
    old=$IFS
    IFS=:
    printf "%s\n" $PATH
    IFS=$old
}

# honestly, who really remembers these flags? I don't anymore
function extract()
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

function countdown () { MIN=$1; for ((i=$((MIN*60));i>=0;i--));do echo -ne "\r$(date -d"0+$i sec" +%H:%M:%S)"; sleep 1; done; say -v bruce "$2";}
alias atop='watch -n 3 "free; echo; uptime; echo; ps aux  --sort=-%cpu | head -n 11; echo; who"'

if [ `uname` = Darwin ]; then
    alias top='top -o cpu'
fi

#simple password generating function
alias mkpass='echo `</dev/random tr -dc A-Za-z0-9 | head -c8`'


### Python
# simple menu system for python virtualenv
menuvirtualenv() {
    select env in `lsvirtualenv -b`; do
        if [ -n "$env" ]; then
            workon "$env"
        fi;
        break;
    done;
}
alias vmenu='menuvirtualenv'
alias vm='menuvirtualenv'

# goto the source dir of any python module
cdp () {
    cd "$(python -c "import os.path as _, ${1}; \
        print _.dirname(_.realpath(${1}.__file__[:-1]))"
    )"
}

# Subversion & Diff ------------------------------------------------
export SVN_EDITOR='${EDITOR}'

alias svshowcommands="echo -e '${COLOR_LIGHT_PURPLE}Available commands:
   ${COLOR_GREEN}sv
   ${COLOR_GREEN}sv${COLOR_NC}help
   ${COLOR_GREEN}sv${COLOR_NC}import ${COLOR_GRAY}Example: import ~/projects/my_local_folder http://svn.foo.com/bar
   ${COLOR_GREEN}sv${COLOR_NC}checkout ${COLOR_GRAY}Example: svcheckout http://svn.foo.com/bar
   ${COLOR_GREEN}sv${COLOR_NC}status
   ${COLOR_GREEN}sv${COLOR_NC}status${COLOR_GREEN}remote
   ${COLOR_GREEN}sv${COLOR_NC}add ${COLOR_GRAY}Example: svadd your_file
   ${COLOR_GREEN}sv${COLOR_NC}add${COLOR_GREEN}all${COLOR_NC} ${COLOR_GRAY}Note: adds all files not in repository [recursively]
   ${COLOR_GREEN}sv${COLOR_NC}delete ${COLOR_GRAY}Example: svdelete your_file
   ${COLOR_GREEN}sv${COLOR_NC}diff ${COLOR_GRAY}Example: svdiff your_file
   ${COLOR_GREEN}sv${COLOR_NC}diff${COLOR_GREEN}remote${COLOR_NC} ${COLOR_GRAY}Example: svdiffremote your_file
   ${COLOR_GREEN}sv${COLOR_NC}commit ${COLOR_GRAY}Example: svcommit
   ${COLOR_GREEN}sv${COLOR_NC}update ${COLOR_GRAY}Example: svupdate
   ${COLOR_GREEN}sv${COLOR_NC}get${COLOR_GREEN}info${COLOR_NC} ${COLOR_GRAY}Example: svgetinfo your_file
   ${COLOR_GREEN}sv${COLOR_NC}blame ${COLOR_GRAY}Example: svblame your_file
   ${COLOR_GREEN}sv${COLOR_NC}delete${COLOR_GREEN}svn${COLOR_NC}folders ${COLOR_GRAY}Example: svdeletesvnfolders
'"

alias sv='svn'
alias svimport='sv import'
alias svcheckout='sv checkout'
alias svstatus='sv status'
alias svupdate='sv update'
alias svstatusremote='sv status --show-updates' # Show status here and on the server
alias svcommit='sv commit'
alias svadd='sv add'
alias svaddall='sv status | grep "^\?" | awk "{print \$2}" | xargs svn add'
alias svdelete='sv delete'
alias svhelp='sv help'
alias svblame='sv blame'
alias svdeletesvnfolders='find . -name ".svn" -exec rm -rf {} \;'
alias svexcludeswpfiles='sv propset svn:ignore "*.swp" .'
alias svdeleteall='sv status | grep "^\!" | awk "{print \$2}" | xargs svn delete'
alias svlastlog='svn log -v -l 10 | less'

svgetinfo (){
   sv info $@
  sv log $@
}

if [ "$OS" = "darwin" ] ; then
  # You need to create fmdiff and fmresolve, which can be found at: http://ssel.vub.ac.be/ssel/internal:fmdiff
  alias svdiff='sv diff --diff-cmd fmdiff' # OS-X SPECIFIC
  alias svdiffremote='sv diff -r HEAD --diff-cmd fmdiff' # OS-X SPECIFIC
  # Use diff for command line diff, use fmdiff for gui diff, and svdiff for subversion diff
fi


# git ------------------------------------------------
alias gs='git status '
alias ga='git add '
alias gr='git remote -v'
alias gc='git commit'
alias gd='git diff'
alias gk='gitk --all&'

#mine
alias gg='gs -s'
alias gts='gs'
alias gtb='git branch -a -v'
alias gtr='gr'

function gb() {
    select branch in $(git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname)' | sed 's/refs\/heads\///g'); do
        git checkout "$branch"
        break;
    done;
}

# MySQL ------------------------------------------------
alias mqshowcommands="echo -e '${COLOR_LIGHT_PURPLE}Available commands:
   ${COLOR_GREEN}mq${COLOR_NC}list${COLOR_GREEN}databases${COLOR_NC}
   ${COLOR_GREEN}mq${COLOR_NC}use${COLOR_GREEN}database${COLOR_NC}
   ${COLOR_GREEN}mq${COLOR_NC}create${COLOR_GREEN}database${COLOR_NC}
   ${COLOR_GREEN}mq${COLOR_NC}drop${COLOR_GREEN}database${COLOR_NC}
   ${COLOR_GREEN}mq${COLOR_NC}list${COLOR_GREEN}tables${COLOR_NC}
   ${COLOR_GREEN}mq${COLOR_NC}list${COLOR_GREEN}fields${COLOR_NC}
   ${COLOR_GREEN}mq${COLOR_NC}run ${COLOR_GRAY}Example: mqrun \"Select id From foo\"
   ${COLOR_GREEN}mq${COLOR_NC}run${COLOR_GREEN}file${COLOR_NC} ${COLOR_GRAY}Example: mqrunfile file_name
   ${COLOR_GREEN}mq${COLOR_NC}run${COLOR_GREEN}file${COLOR_NC}to${COLOR_GREEN}file${COLOR_NC} ${COLOR_GRAY}Example: mqrunfiletofile file_name out_file_name
'"

export MYSQL_DEFAULT_DB=mysql

mqusedatabase (){
  export MYSQL_DEFAULT_DB=$@
}

mqrun (){
  mysql -u root -t -D ${MYSQL_DEFAULT_DB} -vvv -e "$@" | highlight blue '[|+-]'
}
mqrunfile (){
  mysql -u root -t -vvv ${MYSQL_DEFAULT_DB} < $@ | highlight blue '[|+-]'
}
mqrunfiletofile (){
  mysql -u root -t -vvv ${MYSQL_DEFAULT_DB} < $1 >> $2
}
mqrunfiletoeditor (){
  mysql -u root -t -vvv ${MYSQL_DEFAULT_DB} < $1 | vim -
}

alias mqlistdatabases='mqrun "show databases"'
alias mqlisttables='mqrun "show tables"'
mqlistfields(){
  mqrun "describe $@"
}

mqcreatedatabase(){
  mysqladmin -u root create $@
  echo "$@ Created" | highlight blue '.*'
}

mqdropdatabase(){
  echo Warning | highlight red '.*'
  mysqladmin -u root drop $@
}
