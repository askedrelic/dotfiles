# Identify OS and Machine -----------------------------------------
export OS=`uname -s | sed -e 's/ *//g;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
export OSVERSION=`uname -r`; OSVERSION=`expr "$OSVERSION" : '[^0-9]*\([0-9]*\.[0-9]*\)'`
export MACHINE=`uname -m | sed -e 's/ *//g;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
export PLATFORM="$MACHINE-$OS-$OSVERSION"
# Note, default OS is assumed to be OSX

# SSH Agent ------------------------------------------------------------
# from http://help.github.com/working-with-key-passphrases/
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
  echo "Initializing new SSH agent..."
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo succeeded
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
# if [ "$OS" = "darwin" ] ; then
# fi

#add /usr/local/bin for homebrew, before everything else
if [ -d /usr/local/bin ]; then
  export PATH=/usr/local/bin:$PATH
fi

#add your bin folder to the path, if you have it. It's a good place to add all your scripts
if [ -d ~/bin ]; then
  export PATH=~/bin:$PATH
fi

#add local ruby gems
if [ -d ~/.gem/ruby/1.8/bin ]; then
  export PATH=~/.gem/ruby/1.8/bin:$PATH
fi

#add local dir last
export PATH=$PATH:.
# export PATH=$PATH:.:/sbin:/usr/sbin

# Load in .bashrc -------------------------------------------------
source ~/.bashrc

# Hello Messsage --------------------------------------------------
echo -e "Kernel Information: " `uname -smr`
#echo -e "${COLOR_BROWN}`bash --version`"
echo -ne "${COLOR_GRAY}Uptime: "; uptime
echo -ne "${COLOR_GRAY}Server time is: "; date

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
