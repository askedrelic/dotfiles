#Aliases and scripts
alias c="clear"
alias v='vim'
alias t='tig'
alias tib='tig blame -C'

alias df='df -h' # human disk usage
# alias vg="vim -g"
alias vi='vim'
alias py="python"

alias bc='bc -lq'
alias man="man -a"
alias dig='dig +nocomments +nocmd +nostats'
alias free="free -m"
alias info="info --vi-keys"
alias type="type -a" #show all types
alias wget="wget -c"
alias paux="ps -A|grep -i"
alias pine='alpine'
alias mux=tmuxinator

alias rscreen="screen -R"
alias logout="clear; logout"
alias nslookup="nslookup -sil"
alias searchy="apt-cache search"
alias sourcetree='open -a SourceTree'
alias svndiffvim='svn diff --diff-cmd ~/bin/svnvimdiff'
alias watch="watch -d"

# osx personal aliases
alias mate="mate -d"
alias mou="open -a Mou.app $*"

# QuickFolders  ----------------------------------------------------------------------------------------------

alias vimbundle="cd ~/.vim/bundle/"
alias dotfiles="cd ~/.dotfiles"

# History ----------------------------------------------------------------------------------------------

alias h='history | tail -n 30'
# History Find
hf(){ grep "$*" ~/.zsh_history; }

# Navigation ----------------------------------------------------------------------------------------------

# Silent pushd/popd functions below
# NOTE (2018): this breaks somethings weirdly
alias cd='pushd'
# back
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
    #[ "`type -t autoenv_init`" = 'function' ] && autoenv_init
}
popd() {
    builtin popd "$@" > /dev/null
}
alias d="cd"
alias p="pwd"
alias u="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# cd and ls
cl() { cd $1; ls -la; }

#ls and its options
alias ls="ls -Fh"
alias la='ls -al'          # show hidden files
# alias ll='ls -al'          # show hidden files
alias lx='ls -lXB'         # sort by extension
alias lk='ls -lSr'         # sort by size, biggest last
alias lc='ls -ltcr'        # sort by and show change time, most recent last
alias lu='ls -ltur'        # sort by and show access time, most recent last
alias lt='ls -ltr'         # sort by date, most recent last
alias lr='ls -lR'          # recursive ls
alias lo="ls -o"

alias ll='tree --dirsfirst -ChAFL 1'
alias l="la"

# OSX: Open Finder window at your current location
alias of="open ."

# OSX: Open Alfred, with location
oa() {
    if [ ! -n "$1" ]
    then
        ARGS=$(pwd)
    else
        ARGS="$@"
    fi
    osascript -e "tell application \"Alfred 4\" to search \"$ARGS\""
}

# OSX: send finder window to console
ftc() {
    currFolderPath=$( /usr/bin/osascript << EOT
        tell application "Finder"
            try
                set currFolder to (folder of the front window as alias)
            on error
                set currFolder to (path to desktop folder as alias)
            end try
            POSIX path of currFolder
        end tell

        #tell application "Path Finder"
        #    #set pathList to POSIX path of the target of the front finder window
        #    #set pathList to quoted form of pathList
        #    #set command to "clear; cd " & pathList
        #    POSIX path of the target of the front finder window
        #end tell
EOT
    )
    echo "cd to \"$currFolderPath\""
    cd "$currFolderPath"
}

# OSX: send console pwd to finder window
ctf() {
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

        # Disable for now
        #tell application "Path Finder"
        #    activate
        #    PFOpen myPath
        #end tell
EOT
}

# another idea for pathfinder
# try
#     tell application "Path Finder" to reveal "/Users/danielbeck/Downloads"
# on error
#     tell application "Finder" to reveal folder "Downloads" of home
# end try
