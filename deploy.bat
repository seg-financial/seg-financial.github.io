@echo off
REM --- Tworzymy lokalny backup ---

setlocal enabledelayedexpansion

REM Format daty i czasu dla folderu backupu YYYY-MM-DD_HHMMSS
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do (
  set day=%%a
  set month=%%b
  set year=%%c
)
for /f "tokens=1-2 delims=:." %%a in ('echo %time%') do (
  set hour=%%a
  set minute=%%b
)
set BACKUP_DIR=backup_%year%-%month%-%day%_%hour%%minute%

echo Tworzenie backupu w folderze %BACKUP_DIR%
mkdir %BACKUP_DIR%

xcopy hugo.toml %BACKUP_DIR%\ /Y
xcopy content %BACKUP_DIR%\content /E /I /Y
xcopy layouts %BACKUP_DIR%\layouts /E /I /Y

echo Backup gotowy!

REM Budowanie
echo Budowanie strony Hugo...
hugo

echo Sprawdzam zawartość folderu public:
dir public

REM Wypychanie
cd public

git add .
git commit -m "Deploy with backup"
git push --force origin gh-pages

cd ..

echo Deployment i backup zakończone.
pause
