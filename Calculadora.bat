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
if %imag_result% geq 0 (
    echo El resultado es: %real_result% + %imag_result%i
) else (
    echo El resultado es: %real_result% %imag_result%i
)
pause
goto menu

:resta
cls
call :input "Resta"
set /a real_result=%real1% - %real2%
set /a imag_result=%imag1% - %imag2%
if %imag_result% geq 0 (
    echo El resultado es: %real_result% + %imag_result%i
) else (
    echo El resultado es: %real_result% %imag_result%i
)
pause
goto menu

:multiplicacion
cls
echo ==============================================
echo      Multiplicacion de Numeros Complejos
echo ==============================================
pause
goto menu

:division
cls

echo ==============================================
echo      Division de Numeros Complejos
echo ==============================================
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

:salir
exit
