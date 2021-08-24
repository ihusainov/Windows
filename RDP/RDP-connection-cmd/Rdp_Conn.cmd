@echo off 
echo   ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
echo   1.  PVM-1     192.168.0.101  
echo   2.  PVM-2     192.168.0.102 
echo   3.  PVM-3     192.168.0.103  
echo   4.  PVM-4 	   192.168.0.104  
echo   5.  PVM-5     192.168.0.105  
echo   ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
echo   99. EXIT
 
set /p var=Select remote connection number: 
rem psexec - (psexec.exe \\192.168.0.1 query session)
if %var% EQU 1 (query session /server:192.168.0.101)
if %var% EQU 2 (query session /server:192.168.0.102)
if %var% EQU 3 (query session /server:192.168.0.103)
if %var% EQU 4 (query session /server:192.168.0.104)
if %var% EQU 5 (query session /server:192.168.0.105)
REM if %var% EQU 6 (query session /server:192.168.0.106)


if %var% EQU 99 (GOTO EXIT)

echo ------------------------------------------------------------------
set /p seansid=Enter the ID session: 
if %var% EQU 1 (Mstsc.exe /shadow:%seansid% /v:192.168.0.101 /control)
if %var% EQU 2 (Mstsc.exe /shadow:%seansid% /v:192.168.0.102 /control)
if %var% EQU 3 (Mstsc.exe /shadow:%seansid% /v:192.168.0.103 /control)
if %var% EQU 4 (Mstsc.exe /shadow:%seansid% /v:192.168.0.104 /control)
if %var% EQU 5 (Mstsc.exe /shadow:%seansid% /v:192.168.0.105 /control)
REM if %var% EQU 6 (Mstsc.exe /shadow:%seansid% /v:192.168.0.106 /control)
