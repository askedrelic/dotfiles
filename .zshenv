# setup PATH vars here
# https://zsh.sourceforge.io/Intro/intro_3.html

# SSH Agent ------------------------------------------------------------
# TODO

# Path ------------------------------------------------------------

# unique paths!
typeset -U path

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

eval "$(/opt/homebrew/bin/brew shellenv)"

#fix color/control character issues with git, enable wrapping
#defaut : export LESS="-FXRS"
export LESS="-FXR"

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

export EDITOR="vim"
export PAGER=less

export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
