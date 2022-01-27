#!/bin/bash

read -p "This should be ran in repo directory, OK? (y/N): " yn
case "$yn" in [yY]*) ;; *) echo "Abort."; exit ;; esac

# fetch all updates
git fetch --all
git fetch upstream

# update local upstream/master branch
git checkout master-upstream
git pull

# update local master
git checkout master
git rebase upstream/master

# push to folked repo without husky checks
HUSKY=0 git push -f origin master

# cleanup old reference for removed remote branch
git remote prune origin

# confirm result
git branch -vv
