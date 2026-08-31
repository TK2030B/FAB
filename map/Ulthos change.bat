@echo off
setlocal enabledelayedexpansion

set "INPUT_FILE=definition.csv"
set "TEMP_FILE=definition_temp.csv"

if not exist "%INPUT_FILE%" (
    echo ERROR: definition.csv not found in this folder!
    pause
    exit /b
)

echo Scanning definition.csv and replacing continent 5 with 4...

(for /f "usebackq tokens=1-7* delims=;" %%a in ("%INPUT_FILE%") do (
    set "CONT=%%h"
    :: Strip any hidden spaces or carriage returns
    for /f "tokens=*" %%x in ("!CONT!") do set "CONT=%%x"
    
    if "!CONT!"=="5" (
        echo %%a;%%b;%%c;%%d;%%e;%%f;%%g;4
    ) else (
        echo %%a;%%b;%%c;%%d;%%e;%%f;%%g;%%h
    )
)) > "%TEMP_FILE%"

move /y "%TEMP_FILE%" "%INPUT_FILE%" >nul

echo Done! Updated all continent 5 entries to 4 in definition.csv.
pause