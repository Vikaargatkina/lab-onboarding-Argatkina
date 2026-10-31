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
echo [Операционная система] >> "%REPORT%"
wmic os get Caption,Version /format:list
wmic os get Caption,Version /format:list >> "%REPORT%"
echo ----------------------------------------
echo ---------------------------------------- >> "%REPORT%"

echo [Процессор]
echo [Процессор] >> "%REPORT%"
wmic cpu get Name /format:list
wmic cpu get Name /format:list >> "%REPORT%"
echo ----------------------------------------
echo ---------------------------------------- >> "%REPORT%"

echo [Оперативная память (в КБ, округление до ГБ в уме)]
echo [Оперативная память] >> "%REPORT%"
wmic OS get TotalVisibleMemorySize,FreePhysicalMemory /format:list
wmic OS get TotalVisibleMemorySize,FreePhysicalMemory /format:list >> "%REPORT%"
echo ----------------------------------------
echo ---------------------------------------- >> "%REPORT%"

echo [Диск C (в байтах)]
echo [Диск C] >> "%REPORT%"
wmic logicaldisk where DeviceID="C:" get Size,FreeSpace /format:list
wmic logicaldisk where DeviceID="C:" get Size,FreeSpace /format:list >> "%REPORT%"
echo ----------------------------------------
echo ---------------------------------------- >> "%REPORT%"

echo [Установленные программы]
echo [Установленные программы] >> "%REPORT%"
echo Идёт сбор списка программ, пожалуйста, подождите...
echo.

powershell -NoProfile -Command "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* 2>$null | Select-Object -Property DisplayName | Where-Object {$_.DisplayName -ne $null} | ForEach-Object {$_.DisplayName}" 

powershell -NoProfile -Command "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*, HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* 2>$null | Select-Object -Property DisplayName | Where-Object {$_.DisplayName -ne $null} | ForEach-Object {$_.DisplayName}" >> "%REPORT%"

echo.
echo ========================================
echo Отчёт успешно сохранён в файл pc_report.txt
echo ========================================
pause
