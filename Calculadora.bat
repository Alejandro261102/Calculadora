@echo off
:menu
cls
echo ======================================
echo      Calculadora de Numeros Complejos
echo ======================================
echo 1. Suma
echo 2. Resta
echo 3. Multiplicacion
echo 4. Division
echo 5. Salir
echo ======================================
set /p option="Elige una opcion: "

if "%option%"=="1" goto suma
if "%option%"=="2" goto resta
if "%option%"=="3" goto multiplicacion
if "%option%"=="4" goto division
if "%option%"=="5" goto salir
goto menu

:suma
cls
call :input "Suma"
set /a real_result=%real1% + %real2%
set /a imag_result=%imag1% + %imag2%
call :format_output %real_result% %imag_result%
pause
goto menu

:resta
cls
call :input "Resta"
set /a real_result=%real1% - %real2%
set /a imag_result=%imag1% - %imag2%
call :format_output %real_result% %imag_result%
pause
goto menu

:multiplicacion
cls
call :input "Multiplicacion"
set /a real_result=%real1% * %real2% - %imag1% * %imag2%
set /a imag_result=%real1% * %imag2% + %real2% * %imag1%
call :format_output %real_result% %imag_result%
pause
goto menu

:division
cls
call :input "Division"
set /a denom=%real2% * %real2% + %imag2% * %imag2%
if %denom% equ 0 (
    echo Error: Division por cero no permitida.
    pause
    goto menu
)
call :float_division %real1% %real2% %imag1% %imag2%
pause
goto menu

:input
setlocal
echo Ingresa los numeros complejos para la %1
set /p real1="Parte real del primer numero: "
set /p imag1="Parte imaginaria del primer numero: "
set /p real2="Parte real del segundo numero: "
set /p imag2="Parte imaginaria del segundo numero: "
endlocal & set real1=%real1% & set imag1=%imag1% & set real2=%real2% & set imag2=%imag2%
goto :eof

:format_output
set real=%1
set imag=%2
if %imag% geq 0 (
    echo El resultado es: %real% + %imag%i
) else (
    set imag_positive=%imag:~1%
    echo El resultado es: %real% - %imag_positive%i
)
goto :eof

:float_division
setlocal
set real1=%1
set real2=%2
set imag1=%3
set imag2=%4

rem Usar PowerShell para la division con numeros flotantes y 3 decimales
for /f "tokens=*" %%A in ('powershell -command "[math]::Round((%real1% * %real2% + %imag1% * %imag2%) / (%real2% * %real2% + %imag2% * %imag2%), 3)"') do set real_result=%%A
for /f "tokens=*" %%B in ('powershell -command "[math]::Round((%imag1% * %real2% - %real1% * %imag2%) / (%real2% * %real2% + %imag2% * %imag2%), 3)"') do set imag_result=%%B

call :format_output %real_result% %imag_result%
endlocal
goto :eof

:salir
exit
