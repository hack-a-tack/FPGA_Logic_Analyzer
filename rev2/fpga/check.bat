@echo off
setlocal
rem %~f1 must be captured BEFORE cd /d below, while cwd is still whatever the
rem caller invoked from -- otherwise a caller-relative path (e.g. run from the
rem repo root as "rev2\fpga\check.bat rev2\fpga\rtl\x.vhd") gets silently
rem re-resolved against this script's own directory instead and fails to open.
set "ARG1=%~f1"
cd /d "%~dp0"

if not exist build mkdir build

set RTL=rtl

if not "%~1"=="" (
	echo Analyzing %~1 ...
	ghdl -a --std=08 --workdir=build "%ARG1%"
	if errorlevel 1 (
		echo.
		echo FAILED: %~1
		exit /b 1
	)
	echo OK: %~1
	exit /b 0
)

rem Dependency order, derived from actual "use work." clauses and entity
rem instantiations in rev2\fpga\rtl (checked 2026-08-18), not guessed from names:
rem   - la_pkg.vhd is the only package. It has no work.* dependencies of its
rem     own, so it goes first. uart_pkg.vhd was deleted (2026-08-18): it was a
rem     near-duplicate of la_pkg's f_clks_per_bit, and la_pkg is now the single
rem     source of truth.
rem   - uart_tx.vhd / uart_rx.vhd are the only files with a "use work.<pkg>"
rem     clause (both use work.la_pkg, since the uart_pkg repoint above).
rem   - every other module below has no use work.* clause and instantiates
rem     nothing, so its position among the leaf modules does not matter.
rem   - top.vhd is the only file with entity WORK.* instantiations (of every
rem     other module in this list), so it must come last. It is EXPECTED to
rem     fail here -- see TOP_TODO.md. That is not a check.bat bug.
set FILES=%RTL%\la_pkg.vhd %RTL%\SB_HFOSC.vhd %RTL%\clocking.vhd %RTL%\capture_engine.vhd %RTL%\trace_buffer.vhd %RTL%\tx_mux.vhd %RTL%\send_engine.vhd %RTL%\frame_tx.vhd %RTL%\rx_frame_parser.vhd %RTL%\analyzer_fsm.vhd %RTL%\cmd_parser.vhd %RTL%\resp_gen.vhd %RTL%\config_regs.vhd %RTL%\uart_tx.vhd %RTL%\uart_rx.vhd %RTL%\top.vhd

for %%F in (%FILES%) do (
	echo Analyzing %%F ...
	ghdl -a --std=08 --workdir=build "%%F"
	if errorlevel 1 (
		echo.
		echo FAILED: %%F
		exit /b 1
	)
)

echo.
echo All modules analyzed successfully.
exit /b 0