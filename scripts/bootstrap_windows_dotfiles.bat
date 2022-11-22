@echo off
echo.

set dotfiles_dir=.dotfiles

if not exist %dotfiles_dir% mkdir %dotfiles_dir%
git clone "https://github.com/vsyx/windows-dotfiles" -c core.hooksPath=%dotfiles_dir%/hooks -c core.symlinks=true --bare %dotfiles_dir%/repo ^
   && git --git-dir=%CD%\%dotfiles_dir%\repo --work-tree=%CD% checkout ^
   && git --git-dir=%CD%\%dotfiles_dir%\repo --work-tree=%CD% submodule update --init ^
   && git --git-dir=%CD%\%dotfiles_dir%\repo --work-tree=%CD% checkout

