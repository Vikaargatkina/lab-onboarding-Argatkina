@echo off
chcp 65001 > nul
set "REPORT=%~dp0pc_report.txt"

:: Очистка старого отчета
type nul > "%REPORT%"

echo [1/5] Инициализация диагностики...
call :log "========================================"
call :log "         ДИАГНОСТИКА КОМПЬЮТЕРА         "
call :log "========================================"
call :log "Дата и время проверки: %date% %time%"
call :log "----------------------------------------"

echo [2/5] Сбор сведений о системе...
call :log "--- Операционная система ---"
for /f "tokens=2 delims==" %%i in ('wmic os get Caption^,Version /value 2^>nul ^| findstr "="') do call :log "%%i"

call :log ""
call :log "--- Процессор ---"
for /f "tokens=2 delims==" %%i in ('wmic cpu get Name /value 2^>nul ^| findstr "="') do call :log "%%i"

echo [3/5] Получение списка программ...
:: Сохраняем реестр во временный файл
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s /f "DisplayName" 2>nul | findstr "DisplayName" > "%TEMP%\apps.txt"
reg query "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall" /s /f "DisplayName" 2>nul | findstr "DisplayName" >> "%TEMP%\apps.txt"

echo [4/5] Проведение аудита ПО...
call :log ""
call :log "========================================"
call :log "          РАЗДЕЛ РЕКОМЕНДАЦИЙ           "
call :log "========================================"

call :log "--- Проверка базового офисного ПО ---"
findstr /I "7-Zip WinRAR" "%TEMP%\apps.txt" >nul
if %errorlevel% equ 0 (
    call :log "[ОК] Архиватор обнаружен."
) else (
    call :log "[РЕКОМЕНДАЦИЯ] Не обнаружен архиватор. Рекомендуется установить 7-Zip."
)

findstr /I "Office LibreOffice МойОфис" "%TEMP%\apps.txt" >nul
if %errorlevel% equ 0 (
    call :log "[ОК] Офисный пакет обнаружен."
) else (
    call :log "[РЕКОМЕНДАЦИЯ] Не обнаружен офисный пакет. Рекомендуется установить МойОфис или LibreOffice."
)

call :log ""
call :log "--- Проверка излишнего / нецелевого ПО ---"
findstr /I "Steam Epic Discord uTorrent BitTorrent" "%TEMP%\apps.txt" >nul
if %errorlevel% equ 0 (
    call :log "[ТРЕБУЕТ ПРОВЕРКИ] Игровое или нецелевое ПО (Steam, uTorrent или Discord)."
) else (
    call :log "[ОК] Излишнее ПО не обнаружено."
)

if exist "%TEMP%\apps.txt" del "%TEMP%\apps.txt"

echo [5/5] Настройка завершена!
call :log ""
call :log "Отчет сохранен в файл pc_report.txt"
pause
exit /b

:: ==========================================
:: ПОДПРОГРАММА ВЫВОДА LOG
:: ==========================================
:log
echo(%~1
echo(%~1 >> "%REPORT%"
exit /b
