@echo off
setlocal enabledelayedexpansion

set "INPUT_FILE=definition.csv"
set "TEMP_FILE=definition_temp.csv"
set "LIST_FILE=00_PROVINCES_TO_EDIT.txt"

if not exist "%INPUT_FILE%" (
    echo ERROR: definition.csv not found in this directory!
    pause
    exit /b
)

if not exist "%LIST_FILE%" (
    echo ERROR: %LIST_FILE% not found in this directory!
    pause
    exit /b
)

:: Prompt user for the continent ID
:INPUT_PROMPT
echo.
set "NEW_CONTINENT="
set /p NEW_CONTINENT="Enter new Continent ID (1 to 7): "

:: Validate input
if "%NEW_CONTINENT%"=="" goto INPUT_PROMPT
if %NEW_CONTINENT% LSS 1 goto INVALID_INPUT
if %NEW_CONTINENT% GTR 7 goto INVALID_INPUT
goto READ_LIST

:INVALID_INPUT
echo Invalid selection! Please enter a number between 1 and 7.
goto INPUT_PROMPT

:READ_LIST
echo Reading province IDs from %LIST_FILE%...

:: Build space-padded list from the txt file
set "TARGET_PROVS= "
for /f "usebackq tokens=*" %%L in ("%LIST_FILE%") do (
    for %%W in (%%L) do (
        set "WORD=%%W"
        :: Strip non-numeric characters
        for /f "delims=0123456789" %%N in ("!WORD!") do set "WORD="
        if defined WORD (
            set "TARGET_PROVS=!TARGET_PROVS!!WORD! "
        )
    )
)

echo Updating definition.csv to Continent %NEW_CONTINENT%...

(for /f "usebackq tokens=1-7* delims=;" %%a in ("%INPUT_FILE%") do (
    set "PROV_ID=%%a"
    set "MATCH="
    
    :: Check if current Province ID exists in TARGET_PROVS
    for %%x in (!PROV_ID!) do (
        if not "!TARGET_PROVS: %%x =!"=="!TARGET_PROVS!" (
            set "MATCH=1"
        )
    )
    
    if defined MATCH (
        echo %%a;%%b;%%c;%%d;%%e;%%f;%%g;%NEW_CONTINENT%
    ) else (
        echo %%a;%%b;%%c;%%d;%%e;%%f;%%g;%%h
    )
)) > "%TEMP_FILE%"

move /y "%TEMP_FILE%" "%INPUT_FILE%" >nul

echo.
echo Success! Updated matching provinces in %LIST_FILE% to Continent %NEW_CONTINENT%.
pause