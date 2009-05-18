# Identify OS and Machine -----------------------------------------
export OS=`uname -s | sed -e 's/ *//g;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
export OSVERSION=`uname -r`; OSVERSION=`expr "$OSVERSION" : '[^0-9]*\([0-9]*\.[0-9]*\)'`
export MACHINE=`uname -m | sed -e 's/ *//g;y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/'`
export PLATFORM="$MACHINE-$OS-$OSVERSION"
# Note, default OS is assumed to be OSX
 
 
# Path ------------------------------------------------------------
if [ "$OS" = "darwin" ] ; then
  export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:$PATH # OS-X Specific, with MacPorts and MySQL installed
  #export PATH=/opt/local/bin:/opt/local/sbin:$PATH # OS-X Specific, with MacPorts installed
fi
 
if [ -d ~/bin ]; then
  export PATH=:~/bin:$PATH # add your bin folder to the path, if you have it. It's a good place to add all your scripts
fi

export PATH=/usr/local/bin:$PATH:.:/opt/local/bin:/opt/local/sbin
 
# Load in .bashrc -------------------------------------------------
source ~/.bashrc
 
test -r /sw/bin/init.sh && . /sw/bin/init.sh
 
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
