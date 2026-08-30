@echo off
setlocal
rem Resolve to this script's own directory first, like check.bat -- so the tool
rem works the same way regardless of the caller's cwd (repo root or rev2\fpga).
cd /d "%~dp0"

if "%~1"=="" (
	echo Usage: run_tb.bat ^<module_name^>
	echo   e.g.: run_tb.bat la_pkg
	echo   e.g.: run_tb.bat frame_tx
	exit /b 1
)
set MODULE=%~1
set TBFILE=tb\%MODULE%_tb.vhd

if not exist "%TBFILE%" (
	echo FAILED: %TBFILE% not found
	exit /b 1
)

rem tb\ holds only testbench .vhd sources; everything ModelSim generates (the work
rem library, transcript, logs, .wlf) lands in simulations\ instead, mirroring how
rem rev1 split rev1\fpga\tb\ from rev1\fpga\simulations\. ModelSim resolves the bare
rem "work" library against the current directory, so cd into simulations\ once here
rem rather than passing -work on every vcom/vsim call below.
if not exist simulations mkdir simulations
cd /d simulations

if not exist work (
	vlib work
	if errorlevel 1 (
		echo FAILED: vlib work
		exit /b 1
	)
)

rem Dependency order: la_pkg first (every module either uses it or is unaffected by
rem it being present), then the DUT itself (skipped when the module under test IS
rem la_pkg -- there is no separate DUT file in that case), then the testbench.
echo Compiling la_pkg.vhd ...
vcom -2008 -quiet ..\rtl\la_pkg.vhd
if errorlevel 1 (
	echo FAILED: rtl\la_pkg.vhd did not compile
	exit /b 1
)

if /I not "%MODULE%"=="la_pkg" (
	if not exist "..\rtl\%MODULE%.vhd" (
		echo FAILED: rtl\%MODULE%.vhd not found
		exit /b 1
	)
	echo Compiling %MODULE%.vhd ...
	vcom -2008 -quiet "..\rtl\%MODULE%.vhd"
	if errorlevel 1 (
		echo FAILED: rtl\%MODULE%.vhd did not compile
		exit /b 1
	)
)

echo Compiling %MODULE%_tb.vhd ...
vcom -2008 -quiet "..\tb\%MODULE%_tb.vhd"
if errorlevel 1 (
	echo FAILED: tb\%MODULE%_tb.vhd did not compile
	exit /b 1
)

echo Running %MODULE%_tb ...
set LOGFILE=%MODULE%_tb.log
vsim -c -do ..\run_tb.do %MODULE%_tb > "%LOGFILE%" 2>&1

type "%LOGFILE%"

rem Pass/fail comes from the testbench's own summary line, not vsim's process exit
rem code -- every testbench prints an explicit "TEST PASSED"/"TEST FAILED" string
rem (see tb\README.md), and that is the authoritative signal here.
findstr /C:"TEST PASSED" "%LOGFILE%" >nul
if %errorlevel%==0 (
	echo.
	echo PASSED: %MODULE%_tb
	exit /b 0
)

echo.
echo FAILED: %MODULE%_tb
exit /b 1
