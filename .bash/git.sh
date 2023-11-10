# Git ------------------------------------------------------------------------
alias gx='gitx'

alias ga='git add -v'
alias gb='git branch -a -v'
alias gc='git commit'
alias gd='git diff'
alias gp='git pull || git pull' # git pull fails when git-fetch is running in the background, so try twice
alias gr='git remote -v'

alias gs='git status'
alias gg='gs -s' # short status

alias gtm='git checkout master || git checkout main'
function gtb() {
    LOCAL="$(git branch --sort=-committerdate)"
    REMOTE="$(git branch --remote --sort=-committerdate)"
    git checkout "$(echo $LOCAL$REMOTE | fzf | tr -d '[:space:]')"
}

# OLD my manual select way
# function gtb() {
#     select branch in $(git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname)' | sed 's/refs\/heads\///g'); do
#         git checkout "$branch"
#         break;
#     done;
# }

# Pull all repos in a folder
alias git-pull-all="find . -maxdepth 3 -name .git -type d | rev | cut -c 6- | rev | xargs -I {} git -C {} pull"
