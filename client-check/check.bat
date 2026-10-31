@echo off
chcp 65001 > nul
SET "REPORT=%~dp0pc_report.txt"
echo Диагностика компьютера > "%REPORT%"
echo ---------------------------------------- >> "%REPORT%"
echo ========================================
echo        ДИАГНОСТИКА КОМПЬЮТЕРА
echo ========================================
echo.
echo [Операционная система]
wmic os get Caption,Version /format:list
wmic os get Caption,Version /format:list >> "%REPORT%"
echo [Процессор]
wmic cpu get Name /format:list
wmic cpu get Name /format:list >> "%REPORT%"
echo [Оперативная память]
wmic OS get TotalVisibleMemorySize,FreePhysicalMemory /format:list
wmic OS get TotalVisibleMemorySize,FreePhysicalMemory /format:list >> "%REPORT%"
echo [Диск C]
wmic logicaldisk where DeviceID="C:" get Size,FreeSpace /format:list
wmic logicaldisk where DeviceID="C:" get Size,FreeSpace /format:list >> "%REPORT%"
echo.
echo Отчёт успешно сохранён в файл pc_report.txt
pause
