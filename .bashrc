# I know I've used that command before...
export HISTSIZE=20000
# Append to the history, rather than overwriting it
shopt -s histappend
# Concatenate multi-line commands
shopt -s cmdhist
# Ignore duplicates, ls without options and builtin commands
HISTCONTROL=ignoredups
export HISTIGNORE="&:ls:l:p:[bf]g:exit"
export EDITOR="vim"
alias p="pwd"
alias mate="mate -d"
alias vi=vim
alias vim=vim
#single tab auto-completition
set show-all-if-ambiguous on
#auto-completion shows stats similiar to ls -F
set visible-stats on

source ~/.bash_global

export PATH=$PATH:/usr/local/bin:/usr/local/mysql/bin/:/opt/local/bin:/opt/local/sbin

export LPS_HOME=~/dev/src/svn/openlaszlo/pagan-deities
export LZXDOC_HOME=~/dev/tools/lzxdoc
export TOMCAT_HOME=~/dev/lib/apache-tomcat-6.0.16
export CATALINA_HOME=$TOMCAT_HOME

export APPS_COMMON_ROOT=~/dev/apps/common

# we _xmlplus, which I put here to stay out of the /System dir
export PYTHONPATH=/usr/local/lib/python2.3/site-packages

# in case you want to override default JAVA_HOME
#export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/1.4.2/home"

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

. ~/dev/src/svn/tools/trunk/env/setup-lps.sh $LPS_HOME
