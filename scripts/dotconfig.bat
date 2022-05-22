@echo off
echo.

git --git-dir=%homedrive%%homepath%\.dotfiles\repo --work-tree=%homedrive%%homepath% %*
