@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0\.."
title Kapmeta POS - Push to BETA Branch (Developer Testing)
color 0E

echo =======================================================================
echo         KAPMETA POS PLATFORM - PUSH TO BETA TESTING BRANCH
echo =======================================================================
echo.
echo  [NOTE] This script pushes exclusively to the 'beta' branch on GitHub.
echo         It will NOT affect the 'main' branch or client systems.
echo.
echo Target Remote : origin (https://github.com/mubeen-de/mubeen_meta)
echo Target Branch : beta (Developer Testing Channel)
echo =======================================================================
echo.

:: 1. Ensure logs directory exists
if not exist "logs\git" (
    mkdir "logs\git"
)

:: 2. Check Git Installation
where git >nul 2>nul
if %ERRORLEVEL% neq 0 (
    color 0C
    echo [ERROR] Git is not installed or not in system PATH.
    pause
    exit /b 1
)

:: 3. Switch to / Ensure on branch beta
git checkout beta >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Creating local 'beta' branch...
    git checkout -b beta
)

:: 4. Check for uncommitted changes
set HAS_UNCOMMITTED=no
for /f "tokens=*" %%i in ('git status --porcelain') do set HAS_UNCOMMITTED=yes

if "%HAS_UNCOMMITTED%"=="yes" (
    echo -----------------------------------------------------------------------
    echo  UNCOMMITTED CHANGES DETECTED:
    echo -----------------------------------------------------------------------
    git status --short
    echo.
    echo Enter a commit message for this beta testing build:
    echo (Press ENTER for auto-generated timestamped message)
    set /p COMMIT_MSG="[Beta Commit Message / Press ENTER]: "

    if "!COMMIT_MSG!"=="" (
        for /f "tokens=*" %%I in ('powershell -NoProfile -Command "Get-Date -Format 'yyyy-MM-dd HH:mm'"') do set ts=%%I
        set COMMIT_MSG=beta: developer testing updates (!ts!)
    )

    echo.
    echo Staging and committing changes to beta branch...
    git add -A
    git commit -m "!COMMIT_MSG!"
    echo.
) else (
    echo Workspace is clean. Commits on beta are ready to push.
    echo.
)

:: 5. Review latest commit
echo --- LATEST COMMIT BEING PUSHED TO BETA ---
git log -n 1 --pretty=format:" [%h] %ad | %s (%an)" --date=short
echo.
echo.

:: 6. Push to origin beta
echo =======================================================================
echo PUSHING COMMITS TO GITHUB 'beta' BRANCH...
echo =======================================================================
echo.

for /f "tokens=*" %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set dt=%%I
set LOG_FILE=logs\git\push_beta_!dt!.log

git push -u origin beta --progress --verbose 2>&1 | powershell -Command "$input | Tee-Object -FilePath '%LOG_FILE%'"

if %ERRORLEVEL% equ 0 (
    color 0A
    echo.
    echo =======================================================================
    echo  SUCCESS: Beta updates pushed to GitHub (origin/beta)!
    echo.
    echo  - Branch: beta (Testing Channel)
    echo  - Client systems pulling from 'main' remain completely untouched.
    echo =======================================================================
) else (
    color 0C
    echo.
    echo =======================================================================
    echo  PUSH TO BETA ENCOUNTERED AN ISSUE (Exit Code: %ERRORLEVEL%).
    echo  Check credentials or verify access to mubeen_meta repository.
    echo  Log saved to: !LOG_FILE!
    echo =======================================================================
)

echo.
pause
