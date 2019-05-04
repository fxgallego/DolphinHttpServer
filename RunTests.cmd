dir C:\projects\Dolphin
@ECHO OFF
SET PATH=C:\projects\Dolphin;%PATH%
ECHO Running regression tests
echo. >DPRO.errors
Dolphin7 ..\DPRO.img7 -u -f RegressionTestsRun.st -q
set errorCode=%ERRORLEVEL%
TYPE DPRO.errors
if NOT "%APPVEYOR%"=="" powershell.exe -file UploadTestResults.ps1
EXIT /b %errorCode%
