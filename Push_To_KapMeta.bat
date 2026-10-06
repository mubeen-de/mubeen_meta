@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0"
title Kapmeta POS - Push oct10 to metapharsic/kapmeta
color 0B

echo =======================================================================
echo          KAPMETA POS PLATFORM - PUSH BRANCH 'oct10' TO GITHUB         
echo =======================================================================
echo.
echo Target Repository : https://github.com/metapharsic/kapmeta.git
echo Active Branch     : oct10
echo.
echo Changes committed on oct10:
git log -n 1 --oneline
echo =======================================================================
echo.
echo Choose authentication method:
echo  [1] Enter a GitHub Personal Access Token (PAT)
echo  [2] Use GitHub Browser Login / Git Credential Manager
echo.
set /p AUTH_CHOICE="Select option [1 or 2, default 2]: "

if "%AUTH_CHOICE%"=="1" (
    echo.
    set /p GITHUB_TOKEN="Enter your GitHub PAT: "
    if "!GITHUB_TOKEN!"=="" (
        echo [ERROR] Token cannot be empty.
        pause
        exit /b 1
    )
    echo.
    echo Pushing branch 'oct10' using provided token...
    git push -u https://!GITHUB_TOKEN!@github.com/metapharsic/kapmeta.git oct10
) else (
    echo.
    echo Pushing branch 'oct10' via Git Credential Manager / Browser...
    git push -u kapmeta oct10
)

if %ERRORLEVEL% equ 0 (
    color 0A
    echo.
    echo =======================================================================
    echo  SUCCESS: Branch 'oct10' pushed to https://github.com/metapharsic/kapmeta!
    echo =======================================================================
) else (
    color 0C
    echo.
    echo =======================================================================
    echo  PUSH FAILED: Please verify you have collaborator/write permissions
    echo  to https://github.com/metapharsic/kapmeta.
    echo =======================================================================
)

echo.
pause
