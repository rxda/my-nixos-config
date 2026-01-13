#!/usr/bin/env bash

# 1. 进入子模块，提交并推送
echo "🚀 Updating Submodule..."
cd templates
git add .
git commit -m "Update templates"
git push
cd ..

# 2. 更新 Nix 锁
echo "🔒 Updating Flake Lock..."
nix flake update my-templates

# 3. 应用系统 (如果失败则停止)
echo "❄️  Rebuilding System..."
nh os switch .|| exit 1

# 4. 提交主仓库
echo "💾 Committing Main Repo..."
git add .
git commit -m "chore: update templates input"
git push

echo "✅ Done!"