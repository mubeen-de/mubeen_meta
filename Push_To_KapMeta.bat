@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0"
for /f "tokens=*" %%g in ('git branch --show-current') do (set CURRENT_BRANCH=%%g)
if "!CURRENT_BRANCH!"=="" set CURRENT_BRANCH=oct08

title Kapmeta POS - Push !CURRENT_BRANCH! to metapharsic/kapmeta
color 0B

echo =======================================================================
echo          KAPMETA POS PLATFORM - PUSH BRANCH '!CURRENT_BRANCH!' TO GITHUB         
echo =======================================================================
echo.
echo Target Repository : https://github.com/metapharsic/kapmeta.git
echo Active Branch     : !CURRENT_BRANCH!
echo.
echo Changes committed on !CURRENT_BRANCH!:
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
    echo Pushing branch '!CURRENT_BRANCH!' using provided token...
    git push -u https://!GITHUB_TOKEN!@github.com/metapharsic/kapmeta.git !CURRENT_BRANCH!
) else (
    echo.
    echo Pushing branch '!CURRENT_BRANCH!' via Git Credential Manager / Browser...
    git push -u kapmeta !CURRENT_BRANCH!
)

if %ERRORLEVEL% equ 0 (
    color 0A
    echo.
    echo =======================================================================
    echo  SUCCESS: Branch '!CURRENT_BRANCH!' pushed to https://github.com/metapharsic/kapmeta!
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
