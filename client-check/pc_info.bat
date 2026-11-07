@echo off
chcp 65001 > nul
set "REPORT=%~dp0pc_report.txt"

:: Очистка старого отчета при запуске
type nul > "%REPORT%"

echo [1/5] Инициализация диагностики и очистка переменных...
:: Явная очистка переменных перед сбором данных (Шаг 3 требований)
set "os_name="
set "cpu_name="

call :log "========================================"
call :log "         ДИАГНОСТИКА КОМПЬЮТЕРА         "
call :log "========================================"
:: Временная метка в начале отчета (Шаг 7 требований)
call :log "Дата и время проверки: %date% %time%"
call :log "----------------------------------------"

echo [2/5] Сбор сведений о системе (Безопасный метод через PowerShell)...
:: Получение ОС через PowerShell (защита от отсутствия wmic в Windows 11)
for /f "usebackq delims=" %%i in (`powershell -NoProfile -Command "(Get-CimInstance Win32_OperatingSystem).Caption" 2^>nul`) do set "os_name=%%i"
:: Проверка, определена ли переменная (Шаг 3 требований)
if defined os_name (
    call :log "--- Операционная система ---"
    call :log "%os_name%"
) else (
    call :log "--- Операционная система ---"
    call :log "Ошибка: Не удалось получить данные об ОС."
)

:: Получение процессора через PowerShell
for /f "usebackq delims=" %%i in (`powershell -NoProfile -Command "(Get-CimInstance Win32_Processor).Name" 2^>nul`) do set "cpu_name=%%i"
if defined cpu_name (
    call :log ""
    call :log "--- Процессор ---"
    call :log "%cpu_name%"
) else (
    call :log ""
    call :log "--- Процессор ---"
    call :log "Ошибка: Не удалось получить данные о процессоре."
)

echo [3/5] Формирование полного списка ПО (32-bit и 64-bit)...
:: Сбор установленных программ из обеих веток реестра во временный файл (Шаг 4 требований)
set "TEMP_APPS=%TEMP%\apps_list.txt"
type nul > "%TEMP_APPS%"

:: Опрос 64-битной ветки реестра через PowerShell (выделяем только чистые имена)
powershell -NoProfile -Command "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* 2>$null | Select-Object -ExpandProperty DisplayName 2>$null" >> "%TEMP_APPS%"
:: Опрос 32-битной ветки реестра (WOW6432Node)
powershell -NoProfile -Command "Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* 2>$null | Select-Object -ExpandProperty DisplayName 2>$null" >> "%TEMP_APPS%"

echo [4/5] Проведение детального интеллектуального аудита ПО...
call :log ""
call :log "========================================"
call :log "          РАЗДЕЛ РЕКОМЕНДАЦИЙ           "
call :log "========================================"

call :log "--- Проверка базового офисного ПО (Эталонный список) ---"

:: 1. Проверка архиватора (Шаг 5 требований)
findstr /I "7-Zip WinRAR" "%TEMP_APPS%" >nul
if %errorlevel% equ 0 (
    call :log "[ОК] Компонент 'Архиватор' проверен и обнаружен."
) else (
    call :log "[РЕКОМЕНДАЦИЯ] Не обнаружен архиватор. Для работы с вложениями в почте рекомендуется установить 7-Zip или WinRAR."
)

:: 2. Проверка офисного пакета
findstr /I "Office LibreOffice МойОфис" "%TEMP_APPS%" >nul
if %errorlevel% equ 0 (
    call :log "[ОК] Компонент 'Офисный пакет' проверен и обнаружен."
) else (
    call :log "[РЕКОМЕНДАЦИЯ] Не обнаружен офисный пакет. Для работы с документами рекомендуется установить МойОфис или LibreOffice."
)

call :log ""
call :log "--- Проверка излишнего / нецелевого ПО (Группы риска) ---"
set "LOGIC_NOTE=Примечание: Вывод является рекомендацией к проверке, а не обязательным указанием к удалению."

:: Проверка группы: Игровое ПО (Шаг 6 требований)
findstr /I "Steam Epic Discord uTorrent" "%TEMP_APPS%" >nul
if %errorlevel% equ 0 (
    call :log "[ТРЕБУЕТ ПРОВЕРКИ] Игровое или нецелевое ПО (Steam, uTorrent или Discord)."
    call :log "  %LOGIC_NOTE%"
) else (
    call :log "[ОК] Излишнее или нецелевое ПО не обнаружено."
)

:: Удаление временного файла (Шаг 7 требований)
if exist "%TEMP_APPS%" del "%TEMP_APPS%"

echo [5/5] Формирование отчета успешно завершено!
call :log ""
call :log "Итог: Категории базового ПО проверены. Рекомендации сформированы."
call :log "Полный путь к отчету: %REPORT%"
echo.
pause
exit /b

:: ==========================================
:: ПОДПРОГРАММА ВЫВОДА LOG (С зашитой скобкой)
:: ==========================================
:log
echo(%~1
echo(%~1 >> "%REPORT%"
exit /b

