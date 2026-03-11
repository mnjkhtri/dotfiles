if status is-interactive
    set -g fish_greeting ""

    # starship prompt
    starship init fish | source

    # git
    abbr -a g    git                                   # git
    abbr -a gi   git init                              # initialize a new repo
    abbr -a gs   git status                            # see what's changed
    abbr -a ga   git add                               # stage specific files
    abbr -a gaa  git add --all                         # stage everything
    abbr -a gc   git commit -m                         # commit with inline message
    abbr -a gca  git commit --amend --no-edit          # add staged changes to last commit
    abbr -a gp   git push                              # push to remote
    abbr -a gp!  git push --force-with-lease           # safe force push
    abbr -a gpu  git push -u origin HEAD               # push new branch and set upstream
    abbr -a gl   git pull                              # pull from remote
    abbr -a gd   git diff                              # see unstaged changes
    abbr -a gds  git diff --staged                     # see staged changes
    abbr -a gco  git checkout                          # switch branch or restore file
    abbr -a gcb  git checkout -b                       # create and switch to new branch
    abbr -a gb   git branch                            # list branches
    abbr -a gbd  git branch -d                         # delete a branch
    abbr -a gst  git stash                             # stash work in progress
    abbr -a gstp git stash pop                         # restore last stash
    abbr -a grb  git rebase                            # rebase onto a branch
    abbr -a grbi git rebase --interactive              # interactive rebase
    abbr -a glo  git log --oneline --graph --decorate  # visual branch history
end
