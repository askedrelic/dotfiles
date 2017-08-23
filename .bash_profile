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

# homebrew installed coreutils
if [[ -n $(command -v brew) && -d "$(brew --prefix coreutils)/libexec/gnubin" ]] ; then
    export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
fi

# homebrew installed gettext
if [[ -n $(command -v brew) && -d "$(brew --prefix gettext)/bin" ]] ; then
    export PATH="$(brew --prefix gettext)/bin:$PATH"
fi


# if homebrew rbenv is present, configure it for use
if which brew > /dev/null && which rbenv > /dev/null; then
    # Put the rbenv entry at the front of the line
    export PATH="$HOME/.rbenv/bin:$PATH"

    # enable shims and auto-completion
    eval "$(rbenv init -)"
fi

# ditto for pyenv
if which pyenv > /dev/null; then
    eval "$(pyenv init -)"
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
if [[ -e ~/.dotfiles/bin ]]; then
  export PATH=~/.dotfiles/bin:$PATH
fi

# Load in .bashrc -------------------------------------------------
source ~/.bashrc

# Hello Messsage --------------------------------------------------
echo -e "Kernel Information: " `uname -smr`
#echo -e "${COLOR_BROWN}`bash --version`"
echo -ne "${COLOR_GRAY}Uptime: "; uptime
echo -ne "${COLOR_GRAY}Server time is: "; date
