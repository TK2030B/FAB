@echo off
setlocal enabledelayedexpansion

:: Ask the user for the TAG
set /p TARGET_TAG="Enter Country TAG (e.g. WIL): "

if "%TARGET_TAG%"=="" (
    echo No TAG entered. Exiting.
    pause
    exit /b
)

set "OUTPUT_FILE=%TARGET_TAG%_provinces.txt"
if exist "%OUTPUT_FILE%" del "%OUTPUT_FILE%"

echo Searching state files for owner = %TARGET_TAG%...

set "ALL_PROVS="
set "STATE_COUNT=0"

:: Loop through all .txt state files
for %%F in (*.txt) do (
    
    :: Use findstr regex to check if owner line exists (handles tabs, spaces, quotes)
    findstr /i /r /c:"owner[ 	]*=[ 	]*\"*%TARGET_TAG%\"*" "%%F" >nul
    
    if !errorlevel! equ 0 (
        set /a STATE_COUNT+=1
        set "IN_PROVS="
        
        :: Read file to extract numbers inside provinces = { ... } block
        for /f "usebackq delims=" %%L in ("%%F") do (
            set "LINE=%%L"
            
            :: Detect start of provinces block
            echo !LINE! | findstr /i "provinces" >nul
            if !errorlevel! equ 0 set "IN_PROVS=1"
            
            if defined IN_PROVS (
                :: Tokenize line and grab numbers
                for %%W in (%%L) do (
                    set "WORD=%%W"
                    :: Strip non-numeric characters
                    for /f "delims=0123456789" %%N in ("!WORD!") do set "WORD="
                    if defined WORD (
                        set "ALL_PROVS=!ALL_PROVS! !WORD!"
                    )
                )
            )
            
            :: Detect end of block
            echo !LINE! | findstr /i "}" >nul
            if !errorlevel! equ 0 (
                if defined IN_PROVS set "IN_PROVS="
            )
        )
    )
)

if "%ALL_PROVS%"=="" (
    echo.
    echo ERROR: Still no provinces found for TAG "%TARGET_TAG%".
    echo Check if the owner key in your state files is capitalized or spelled differently.
    pause
    exit /b
)

:: Save raw list to temp file
(for %%P in (%ALL_PROVS%) do echo %%P) > temp_provs.txt

:: Write clean output file
echo Provinces for %TARGET_TAG% (Found in %STATE_COUNT% states): > "%OUTPUT_FILE%"
echo ---------------------------------------- >> "%OUTPUT_FILE%"
echo Single Line List: >> "%OUTPUT_FILE%"

set "SINGLE_LINE="
for /f "delims=" %%S in ('sort /+1 temp_provs.txt ^| findstr /r "^[0-9][0-9]*$"') do (
    set "SINGLE_LINE=!SINGLE_LINE! %%S"
)

echo %SINGLE_LINE:~1% >> "%OUTPUT_FILE%"

echo. >> "%OUTPUT_FILE%"
echo Itemized List: >> "%OUTPUT_FILE%"
type temp_provs.txt >> "%OUTPUT_FILE%"

del temp_provs.txt >nul 2>&1

echo Done! Found %STATE_COUNT% states. Output saved to %OUTPUT_FILE%.
pause