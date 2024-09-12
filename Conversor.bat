::Equipo Doritos Nacho y Equipo Papas con Chile
:: 11/10/2024
:: version 2.1
:: Programa que sirve para el calculo de conversiones de unidades

@echo off
:menu
cls
    echo =============================
    echo       CONVERSOR DE UNIDADES      
    echo =============================
    echo 1. Convertir Unidades de Tiempo
    echo 2. Convertir Unidades de Velocidad
    echo 3. Convertir Unidades de Longitud
    echo 4. Convertir Unidades de Moneda
    echo 5. Salir
    echo =============================
    set /p opcion="Selecciona una opcion (1-5): "

    if %opcion%==1 goto tiempo
    if %opcion%==2 goto velocidad
    if %opcion%==3 goto longitud
    if %opcion%==4 goto moneda
    if %opcion%==5 goto salir
    goto menu

:tiempo
    cls
    echo =============================
    echo    CONVERSOR DE TIEMPO      
    echo =============================
    echo 1. Horas a Minutos
    echo 2. Minutos a Segundos
    echo 3. Segundos a Milisegundos
    echo 4. Horas a Dias
    echo 5. Minutos a Horas
    echo 6. Volver al Menu Principal
    echo =============================
    set /p tiempo_opcion="Selecciona una opcion (1-6): "

    if "%tiempo_opcion%"=="1" goto horasmin
    if "%tiempo_opcion%"=="2" goto minutosseg
    if "%tiempo_opcion%"=="3" goto segmilis
    if "%tiempo_opcion%"=="4" goto horasdias
    if "%tiempo_opcion%"=="5" goto minutoshor
    if "%tiempo_opcion%"=="6" goto menu
pause
goto tiempo

:horasmin
set /p horas="Ingresa las horas: "
for /f "delims=" %%i in ('powershell -command "Write-Output ([math]::Round([double]%horas% * 60, 2))"') do set resultado=%%i
echo %horas% horas son %resultado% minutos
pause
goto tiempo

:minutosseg
set /p minutos="Ingresa los minutos: "
for /f "delims=" %%i in ('powershell -command "Write-Output ([math]::Round([double]%minutos% * 60, 2))"') do set resultado=%%i
echo %minutos% minutos son %resultado% segundos
pause
goto tiempo

:segmilis
set /p segundos="Ingresa los segundos: "
for /f "delims=" %%i in ('powershell -command "Write-Output ([math]::Round([double]%segundos% * 1000, 2))"') do set resultado=%%i
echo %segundos% segundos son %resultado% milisegundos
pause
goto tiempo

:horasdias
set /p horas="Ingresa las horas: "
for /f "delims=" %%i in ('powershell -command "Write-Output ([math]::Round([double]%horas% / 24, 2))"') do set dias=%%i
set /a horas_restantes=%horas% %% 24
echo %horas% horas son %dias% dias
pause
goto tiempo

:minutoshor
set /p minutos="Ingresa los minutos: "
for /f "delims=" %%i in ('powershell -command "Write-Output ([math]::Round([double]%minutos% / 60, 2))"') do set horas=%%i
echo %minutos% minutos son %horas% horas
pause
goto tiempo

:velocidad
    cls
    echo =============================
    echo   CONVERSOR DE VELOCIDAD    
    echo =============================
    echo 1. Km/h a m/s
    echo 2. m/s a Km/h
    echo 3. mph a km/h
    echo 4. Volver al Menu Principal
    echo =============================
    set /p velocidad_opcion="Selecciona una opcion (1-4): "

    if %velocidad_opcion%==1 goto kmhms
    if %velocidad_opcion%==2 goto msakh
    if %velocidad_opcion%==3 goto millas
    if %velocidad_opcion%==4 goto menu
    pause
    goto velocidad

:: Se utiliza PowerShell para realizar el cálculo con números flotantes, (powershell -command "[math]::round()"). Y la función round() de PowerShell redondea el resultado a 2 decimales.

Esta línea de comando se repite para cada tipo de conversión de velocidad, el resto del código se mantuvo de la forma original de los compañeros

:kmhms
    set /p kmh="Ingresa la velocidad en Km/h: "
    for /f "tokens=*" %%A in ('powershell -command "[math]::round((%kmh%*1000/3600), 2)"') do set resultado=%%A
    echo %kmh% Km/h son %resultado% m/s
    pause
    goto velocidad

:msakh
    set /p ms="Ingresa la velocidad en m/s: "
    for /f "tokens=*" %%A in ('powershell -command "[math]::round((%ms%*3600/1000), 2)"') do set resultado=%%A
    echo %ms% m/s son %resultado% Km/h
    pause
    goto velocidad
    
