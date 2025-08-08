#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------
# Hugo → GitHub Pages (User site) deployer
# Source repo: this project
# Publish repo: jackolney/jackolney.github.io (branch: main)
# -----------------------------------------

# Config (user site: https://jackolney.github.io/)
PUBLIC_REMOTE="git@github.com:jackolney/jackolney.github.io.git"
PUBLIC_BRANCH="main"

# Optional commit message arg
MSG="${1:-Deploy $(date -u +'%F %T UTC')}"

echo -e "\033[0;32mDeploying updates to GitHub Pages...\033[0m"

# 0) If an old submodule setup exists, remove it (one-time self-heal)
if [ -f .gitmodules ] && grep -qE 'submodule\s+"public"' .gitmodules; then
  echo "Detected legacy submodule at 'public/'. Removing..."
  git submodule deinit -f public || true
  git rm -f public || true
  rm -rf .git/modules/public .gitmodules public
fi

# 1) Build site (production-ish)
echo "Building site with Hugo..."
hugo --minify --cleanDestinationDir

# 2) Ensure 'public/' is a standalone repo pointing at the Pages repo
if [ ! -d public ]; then
  mkdir -p public
fi

cd public

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Initialising public/ as a Git repo..."
  git init
  git remote add origin "$PUBLIC_REMOTE" || git remote set-url origin "$PUBLIC_REMOTE"
  # Create or switch to the publish branch
  git checkout -b "$PUBLIC_BRANCH"
else
  # Make sure remote/branch are correct
  git remote set-url origin "$PUBLIC_REMOTE"
  if ! git rev-parse --verify "$PUBLIC_BRANCH" >/dev/null 2>&1; then
    git checkout -b "$PUBLIC_BRANCH"
  else
    git checkout "$PUBLIC_BRANCH"
  fi
fi

# 3) Pull latest (if the branch already exists remotely)
git fetch origin "$PUBLIC_BRANCH" >/dev/null 2>&1 || true
git pull --ff-only origin "$PUBLIC_BRANCH" >/dev/null 2>&1 || true

# 4) Commit and push only if there are changes
git add -A
if git diff --cached --quiet; then
  echo "No changes to deploy."
else
  git commit -m "$MSG"
  echo "Pushing to $PUBLIC_REMOTE ($PUBLIC_BRANCH)..."
  git push origin "$PUBLIC_BRANCH"
fi

cd ..
echo -e "\033[0;32mDeploy complete.\033[0m"

# Tips:
# - Make executable:  chmod +x deploy.sh
# - Run:              ./deploy.sh "Deploy message (optional)"
