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

# setup homebrew
export BREW_EXISTS=false
if [ -e /usr/local/bin/brew ]; then
  export BREW_EXISTS=true
fi

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
# Add my paths, in reverse priority, so that they are prepend properly

#add local ruby gems (don't think this matters anymore)
if [ -d ~/.gem/ruby/1.8/bin ]; then
  export PATH=~/.gem/ruby/1.8/bin:$PATH
fi

# add brew installed ruby gems
if $BREW_EXISTS; then
    if [ -d "$(brew --prefix ruby)/bin" ]; then
    export PATH="$(brew --prefix ruby)/bin:$PATH"
    fi
fi

#add local python programs
#if [ -d ~/Library/Python/2.7/bin ]; then
#  export PATH=~/Library/Python/2.7/bin:$PATH
#fi
if [ -d /usr/local/share/python ]; then
  export PATH=/usr/local/share/python:$PATH
fi

# add brew installed node/npm modules
if [ -d /usr/local/share/npm/bin ]; then
  export PATH=/usr/local/share/npm/bin:$PATH
fi

#add /usr/local/bin for OSX/homebrew
if [ -d /usr/local/bin ]; then
  export PATH=/usr/local/bin:$PATH
fi

# source brew installed coreutils
if $BREW_EXISTS; then
    if [ -d "$(brew --prefix coreutils)/libexec/gnubin" ]; then
    export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
    fi
fi

# Local bin should always be first priority
if [ -d ~/bin ]; then
  export PATH=~/bin:$PATH
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Load in .bashrc -------------------------------------------------
source ~/.bashrc

# Hello Messsage --------------------------------------------------
echo -e "Kernel Information: " `uname -smr`
#echo -e "${COLOR_BROWN}`bash --version`"
echo -ne "${COLOR_GRAY}Uptime: "; uptime
echo -ne "${COLOR_GRAY}Server time is: "; date
