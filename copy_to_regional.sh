#!/bin/bash

# Script to copy all code from D2026-Practice to D2026-Regional via a pull request
# Usage: ./copy_to_regional.sh

set -e  # Exit on error

echo "=================================="
echo "Copy D2026-Practice to D2026-Regional"
echo "=================================="
echo ""

# Configuration
REGIONAL_REPO="https://github.com/DRIFT-4091/D2026-Regional.git"
PRACTICE_REPO="https://github.com/DRIFT-4091/D2026-Practice.git"
BRANCH_NAME="sync-from-practice-$(date +%Y%m%d-%H%M%S)"
TEMP_DIR="/tmp/d2026-regional-sync"

# Clean up any existing temp directory
if [ -d "$TEMP_DIR" ]; then
    echo "Cleaning up existing temp directory..."
    rm -rf "$TEMP_DIR"
fi

# Step 1: Clone D2026-Regional
echo "Step 1: Cloning D2026-Regional repository..."
git clone "$REGIONAL_REPO" "$TEMP_DIR"
cd "$TEMP_DIR"

# Step 2: Add D2026-Practice as a remote
echo "Step 2: Adding D2026-Practice as remote..."
git remote add practice "$PRACTICE_REPO"
git fetch practice

# Step 3: Create new branch
echo "Step 3: Creating branch '$BRANCH_NAME'..."
git checkout -b "$BRANCH_NAME"

# Step 4: Get the current branch of practice (usually main)
PRACTICE_BRANCH=${1:-main}
echo "Step 4: Checking out files from practice/$PRACTICE_BRANCH..."

# Remove all files except .git
find . -maxdepth 1 ! -name '.git' ! -name '.' ! -name '..' -exec rm -rf {} +

# Checkout all files from practice
git checkout "practice/$PRACTICE_BRANCH" -- .

# Step 5: Commit changes
echo "Step 5: Committing changes..."
git add .
git commit -m "Sync all code from D2026-Practice repository

This commit copies all code from the D2026-Practice repository.
All source files, configurations, and dependencies have been synchronized."

# Step 6: Push branch
echo "Step 6: Pushing branch to origin..."
git push origin "$BRANCH_NAME"

# Step 7: Create PR (if gh CLI is available)
echo "Step 7: Creating pull request..."
if command -v gh &> /dev/null; then
    gh pr create \
        --title "Sync code from D2026-Practice" \
        --body "This PR copies all code from the D2026-Practice repository to D2026-Regional.

## Changes
- Synchronized all source code from D2026-Practice
- Updated all configuration files
- Updated all dependencies

## Review Notes
- Please review the README.md as it may need updates
- Verify all functionality after merging" \
        --base main \
        --head "$BRANCH_NAME"
    echo "Pull request created successfully!"
else
    echo "GitHub CLI (gh) not found. Please create the PR manually:"
    echo "https://github.com/DRIFT-4091/D2026-Regional/compare/main...$BRANCH_NAME"
fi

echo ""
echo "=================================="
echo "Sync completed successfully!"
echo "Branch: $BRANCH_NAME"
echo "Directory: $TEMP_DIR"
echo "=================================="
