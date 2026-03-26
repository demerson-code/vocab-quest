@echo off
echo Deploying Vocab Quest to GitHub Pages...
echo.

cd /d "%~dp0"

git checkout tweaks
git checkout gh-pages
git merge tweaks -m "Deploy latest changes from tweaks"
git push origin gh-pages
git checkout tweaks

echo.
echo Deploy complete! Site will update in ~1 minute at:
echo   https://demerson-code.github.io/vocab-quest/
echo.
pause
