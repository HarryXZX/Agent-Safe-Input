@echo off
rem ============================================================
rem  Agent-Safe-Input - Windows launcher
rem
rem  Double-click to open a terminal that runs:  agent-safe-input run
rem  Optional argument: an id, to skip the picker
rem      agent-safe-input-window.bat 20261112-134107-install-deps
rem
rem  Requires Git for Windows (provides bash and mintty).
rem  agent-safe-input itself must be on PATH (see README).
rem ============================================================
setlocal
set "GITBASH=C:\Program Files\Git\bin\bash.exe"
set "MINTTY=C:\Program Files\Git\usr\bin\mintty.exe"

if not exist "%GITBASH%" (
    echo Git for Windows was not found at:
    echo     %GITBASH%
    echo Install it from https://git-scm.com/download/win and re-run this file.
    pause
    exit /b 1
)

if exist "%MINTTY%" (
    start "" "%MINTTY%" --hold=always -t "Agent-Safe-Input" -e "%GITBASH%" "%~dp0agent-safe-input-window.sh" %*
) else (
    "%GITBASH%" "%~dp0agent-safe-input-window.sh" %*
)
endlocal
