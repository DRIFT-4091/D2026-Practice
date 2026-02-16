# Copy Code from D2026-Practice to D2026-Regional

This document provides instructions for copying all code from the D2026-Practice repository to the D2026-Regional repository via a pull request.

## Prerequisites

- Git installed on your machine
- Access to both repositories (DRIFT-4091/D2026-Practice and DRIFT-4091/D2026-Regional)
- GitHub CLI (`gh`) or ability to create PRs through the GitHub web interface

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

## Method 2: Using the Copy Script

Run the provided `copy_to_regional.sh` script which automates the above steps:

```bash
./copy_to_regional.sh
```

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

## Notes

- The README.md file may need manual review and editing after the copy, as it currently describes the Practice repository
- Ensure all team members are aware of this sync operation
- Review the PR carefully before merging to ensure no unintended changes
