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
    # Get local branches, remove asterisk and clean whitespace
    LOCAL=$(git branch --sort=-committerdate | sed 's/^[* ] *//' | sed 's/^/local: /')

    # Get remote branches, filter out HEAD references, remove origin/ prefix, and mark as remote
    REMOTE=$(git branch --remote --sort=-committerdate | grep -v 'HEAD ->' | sed 's|origin/||' | sed 's/^  *//' | sed 's/^/remote: /')

    # Combine and pass to fzf, then extract just the branch name
    SELECTED=$(printf "%s\n%s" "$LOCAL" "$REMOTE" | fzf --height=20 --reverse --preview 'git log --oneline -10 {2}' --preview-window=right:60%)

    if [ -n "$SELECTED" ]; then
        BRANCH=$(echo "$SELECTED" | cut -d' ' -f2)
        TYPE=$(echo "$SELECTED" | cut -d':' -f1)

        if [ "$TYPE" = "remote" ]; then
            # For remote branches, create local tracking branch
            git checkout -b "$BRANCH" "origin/$BRANCH" 2>/dev/null || git checkout "$BRANCH"
        else
            # For local branches, just checkout
            git checkout "$BRANCH"
        fi
    fi
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
