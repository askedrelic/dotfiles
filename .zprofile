#fix OSX /etc/zprofile messing with things
#https://stackoverflow.com/a/60987764

# update the $PATH
[[ -f ~/.zshenv ]] && source ~/.zshenv
# # remove duplicate $PATH
typeset -U PATH
# Added by OrbStack: command-line tools and integration
# Comment this line if you don't want it to be added again.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
