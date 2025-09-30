#!/bin/bash

# Fast Auto-Push Script for BreathEasy
# Alternative to git hooks for better performance control

echo "🚀 BreathEasy Quick Push..."

# Check if we're in the right directory
if [ ! -f "BreathEasy/BreathEasyApp.swift" ] && [ ! -f "BreathEasyApp.swift" ]; then
    echo "❌ Not in BreathEasy directory"
    exit 1
fi

# Get current branch
branch=$(git branch --show-current)
echo "📍 Branch: $branch"

# Check for changes (including untracked files)
if git diff-index --quiet HEAD -- && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "✅ No changes to commit"
    
    # Check if we need to push
    if [ "$(git rev-list HEAD...origin/$branch --count)" != "0" ]; then
        echo "📤 Pushing existing commits..."
        git push origin $branch
        echo "✅ Push complete!"
    else
        echo "✅ Already up to date"
    fi
else
    echo "📝 Changes detected, committing..."
    
    # Show what's changed (briefly)
    git status --porcelain | head -5
    
    # Add all changes
    git add .
    
    # Get commit message from user or use default
    if [ -z "$1" ]; then
        commit_msg="feat: Quick update via fast-push script"
    else
        commit_msg="$1"
    fi
    
    # Commit and push in one go
    echo "💾 Committing: $commit_msg"
    git commit -m "$commit_msg"
    
    if [ $? -eq 0 ]; then
        echo "📤 Pushing to $branch..."
        git push origin $branch
        echo "✅ All done!"
    else
        echo "❌ Commit failed"
        exit 1
    fi
fi
