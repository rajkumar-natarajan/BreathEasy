#!/bin/bash

# BreathEasy Auto-Push Setup
# This script demonstrates the auto-push functionality that's now configured

echo "🚀 BreathEasy Auto-Push Configuration Complete!"
echo ""
echo "✅ What's been set up:"
echo "   📌 Post-commit hook: Automatically pushes to origin/main after each commit"
echo "   📌 Git alias 'acp': Quick add-commit-push workflow"
echo ""
echo "💡 Usage Examples:"
echo ""
echo "   Standard workflow (with auto-push):"
echo "   git add ."
echo "   git commit -m \"your message\""
echo "   # → Automatically pushes to remote!"
echo ""
echo "   Quick workflow using alias:"
echo "   git acp \"your commit message\""
echo "   # → Adds all files, commits, and auto-pushes!"
echo ""
echo "   For non-main branches (manual push required):"
echo "   git checkout feature-branch"
echo "   git commit -m \"feature update\""
echo "   git push origin feature-branch"
echo ""
echo "🔧 Configuration Details:"
echo "   • Auto-push only works on 'main' branch for safety"
echo "   • Other branches require manual push to prevent conflicts"
echo "   • Hook location: .git/hooks/post-commit"
echo ""
echo "🎯 Ready for Development!"
echo "   Your BreathEasy project now has streamlined git workflow"
echo "   All future changes will be automatically synced to GitHub"
echo ""

# Test if we're in the BreathEasy directory
if [ -f "BreathEasyApp.swift" ]; then
    echo "✅ Running from BreathEasy project directory"
    echo "📊 Current git status:"
    git status --short
else
    echo "⚠️  Run this script from the BreathEasy project directory"
fi
