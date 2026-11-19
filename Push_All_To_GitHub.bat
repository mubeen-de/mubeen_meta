@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0"
title Kapmeta POS - Push oct12 and beta to GitHub
color 0B

echo =======================================================================
echo         KAPMETA POS PLATFORM - PUSH OCT12 ^& BETA TO GITHUB
echo =======================================================================
echo.
echo Target Repository : https://github.com/mubeen-de/mubeen_meta.git
echo Branches to push  : [oct12] and [beta]
echo.
echo A browser window may open to authenticate your GitHub account.
echo =======================================================================
echo.

echo [1/2] Pushing branch 'oct12' to GitHub...
git push -u origin oct12
if %ERRORLEVEL% equ 0 (
    echo [SUCCESS] 'oct12' branch pushed successfully!
) else (
    echo [FAILED] Could not push 'oct12'. Check error output above.
)
echo.

echo [2/2] Pushing branch 'beta' to GitHub...
git push -u origin beta
if %ERRORLEVEL% equ 0 (
    echo [SUCCESS] 'beta' branch pushed successfully!
) else (
    echo [FAILED] Could not push 'beta'. Check error output above.
)
echo.

echo =======================================================================
echo Both branches processed. You can now close this window.
echo =======================================================================
echo.
pause
