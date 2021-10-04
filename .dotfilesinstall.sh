#!/bin/sh

GIT_REPO_URL="https://github.com/samarink/dotfiles"

# ignore the folder where you'll clone it,
# so that you don't create weird recursion problems
echo ".dotfiles" >> .gitignore

# clone your dotfiles into a bare repository in a "dot" folder of your $HOME
git clone --bare $GIT_REPO_URL $HOME/.dotfiles

# define the alias in the current shell scope
alias dots='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# checkout the actual content from the bare repository to your $HOME
dots checkout

### run it if checkout fails
# mkdir -p .config-backup && \
# config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
# xargs -I{} mv {} .config-backup/{}
###

# keep status output clean
dots config --local status.showUntrackedFiles no
