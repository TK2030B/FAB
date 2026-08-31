@echo off
setlocal enabledelayedexpansion

:: Target continent ID for Essos (2 = Asia/Essos in definition.csv)
set "NEW_CONTINENT=2"

:: Set list of Essos Province IDs
set "ESSOS_PROVS= 30 45 51 90 94 95 117 135 155 159 230 267 281 457 461 580 612 680 698 737 841 863 869 958 983 996 1085 1095 1177 1195 1267 1310 1337 1362 1376 1378 1395 1417 1535 1553 1554 1571 1600 1615 1697 1768 1823 1967 1970 2071 2129 2210 2264 2323 2324 2325 2326 2327 2328 2329 2330 2331 2332 2333 2334 2335 2336 2337 2338 2339 2341 2342 2343 2344 2346 2348 3209 3210 4628 4629 4630 4631 4632 4633 4634 4635 4636 4637 4638 4639 4640 4641 4642 4643 4644 4645 4646 4647 4648 4649 4650 4651 4652 4653 4654 4655 4656 4657 "

set "INPUT_FILE=definition.csv"
set "TEMP_FILE=definition_temp.csv"

if not exist "%INPUT_FILE%" (
    echo ERROR: definition.csv not found in this directory!
    pause
    exit /b
)

echo Updating Essos provinces in definition.csv...

(for /f "usebackq tokens=1-7* delims=;" %%a in ("%INPUT_FILE%") do (
    set "PROV_ID=%%a"
    set "MATCH="
    
    :: Check if current Province ID is in the Essos list
    for %%x in (!PROV_ID!) do (
        if not "!ESSOS_PROVS: %%x =!"=="!ESSOS_PROVS!" (
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

echo Success! Updated 105 Essos provinces to Continent %NEW_CONTINENT%.
pause