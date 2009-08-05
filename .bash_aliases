# Colors ----------------------------------------------
if [ "$OS" = "linux" ] ; then
  alias ls='ls --color=auto -F -h' # For linux, etc
  alias dir='dir --color'
  alias vdir='vdir --color'
  eval "`dircolors -b`"
  # ls colors, see: http://www.linux-sxs.org/housekeeping/lscolors.html
  #export LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rb=90' #LS_COLORS is not supported by the default ls command in OS-X
else
  alias ls='ls -G' # OS-X SPECIFIC - the -G command in OS-X is for colors, in Linux it's no groups
fi

# History ----------------------------------------------------------------------------------------------
alias h='history | tail -n 30'
alias hf='history | G'

# Navigation ----------------------------------------------------------------------------------------------
cl() { cd $1; ls -la; }
alias ~="cd ~"
alias u="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias ll="ls -F -h -l"
alias la="ls -F -h -la"
alias lo="ls -F -h -o"
alias lh="ls -F -h -lh"
alias l="ls -F -h -CF"
alias p="pwd"

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
alias ducks='du -cks * | sort -rn | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done'
alias watch="watch -d"
alias wget="wget -c"
alias py="python"
alias pine=alpine

# Shows most used commands, cool script I got this from: http://lifehacker.com/software/how-to/turbocharge-your-terminal-274317.php
alias profileme="history | awk '{print \$5}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"

### Miniscripts
alias wgetdir="wget -r -nH --no-parent"
alias wgetmirror="wget --mirror -U Firefox/3.0 -p -erobots=off --html-extension --convert-links"
alias simpletree="ls -R | grep ':$' | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias svndiffvim='svn diff --diff-cmd ~/bin/svnvimdiff'

