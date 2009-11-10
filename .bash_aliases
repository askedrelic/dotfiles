# Colors ----------------------------------------------
if [ `uname` = Darwin ]; then
    export LS_OPTIONS='-F'
else
    if [ `uname` = FreeBSD ]; then
        export LS_OPTIONS='-G'
    else
        # Probably Linux with GNU utils
        export LS_OPTIONS='--color=auto'
    fi
fi

# if [ "$OS" = "linux" ] ; then
#   alias ls='ls --color=auto -F -h' # For linux, etc
#   alias dir='dir --color'
#   alias vdir='vdir --color'
#   eval "`dircolors -b`"
#   # ls colors, see: http://www.linux-sxs.org/housekeeping/lscolors.html
#   #export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rb=90' #LS_COLORS is not supported by the default ls command in OS-X
# else
#   alias ls='ls -G' # OS-X SPECIFIC - the -G command in OS-X is for colors, in Linux it's no groups
# fi

# History ----------------------------------------------------------------------------------------------
alias h='history | tail -n 30'
hf(){
  grep "$@" ~/.bash_history
}

# Navigation ----------------------------------------------------------------------------------------------
cl() { cd $1; ls -la; }
alias ~="cd ~"
alias u="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias p="pwd"

alias ls='ls $LS_OPTIONS -F -h'

alias l="ls -CF"
alias ll="ls -l"
alias la="ls -lA"
alias lo="ls -o"

#OSX: Open a Finder window at your current location
alias of="open ."

#OSX: cd's to frontmost window of Finder
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

# Search ----------------------------------------------------------------------------------------------
alias grep="egrep --color"
alias egrep='egrep --color'
alias G="grep"
alias f='find . -iname'

gns(){ # Case insensitive, excluding svn folders
      find . -path '*/.svn' -prune -o -type f -print0 | xargs -0 grep -I -n -e "$1"
  }

# Other aliases ----------------------------------------------------------------------------------------------
#alias rm="rm -i"
alias v=vim
alias vi=vim
alias vim=vim

alias mate="mate -d"
alias namoroka="/Applications/firefox/Namoroka.app/Contents/MacOS/firefox-bin -P namorka > /dev/null 2>&1 &"
alias shiretoko="/Applications/firefox/Shiretoko.app/Contents/MacOS/firefox-bin -P default > /dev/null 2>&1 &"
alias df='df -h' # Show disk usage
alias m='more'
alias paux="ps aux|grep -i"
alias c="clear"
alias bc='bc -lq'
alias man="man -a"
alias logout="clear; logout"
alias searchy="apt-cache search"
alias info="info --vi-keys"
alias nslookup="nslookup -sil"
alias ducks='du -cks * | sort -rn | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done'
alias watch="watch -d"
alias wget="wget -c"
alias py="python"
alias pine=alpine
alias rscreen="screen -R"
alias untar="tar xvzf"

# Miniscripts -----------------------------------------------------------------------------------------------
#
# Shows most used commands, from: http://lifehacker.com/software/how-to/turbocharge-your-terminal-274317.php
alias profileme="history | awk '{print \$5}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"

# Share current dir
alias webshare="python -m SimpleHTTPServer 9000"

# Get all IPs OSX/Linux compatable
alias getip="sudo ifconfig | perl -nle'/inet (\S+)/ && print $1'"

#copies folder and all sub files and folders, preserving security and dates
alias cp_folder="cp -Rpv"

# chown curren dir
alias own="sudo chown -R $USER"

# CD to bin
alias bin="cd ~/bin/"

#for when 'tree' isn't installed
alias simpletree="ls -R | grep ':$' | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"

alias atop='watch -n 3 "free; echo; uptime; echo; ps aux  --sort=-%cpu | head -n 11; echo; who"'
alias wgetdir="wget -r -nH --no-parent"
alias wgetmirror="wget --mirror -U Firefox/3.0 -p -erobots=off --html-extension --convert-links"
alias svndiffvim='svn diff --diff-cmd ~/bin/svnvimdiff'
alias openapps='lsof -P -i -n'
alias path="tr : '\n' <<<$PATH"

