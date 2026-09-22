# Git ------------------------------------------------------------------------
alias gx='gitx'

alias ga='git add -v'
alias gb='git branch -a -v'
alias gc='git commit'
alias gd='git diff'
# Race-free `git pull`: background auto-fetches (git-auto-fetch plugin, VS Code
# autofetch) rewrite .git/FETCH_HEAD mid-pull, causing "Cannot rebase onto
# multiple branches". fetch + rebase uses the remote-tracking ref instead of
# FETCH_HEAD, so concurrent fetches can't break it. Assumes pull.rebase=true.
unalias gp 2>/dev/null
function gp {
  if (( $# )); then
    git pull "$@"
  else
    git fetch && git rebase
  fi
}
alias gr='git remote -v'

alias gs='git status'
#alias gg='gs -s' # short status
alias gpp='gp && git push -v'

alias gtm='git checkout master 2>/dev/null || git checkout main'
function gtb() {
    # Get local branches, excluding any checked out in a worktree (can't switch to those).
    # %(worktreepath) is empty unless the branch is checked out somewhere (current or a linked worktree).
    LOCAL=$(git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short) %(worktreepath)' | awk '$2 == "" {print "local: " $1}')

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
