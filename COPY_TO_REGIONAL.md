# Copy Code from D2026-Practice to D2026-Regional

This document provides instructions for copying all code from the D2026-Practice repository to the D2026-Regional repository via a pull request.

## Overview

This process will synchronize all code, configuration files, and dependencies from D2026-Practice to D2026-Regional. The recommended approach is to use the provided automated script, but manual steps are also documented below.

## Prerequisites

- Git installed on your machine
- Access to both repositories (DRIFT-4091/D2026-Practice and DRIFT-4091/D2026-Regional)  
- Push access to the D2026-Regional repository
- GitHub CLI (`gh`) installed (optional, for automated PR creation)

## Method 1: Using Git Commands

### Step 1: Clone D2026-Regional Repository

```bash
git clone https://github.com/DRIFT-4091/D2026-Regional.git
cd D2026-Regional
```

### Step 2: Add D2026-Practice as a Remote

```bash
git remote add practice https://github.com/DRIFT-4091/D2026-Practice.git
git fetch practice
```

### Step 3: Create a New Branch for the PR

```bash
git checkout -b sync-from-practice
```

### Step 4: Copy All Files from D2026-Practice

```bash
# Get the latest commit from D2026-Practice main branch
git checkout practice/main -- .

# Or if you want to merge the entire history:
# git merge --allow-unrelated-histories practice/main
```

**Note**: The `git checkout` method above may not copy files that exist in practice/main but are listed in D2026-Regional's .gitignore. For a complete copy that includes all files, use the automated script (Method 2) which uses rsync instead.

### Step 5: Review and Commit Changes

```bash
git status
git add .
git commit -m "Sync all code from D2026-Practice repository"
```

### Step 6: Push and Create PR

```bash
git push origin sync-from-practice

# Create PR using GitHub CLI
gh pr create --title "Sync code from D2026-Practice" --body "This PR copies all code from the D2026-Practice repository to D2026-Regional"

# Or push and create PR through GitHub web interface
```

## Method 2: Using the Copy Script (Recommended)

The provided `copy_to_regional.sh` script automates the entire process:

```bash
# Make the script executable (if not already)
chmod +x copy_to_regional.sh

# Run the script
./copy_to_regional.sh

# Or specify a different source branch (default is 'main')
./copy_to_regional.sh <branch-name>
```

The script will:
1. Clone the D2026-Regional repository to a temporary directory
2. Clone the D2026-Practice repository  
3. Copy all files (excluding .git directory)
4. Create a new branch with timestamp
5. Commit all changes
6. Push the branch to D2026-Regional
7. Attempt to create a PR using GitHub CLI (if available)

## Files to be Copied

The following files and directories will be copied from D2026-Practice:

- `.github/` - GitHub workflows and configurations
- `.vscode/` - VSCode settings
- `.wpilib/` - WPILib configuration
- `src/` - All source code
- `gradle/` - Gradle wrapper
- `vendordeps/` - Vendor dependencies
- `build.gradle` - Build configuration
- `settings.gradle` - Settings
- `gradlew` & `gradlew.bat` - Gradle wrapper scripts
- `tuner-project.json` - Tuner configuration
- `.gitignore` - Git ignore rules
- `WPILib-License.md` - License file
- `README.md` - Documentation (may need manual review)

## What Gets Copied

All files and directories from D2026-Practice will be copied to D2026-Regional, including:

- Source code (`src/`)
- Build configuration (`build.gradle`, `settings.gradle`)  
- Vendor dependencies (`vendordeps/`)
- IDE settings (`.vscode/`, `.wpilib/`)
- GitHub workflows (`.github/`)
- Gradle wrapper (`gradle/`, `gradlew`, `gradlew.bat`)
- Project configuration (`tuner-project.json`)
- Documentation (README.md, licenses, etc.)

**Note**: The script in D2026-Practice (COPY_TO_REGIONAL.md and copy_to_regional.sh) will NOT be copied to avoid confusion.

## Important Notes

- **Review the README.md**: After copying, you should review and update the README.md in D2026-Regional as it will initially describe the Practice repository
- **Team Communication**: Ensure all team members are aware of this sync operation before merging
- **Careful Review**: Review the PR carefully before merging to ensure no unintended changes
- **Testing**: After merging, test the code in D2026-Regional to ensure everything works as expected

## Troubleshooting

- If you don't have push access to D2026-Regional, contact a repository administrator
- If the GitHub CLI is not installed, you can create the PR manually through the GitHub web interface after the script pushes the branch
- If the script fails, check that you have network access to GitHub and that both repositories exist
