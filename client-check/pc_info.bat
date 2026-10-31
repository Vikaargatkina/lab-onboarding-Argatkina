@echo off
chcp 65001 > nul

REM =========================================================
REM Тема: Инструментальные средства ревьюирования
REM Фамилия: Аргаткина
REM Дата: 31.10.2026
REM =========================================================

SET "REPORT=%~dp0pc_report.txt"

echo Диагностика компьютера > "%REPORT%"
echo ---------------------------------------- >> "%REPORT%"

echo ========================================
echo        ДИАГНОСТИКА КОМПЬЮТЕРА
echo ========================================
echo.

REM --- СВЕДЕНИЯ ОБ ОБЕРАЦИОННОЙ СИСТЕМЕ ---
echo [Операционная система]
echo [Операционная система] >> "%REPORT%"
for /f "tokens=2 delims==" %%i in ('wmic os get Caption /format:list 2^>nul') do (
    echo Название: %%i
    echo Название: %%i >> "%REPORT%"
)
for /f "tokens=2 delims==" %%i in ('wmic os get Version /format:list 2^>nul') do (
    echo Версия: %%i
    echo Версия: %%i >> "%REPORT%"
)
echo ----------------------------------------
echo ---------------------------------------- >> "%REPORT%"

REM --- СВЕДЕНИЯ О ПРОЦЕССОРЕ ---
echo [Процессор]
echo [Процессор] >> "%REPORT%"
for /f "tokens=2 delims==" %%i in ('wmic cpu get Name /format:list 2^>nul') do (
    echo Модель: %%i
    echo Модель: %%i >> "%REPORT%"
)
echo ----------------------------------------
echo ---------------------------------------- >> "%REPORT%"

REM --- СВЕДЕНИЯ ОБ ОПЕРАТИВНОЙ ПАМЯТИ ---
echo [Оперативная память]
echo [Оперативная память] >> "%REPORT%"
set "total_kb=0"
set "free_kb=0"
for /f "tokens=2 delims==" %%i in ('wmic OS get TotalVisibleMemorySize /format:list 2^>nul') do set "total_kb=%%i"
for /f "tokens=2 delims==" %%i in ('wmic OS get FreePhysicalMemory /format:list 2^>nul') do set "free_kb=%%i"
set /a total_gb=%total_kb% / 1048576
set /a free_gb=%free_kb% / 1048576
echo Всего памяти: %total_gb% ГБ
echo Свободно памяти: %free_gb% ГБ
echo Всего памяти: %total_gb% ГБ >> "%REPORT%"
echo Свободно памяти: %free_gb% ГБ >> "%REPORT%"
echo ----------------------------------------
echo ---------------------------------------- >> "%REPORT%"

REM --- СВЕДЕНИЯ О СВОБОДНОМ МЕСТЕ НА ДИСКЕ ---
echo [Диск C]
echo [Диск C] >> "%REPORT%"
set "disk_size=0"
set "disk_free=0"
for /f "tokens=2 delims==" %%i in ('wmic logicaldisk where DeviceID="C:" get Size /format:list 2^>nul') do set "disk_size=%%i"
for /f "tokens=2 delims==" %%i in ('wmic logicaldisk where DeviceID="C:" get FreeSpace /format:list 2^>nul') do set "disk_free=%%i"
set "size_trimmed=%disk_size:~0,-6%"
set "free_trimmed=%disk_free:~0,-6%"
set /a size_gb=%size_trimmed% / 1073
set /a free_gb=%free_trimmed% / 1073
echo Общий размер: %size_gb% ГБ
echo Свободно места: %free_gb% ГБ
echo Общий размер: %size_gb% ГБ >> "%REPORT%"
echo Свободно места: %free_gb% ГБ >> "%REPORT%"
echo ----------------------------------------
echo ---------------------------------------- >> "%REPORT%"

REM --- СПИСОК УСТАНОВЛЕННЫХ ПРОГРАММ ---
echo [Установленные программы]
echo [Установленные программы] >> "%REPORT%"
echo Идёт сбор списка программ, пожалуйста, подождите...
echo.
powershell -NoProfile -Command "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* 2>$null | Select-Object -Property DisplayName | Where-Object {$_.DisplayName -ne $null} | ForEach-Object {$_.DisplayName}"
powershell -NoProfile -Command "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* 2>$null | Select-Object -Property DisplayName | Where-Object {$_.DisplayName -ne $null} | ForEach-Object {$_.DisplayName}" >> "%REPORT%"

echo.
echo ========================================
echo Отчёт сохранён
echo ========================================
pause

