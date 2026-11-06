#!/bin/bash

# Create GitHub repos from subfolders and push them
#
# by RaveMaker - http://ravemaker.net
#
# Usage: ./multiCreate.sh [GIT_NAME] [FOLDER]
# Values fall back to settings.cfg, then interactive prompt.

# Sync all subfolders under FOLDER to GitHub as repos under GIT_NAME
function sync-tree-to-github() {
  for SUBFOLDER in $(find "$FOLDER" -maxdepth 1 -type d); do
    if [ ! "$SUBFOLDER" = "$FOLDER" ]; then
      echo "Creating $SUBFOLDER repo...."
      REPO=${SUBFOLDER##*/}
      sync-folder-to-github "$SUBFOLDER" "$GIT_NAME" "$REPO"
    fi
  done
}

# Sync one folder to a GitHub repository
function sync-folder-to-github() {
  FOLDER=$1
  GIT_NAME=$2
  REPO=$3

  echo "Create GitHub repo"
  create-github-repo "$GIT_NAME" "$REPO"

  cd "$FOLDER" || return
  if [ -d ".git" ]; then
    echo "Syncing existing git"
    git remote add origin "git@github.com:$GIT_NAME/$REPO.git"
    if [ "$DEBUG_MODE" == "false" ]; then
      git push origin master
    fi
  else
    if [ ! -f "README.md" ]; then
      echo "no README.md found."
      # Uncomment to generate README.md for each new repo without one
      # echo "generating README.md..."
      # echo "$REPO" > README.md
      # echo "========" >> README.md
    fi
    if [ ! -f "LICENSE" ]; then
      echo "no LICENSE found."
      # Uncomment to download GPL3 LICENSE for each new repo without one
      # echo "download GPL3 LICENSE..."
      # wget http://www.gnu.org/licenses/gpl.txt
      # mv gpl.txt LICENSE
    fi
    echo "Creating new git and syncing"
    if [ "$DEBUG_MODE" == "false" ]; then
      git init
      git remote add origin "git@github.com:$GIT_NAME/$REPO.git"
      git add .
      git commit -a -m "Initial commit"
      git push origin master
      # uncomment to tag all folders
      # git tag -a 1.0 -m 'version 1.0'
      # git push origin master --tags
    fi
  fi
}

# Create a repository on GitHub
function create-github-repo() {
  GIT_NAME=$1
  REPO=$2
  JSON='{"name":"'$REPO'"}'
  if [ "$DEBUG_MODE" == "false" ]; then
    curl -u "$GIT_NAME" https://api.github.com/user/repos -d "$JSON"
  else
    echo "[DEBUG] Would create repo: $GIT_NAME/$REPO"
  fi
}

# Load settings first (defaults)
if [ -f settings.cfg ]; then
  echo "Loading settings..."
  source settings.cfg
else
  echo "ERROR: Create settings.cfg (from settings.cfg.example)"
  exit 1
fi

# CLI args override settings when provided
[ -n "$1" ] && GIT_NAME="$1"
[ -n "$2" ] && FOLDER="$2"

echo ""

while [ -z "$GIT_NAME" ] || [ -z "$FOLDER" ]; do
  if [ -z "$GIT_NAME" ]; then
    echo -n "Input GitHub user name: "
    read -r GIT_NAME
  fi
  if [ -z "$FOLDER" ]; then
    echo -n "Input folder to scan and create repos: "
    read -r FOLDER
  fi
done

sync-tree-to-github
