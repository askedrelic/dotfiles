#fix OSX /etc/zprofile messing with things
#https://stackoverflow.com/a/60987764

# update the $PATH
[[ -f ~/.zshenv ]] && source ~/.zshenv
# # remove duplicate $PATH
typeset -U PATH
