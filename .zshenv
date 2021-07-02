# setup PATH vars here
# https://zsh.sourceforge.io/Intro/intro_3.html

# Identify OS and Machine -----------------------------------------
export OS=`uname -s | sed -e 's/ *//g;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
export OSVERSION=`uname -r`; OSVERSION=`expr "$OSVERSION" : '[^0-9]*\([0-9]*\.[0-9]*\)'`
export MACHINE=`uname -m | sed -e 's/ *//g;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
export PLATFORM="$MACHINE-$OS-$OSVERSION"

# SSH Agent ------------------------------------------------------------
# TODO

# Path ------------------------------------------------------------
# In reverse priority, so that they are prepended properly

# brew installed node/npm modules
if [ -d /usr/local/share/npm/bin ]; then
  export PATH=/usr/local/share/npm/bin:$PATH
fi

# add /usr/local/bin for OSX/homebrew
# but it is already added mostly?
# if [ -d /usr/local/bin ]; then
#   export PATH=/usr/local/bin:$PATH
# fi

# homebrew programs using sbin...
if [ -d /usr/local/sbin ]; then
  export PATH=/usr/local/sbin:$PATH
fi
# 2021: M1 macbook homebrew uses /opt/ now
if [ -d /opt/homebrew/bin ]; then
  export PATH=/opt/homebrew/bin:$PATH
fi

# Cache these because homebrew is hella slow
export HAS_HOMEBREW=`command -v brew`
export GNUBIN_PATH="$(brew --prefix coreutils)/libexec/gnubin"
export GETTEXT_PATH="$(brew --prefix gettext)/bin"
# homebrew installed coreutils
if [[ -n $HAS_HOMEBREW && -d $GNUBIN_PATH ]] ; then
    export PATH="$GNUBIN_PATH:$PATH"
fi

# homebrew installed gettext
if [[ -n $HAS_HOMEBREW && -d $GETTEXT_PATH ]] ; then
    export PATH="$GETTEXT_PATH:$PATH"
fi

# if homebrew rbenv is present, configure it for use
if which rbenv > /dev/null; then
    # enable shims and auto-completion
    eval "$(rbenv init -)"
fi

# ditto for pyenv
if which pyenv > /dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
fi

# Add Go paths next
export GOPATH=~/.gopath
mkdir -p $GOPATH
# If go exists, use it
if [[ -d $GOPATH ]]; then
    export GOBIN=$GOPATH/bin
    export PATH=$GOBIN:$PATH
fi

# Local bin should always be first priority
if [[ -d ~/bin ]]; then
  export PATH=~/bin:$PATH
fi
if [[ -d ~/.local/bin ]]; then
  export PATH=~/.local/bin:$PATH
fi

if [[ -e ~/.dotfiles/bin ]]; then
  export PATH=~/.dotfiles/bin:$PATH
fi

# pathlight fixes
export PATH="/usr/local/opt/python@3.8/bin:$PATH"
export PATH="/usr/local/opt/node@10/bin:$PATH"

# Hello Messsage --------------------------------------------------
echo -e "Kernel Information: " `uname -smr`
#echo -e "${COLOR_BROWN}`bash --version`"
echo -ne "${COLOR_GRAY}Uptime: "; uptime
echo -ne "${COLOR_GRAY}Server time is: "; date
