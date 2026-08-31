@echo off
setlocal enabledelayedexpansion

set "INPUT_FILE=definition.csv"
set "TEMP_FILE=definition_temp.csv"

if not exist "%INPUT_FILE%" (
    echo ERROR: definition.csv not found in this folder!
    pause
    exit /b
)

:: Prompt for the continent ID to search for
:PROMPT_OLD
echo.
set "OLD_CONT="
set /p OLD_CONT="Enter the Continent ID to replace (1-7): "

if "%OLD_CONT%"=="" goto PROMPT_OLD
if %OLD_CONT% LSS 1 goto INVALID_OLD
if %OLD_CONT% GTR 7 goto INVALID_OLD
goto PROMPT_NEW

:INVALID_OLD
echo Invalid input! Please enter a number between 1 and 7.
goto PROMPT_OLD

:: Prompt for the new continent ID to assign
:PROMPT_NEW
set "NEW_CONT="
set /p NEW_CONT="Enter the NEW Continent ID (1-7): "

if "%NEW_CONT%"=="" goto PROMPT_NEW
if %NEW_CONT% LSS 1 goto INVALID_NEW
if %NEW_CONT% GTR 7 goto INVALID_NEW
goto PROCESS_FILE

:INVALID_NEW
echo Invalid input! Please enter a number between 1 and 7.
goto PROMPT_NEW

:PROCESS_FILE
echo.
echo Scanning definition.csv and replacing continent %OLD_CONT% with %NEW_CONT%...

(for /f "usebackq tokens=1-7* delims=;" %%a in ("%INPUT_FILE%") do (
    set "CONT=%%h"
    :: Strip any hidden spaces or carriage returns
    for /f "tokens=*" %%x in ("!CONT!") do set "CONT=%%x"
    
    if "!CONT!"=="%OLD_CONT%" (
        echo %%a;%%b;%%c;%%d;%%e;%%f;%%g;%NEW_CONT%
    ) else (
        echo %%a;%%b;%%c;%%d;%%e;%%f;%%g;%%h
    )
)) > "%TEMP_FILE%"

move /y "%TEMP_FILE%" "%INPUT_FILE%" >nul

echo Done! Updated all continent %OLD_CONT% entries to %NEW_CONT% in definition.csv.
pause