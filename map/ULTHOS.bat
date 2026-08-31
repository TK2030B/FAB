@echo off
setlocal enabledelayedexpansion

:: Target continent ID for Ulthos (6 = Australia/Ulthos in definition.csv)
set "NEW_CONTINENT=6"

:: Set list of Ulthos Province IDs
set "ULTHOS_PROVS= 4 14 17 23 28 54 66 106 109 116 158 172 188 235 239 242 263 264 277 412 430 434 462 470 483 497 508 531 534 538 579 583 604 613 649 668 725 733 743 765 766 784 787 808 887 966 1008 1026 1034 1036 1049 1065 1073 1100 1173 1184 1218 1328 1413 1494 1530 1549 1579 1595 1692 1775 1783 1789 1790 1847 1879 2024 2202 2300 2303 3085 3087 3096 3103 3112 3115 3117 3121 3124 3130 3133 3134 3136 3138 3143 3145 3148 3159 3368 "

set "INPUT_FILE=definition.csv"
set "TEMP_FILE=definition_temp.csv"

if not exist "%INPUT_FILE%" (
    echo ERROR: definition.csv not found in this directory!
    pause
    exit /b
)

echo Updating Ulthos provinces in definition.csv...

(for /f "usebackq tokens=1-7* delims=;" %%a in ("%INPUT_FILE%") do (
    set "PROV_ID=%%a"
    set "MATCH="
    
    :: Check if current Province ID is in the Ulthos list
    for %%x in (!PROV_ID!) do (
        if not "!ULTHOS_PROVS: %%x =!"=="!ULTHOS_PROVS!" (
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

echo Success! Updated 93 Ulthos provinces to Continent %NEW_CONTINENT%.
pause