@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0\.."
title Kapmeta POS - Promote Beta to Main (Production Release)
color 0E

echo =======================================================================
echo     KAPMETA POS PLATFORM - PROMOTE TESTED BETA TO MAIN (PRODUCTION)
echo =======================================================================
echo.
echo  This wizard merges tested code from the 'beta' branch into 'main'
echo  and pushes to GitHub so Client Systems can pull the updates.
echo.
echo  Source Branch : beta (Tested features)
echo  Target Branch : main (Production Client Channel)
echo =======================================================================
echo.

set /p CONFIRM="Have all features been verified in Beta testing? [Y/N, default Y]: "
if /i "%CONFIRM%"=="N" (
    echo.
    echo Promotion cancelled. Continue testing in beta.
    pause
    exit /b 0
)

echo.
echo [STEP 1/4] Switching to branch 'main'...
git checkout main
if %ERRORLEVEL% neq 0 (
    color 0C
    echo [ERROR] Failed to switch to branch 'main'.
    pause
    exit /b 1
)

echo.
echo [STEP 2/4] Pulling latest 'main' from origin...
git pull origin main

echo.
echo [STEP 3/4] Merging 'beta' into 'main'...
git merge beta -m "release: promote tested features from beta to main"
if %ERRORLEVEL% neq 0 (
    color 0C
    echo [ERROR] Merge conflict detected. Resolve conflicts before completing promotion.
    pause
    exit /b 1
)

echo.
echo [STEP 4/4] Pushing updated 'main' to GitHub origin...
git push origin main
if %ERRORLEVEL% equ 0 (
    color 0A
    echo.
    echo =======================================================================
    echo  SUCCESS: Beta has been successfully promoted to 'main'!
    echo  Client systems running Pull_From_GitHub.bat will now receive these updates.
    echo =======================================================================
) else (
    color 0C
    echo.
    echo [ERROR] Push to main failed. Check credentials or network connection.
)

echo.
pause
