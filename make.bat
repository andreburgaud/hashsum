@echo off

set PROJECT=HashSum
set VERSION=0.1.0

if {%1} == {} (goto :HELP)
if {%1} == {help} (goto :HELP)
if {%1} == {build} (goto :BUILD)
if {%1} == {dist} (goto :DIST)
if {%1} == {clean} (goto :CLEAN)
if {%1} == {fmt} (goto :FMT)
if {%1} == {release} (goto :RELEASE)
if {%1} == {vtest} (v test src/) & (goto :EOF)
if {%1} == {pytest} (pytest -v tests) & (goto :EOF)
goto :HELP

:BUILD
mkdir build
for %%i in (src\*.v) do (
    echo Building %%i...
    v fmt %%i
    v -o build\%%~ni.exe %%i
  )
)
goto :EOF

:DIST
del /q dist\*.exe
v test src/
mkdir dist
for %%i in (src\*.v) do (
    echo Building %%i...
    v -prod -o dist\%%~ni.exe %%i
    strip dist\%%~ni.exe
    upx dist\%%~ni.exe
  )
)
goto :EOF

:CLEAN
del /q dist\*.exe
del /q build\*.exe
del *.zip
goto :EOF

:FMT
for /r %%i in (*.v) do (
    echo Formatting %%i...
    v fmt -l %%i
  )
)
goto :EOF

:RELEASE
mkdir %PROJECT%
copy dist\* %PROJECT%
powershell Compress-Archive %PROJECT% %PROJECT%.%VERSION%.zip
rmdir /s /q %PROJECT%
goto :EOF

:HELP
echo.
echo Usage:
echo.  make ^<task^>
echo.
echo make help     Display this help
echo make build    Build all in development mode
echo make dist     Build compressed optimize executables
echo make clean    Delete executables
echo make fmt      List files to be formatted
echo make release  Create a zip package of all the executables in dist
echo make vtest    Execute unit tests
echo make pytest   Execute CLI pytest
