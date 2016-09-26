# Scripts/functions
# Generally, more complex aliases

# OSX audio toggles
audio-usb() {
    echo "setting all audio to audinst usb"
    SwitchAudioSource -t system -s "Audinst HUD-mx1"
    SwitchAudioSource -t output -s "Audinst HUD-mx1"
}
audio-system() {
    SwitchAudioSource -t system -s "Built-in Output"
    SwitchAudioSource -t output -s "Built-in Output"
}
# Generally, this doesn't work, setting itunes Airplay works better
audio-airplay() {
    echo "setting all audio to airplay"
    SwitchAudioSource -t system -s "AirPlay"
    SwitchAudioSource -t output -s "AirPlay"
}
itunes-system() {
    /usr/bin/osascript << EOT
    tell application "iTunes"
        # possible values for kind are computer/AirPort Express/Apple TV/AirPlay device/unknown
        set newAirplayDevice to (get some AirPlay device whose kind is computer)
        set current AirPlay devices to {newAirplayDevice}
        # reset itunes volume
        set the sound volume to 100
    end tell
EOT
}
itunes-appletv() {
    /usr/bin/osascript << EOT
    tell application "iTunes"
        # possible values for kind are computer/AirPort Express/Apple TV/AirPlay device/unknown
        set newAirplayDevice to (get some AirPlay device whose kind is Apple TV)
        set current AirPlay devices to {newAirplayDevice}
        # don't blow the speakers
        set the sound volume to 60
    end tell
EOT
}
itunes-airplay() {
    /usr/bin/osascript << EOT
    tell application "iTunes"
        # possible values for kind are computer/AirPort Express/Apple TV/AirPlay device/unknown
        set newAirplayDevice to (get some AirPlay device whose kind is AirPort Express)
        set current AirPlay devices to {newAirplayDevice}
        # don't blow the speakers
        set the sound volume to 60
    end tell
EOT
}


# Better copy: copies folder and all sub files and folders, preserving security and dates
alias cp_folder="cp -Rpv"

# chown current directory
alias own="sudo chown -R $USER"

# Searching: Use ag for grepping, if available
if type -P ag &>/dev/null ; then
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

# Shows most used commands, from: http://lifehacker.com/software/how-to/turbocharge-your-terminal-274317.php
alias profileme="history | awk '{print \$5}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"

# Share current dir
alias sharethisdir="echo 'now sharing cur directory at port 9000'; python -m SimpleHTTPServer 9000"

# External IP lookup, my own app
alias myip='curl https://ipster.apps.asktherelic.com'

# Get rid of those pesky .DS_Store files recursively
alias dsclean='find . -type f -name .DS_Store -print0 | xargs -0 rm'

# simple tree backup program
alias simpletree="ls -aR | grep ':$' | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"

# If tree is installed; use it or fallback
if [[ -n $(command -v tree) ]] ; then
    alias tree=tree
else
    alias tree=simpletree
fi

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
    echo $PATH | sed 's#:#\n#g'
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

function pp() {
    ps -f | awk '!/awk/ && $0~var' var=${1:-".*"} ;
}

function countdown () {
    MIN=$1; for ((i=$((MIN*60));i>=0;i--));do echo -ne "\r$(date -d"0+$i sec" +%H:%M:%S)"; sleep 1; done; say -v bruce "$2";
}
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
# alias vmenu='menuvirtualenv'
# alias vm='menuvirtualenv'

# goto the source dir of any python module
cdp () {
    cd "$(python -c "import os.path as _, ${1}; \
        print _.dirname(_.realpath(${1}.__file__[:-1]))"
    )"
}

# Print OSX wifi history
wifi_history() {
    defaults read /Library/Preferences/SystemConfiguration/com.apple.airport.preferences | grep LastConnected -A 7
}

# Git ------------------------------------------------------------------------

alias gs='git status '
# short status
alias gg='gs -s'
alias ga='git add -v'
alias gr='git remote -v'
alias gc='git commit'
alias gd='git diff'

#mine
# alias gts='gs'
alias gb='git branch -a -v'
# alias gtr='gr'

function gtb() {
    select branch in $(git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname)' | sed 's/refs\/heads\///g'); do
        git checkout "$branch"
        break;
    done;
}

# Pylint ---------------------------------------------------------------------

# Show files that have been added, modified, changed, or renamed in the
# current branch (in a commit)
bchanged() {
    git diff --name-only $(git merge-base origin/master HEAD) HEAD
}

# Filter to only the python files that have been changed in the branch
bpychanged() {
    bchanged | grep "\.py$" --color="never"
}

# Run pylint on all files that have been modified in the
# working directory
pychk() {
    git status --porcelain | grep "\.py$" --color="never" | awk '{print $2}' | xargs pylint
}

# Run pylint on all files that have commited modifications in this branch
bpychk() {
    for file in "$(bpychanged)"; do
        echo $file
        [ -e "$file" ] && pylint $file
    done
}

