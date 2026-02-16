#!/bin/bash

# Script to copy all code from D2026-Practice to D2026-Regional via a pull request
# Usage: ./copy_to_regional.sh [branch-name]
#   branch-name: Optional, defaults to 'main'. Specifies which branch of D2026-Practice to copy.

set -e  # Exit on error

# Configuration
REGIONAL_REPO="https://github.com/DRIFT-4091/D2026-Regional.git"
PRACTICE_REPO="https://github.com/DRIFT-4091/D2026-Practice.git"
BRANCH_NAME="sync-from-practice-$(date +%Y%m%d-%H%M%S)"
TEMP_DIR=$(mktemp -d)

# Cleanup function
cleanup() {
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        echo "Cleaning up temporary directory: $TEMP_DIR"
        rm -rf "$TEMP_DIR"
    fi
    if [ -n "$TEMP_EXTRACT" ] && [ -d "$TEMP_EXTRACT" ]; then
        echo "Cleaning up extraction directory: $TEMP_EXTRACT"
        rm -rf "$TEMP_EXTRACT"
    fi
}

# Set trap to cleanup on exit
trap cleanup EXIT

echo "=================================="
echo "Copy D2026-Practice to D2026-Regional"
echo "=================================="
echo ""

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
echo "Step 4: Copying files from practice/$PRACTICE_BRANCH..."

# Use git to extract the tree from practice branch to a temp location
TEMP_EXTRACT=$(mktemp -d)
git clone --depth 1 --branch "$PRACTICE_BRANCH" "$PRACTICE_REPO" "$TEMP_EXTRACT"
cd "$TEMP_EXTRACT"

# Copy all files except .git to the Regional repo
echo "Copying files..."
rsync -a --exclude='.git' --exclude='COPY_TO_REGIONAL.md' --exclude='copy_to_regional.sh' ./ "$TEMP_DIR/"

# Return to Regional repo directory
cd "$TEMP_DIR"

# Step 5: Commit changes
echo "Step 5: Committing changes..."
git add .

COMMIT_MSG="Sync all code from D2026-Practice repository

This commit copies all code from the D2026-Practice repository.
All source files, configurations, and dependencies have been synchronized."

git commit -m "$COMMIT_MSG"

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
echo "Repository: D2026-Regional"
echo "=================================="
