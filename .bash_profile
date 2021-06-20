# Notes: ----------------------------------------------------------
# When you start an interactive shell (log in, open terminal or iTerm in OS X,
# or create a new tab in iTerm) the following files are read and run, in this order:
# profile
# bashrc
# .bash_profile
# .bashrc (only because this file is run (sourced) in .bash_profile)
#
# When an interactive shell, that is not a login shell, is started
# (when you run "bash" from inside a shell, or when you start a shell in
# xwindows [xterm/gnome-terminal/etc] ) the following files are read and executed,
# in this order:
# bashrc
# .bashrc

# Identify OS and Machine -----------------------------------------
export OS=`uname -s | sed -e 's/ *//g;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
export OSVERSION=`uname -r`; OSVERSION=`expr "$OSVERSION" : '[^0-9]*\([0-9]*\.[0-9]*\)'`
export MACHINE=`uname -m | sed -e 's/ *//g;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
export PLATFORM="$MACHINE-$OS-$OSVERSION"

# SSH Agent ------------------------------------------------------------
# from http://help.github.com/working-with-key-passphrases/
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
  echo "Initializing new SSH agent..."
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  /usr/bin/ssh-add;
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
  . "${SSH_ENV}" > /dev/null
  #ps ${SSH_AGENT_PID} doesn't work under cywgin
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_agent;
  }
else
  start_agent;
fi

# Path ------------------------------------------------------------
# In reverse priority, so that they are prepended properly

# Mac OS X uses path_helper to preload PATH, clear it out first
if [ -x /usr/libexec/path_helper ]; then
    PATH=''
    eval `/usr/libexec/path_helper -s`
fi

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
if which brew > /dev/null && which rbenv > /dev/null; then
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
if [[ -e ~/.local/bin ]]; then
  export PATH=~/.local/bin:$PATH
fi

# Load in .bashrc -------------------------------------------------
source ~/.bashrc

# Hello Messsage --------------------------------------------------
echo -e "Kernel Information: " `uname -smr`
#echo -e "${COLOR_BROWN}`bash --version`"
echo -ne "${COLOR_GRAY}Uptime: "; uptime
echo -ne "${COLOR_GRAY}Server time is: "; date