:millas
    set /p millas="Ingresa la velocidad en millas por hora: "
    for /f "tokens=*" %%A in ('powershell -command "[math]::round((%millas%*1.609), 2)"') do set kmh=%%A
    echo %millas% mph son %kmh% km/s
    pause
    goto velocidad

:longitud
    cls
    echo =============================
    echo   CONVERSOR DE LONGITUD     
    echo =============================
    echo 1. Kilometros a Millas
    echo 2. Metros a Pies
    echo 3. Pulgadas a Centimetros
    echo 4. Volver al Menu Principal
    echo =============================
    set /p longitud_opcion="Selecciona una opcion (1-4): "

    if %longitud_opcion%==1 goto kmmillas
    if %longitud_opcion%==2 goto metrospies
    if %longitud_opcion%==3 goto pulgcent
    if %longitud_opcion%==4 goto menu
    pause
    goto longitud

:kmmillas
    set /p km="Ingresa los kilometros: "
    set /a resultado=km*621/1000
    echo %km% kilometros son %resultado% millas
    pause
    goto longitud

:metrospies
    set /p metros="Ingresa los metros: "
    set /a resultado=metros*328/1000
    echo %metros% metros son %resultado% pies
    pause
    goto longitud

:pulgcent
    set /p pulgadas="Ingresa las pulgadas: "
    set /a resultado=pulgadas*254/100
    echo %pulgadas% pulgadas son %resultado% centimetros
    pause
    goto longitud

:moneda
    cls
    echo =============================
    echo   CONVERSOR DE MONEDA       
    echo =============================
    echo 1. Dolares a Euros
    echo 2. Euros a Dolares
    echo 3. Euros a Pesos Mexicanos
    echo 4. Pesos Mexicanos a Euros
    echo 5. Dolares a Pesos Mexicanos
    echo 6. Pesos Mexicanos a Dolares
    echo 7. Euros a Libras
    echo 8. Volver al Menu Principal
    echo =============================
    set /p moneda_opcion="Selecciona una opcion (1-8): "

    if %moneda_opcion%==1 goto dolareuros
    if %moneda_opcion%==2 goto eurosdolar
    if %moneda_opcion%==3 goto eurospesos
    if %moneda_opcion%==4 goto pesoseuros
    if %moneda_opcion%==5 goto dolarpesos
    if %moneda_opcion%==6 goto pesosdolar
    if %moneda_opcion%==7 goto euroslibras
    if %moneda_opcion%==8 goto menu
    pause
    goto moneda

:dolareuros
    set /p moneda="Ingresa los dolares: "
    for /f "usebackq tokens=*" %%a in (`powershell -command "[float]$resultado = %moneda% * 0.93; [math]::round($resultado, 2)"`) do set resultado=%%a
    echo %moneda% dolares son %resultado% euros
    pause
    goto moneda

:eurosdolar
    set /p moneda="Ingresa los euros: "
    for /f "usebackq tokens=*" %%a in (`powershell -command "[float]$resultado = %moneda% * 1.07; [math]::round($resultado, 2)"`) do set resultado=%%a
    echo %moneda% euros son %resultado% dolares
    pause
    goto moneda

:eurospesos
    set /p moneda="Ingresa los euros: "
    for /f "usebackq tokens=*" %%a in (`powershell -command "[float]$resultado = %moneda% * 18.6; [math]::round($resultado, 2)"`) do set resultado=%%a
    echo %moneda% euros son %resultado% pesos mexicanos
    pause
    goto moneda

:pesoseuros
    set /p moneda="Ingresa los pesos: "
    for /f "usebackq tokens=*" %%a in (`powershell -command "[float]$resultado = %moneda% * 0.054; [math]::round($resultado, 2)"`) do set resultado=%%a
    echo %moneda% pesos mexicanos son %resultado% euros
    pause
    goto moneda

:dolarpesos
    set /p moneda="Ingresa los dolar: "
    for /f "usebackq tokens=*" %%a in (`powershell -command "[float]$resultado = %moneda% * 17.5; [math]::round($resultado, 2)"`) do set resultado=%%a
    echo %moneda% dolares son %resultado% pesos mexicanos
    pause
    goto moneda

:pesosdolar
    set /p moneda="Ingresa los pesos: "
    for /f "usebackq tokens=*" %%a in (`powershell -command "[float]$resultado = %moneda% * 0.057; [math]::round($resultado, 2)"`) do set resultado=%%a
    echo %moneda% pesos mexicanos son %resultado% dolares
    pause
    goto moneda

:euroslibras
    set /p moneda="Ingresa los euros: "
    for /f "usebackq tokens=*" %%a in (`powershell -command "[float]$resultado = %moneda% * 0.86; [math]::round($resultado, 2)"`) do set resultado=%%a
    echo %moneda% euros son %resultado% libras
    pause
    goto moneda

:salir
exit
