@echo off
chcp 65001 >nul
REM Тема: Диагностика клиентского компьютера. Фамилия: Аргаткина. Дата: 26.10.2026

set REPORT_FILE=%~dp0pc_report.txt

(
echo ==========================================
echo        Диагностика компьютера
echo ==========================================
echo.

REM Сведения об операционной системе
echo [Операционная система]
for /f "tokens=2 delims==" %%a in ('wmic os get Caption /format:list') do echo Название: %%a
for /f "tokens=2 delims==" %%a in ('wmic os get Version /format:list') do echo Версия: %%a
echo.

REM Сведения о процессоре
echo [Процессор]
for /f "skip=1 delims=" %%a in ('wmic cpu get name') do echo %%a & goto :next1
:next1
echo.

REM Сведения об оперативной памяти
echo [Оперативная память]
for /f "tokens=2 delims==" %%a in ('wmic OS get TotalVisibleMemorySize /format:list') do set /a TOTAL_GB=%%a / 1048576
for /f "tokens=2 delims==" %%a in ('wmic OS get FreePhysicalMemory /format:list') do set /a FREE_GB=%%a / 1048576
echo Всего памяти: %TOTAL_GB% ГБ
echo Свободно памяти: %FREE_GB% ГБ
echo.

REM Свободное место на диске C
echo [Диск C:]
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where DeviceID="C:" get Size /format:list') do set /a SIZE_GB=%%a / 1073741824
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk where DeviceID="C:" get FreeSpace /format:list') do set /a FREE_DISK_GB=%%a / 1073741824
echo Общий размер: %SIZE_GB% ГБ
echo Свободно: %FREE_DISK_GB% ГБ
echo.

REM Список установленных программ
echo [Установленные программы]
echo Идёт поиск программ, это может занять несколько минут...
wmic product get name
echo.

echo Отчёт сохранён в pc_report.txt
) > "%REPORT_FILE%"

type "%REPORT_FILE%"
pause
