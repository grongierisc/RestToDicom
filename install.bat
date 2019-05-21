::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off

:: Parameter to modify
set IRIS_DIR="C:\InterSystems\IRIS"
set /p IRIS_DIR= "Please enter the path of the Intersystems IRIS directory [C:\InterSystems\IRIS] : "

:: Pre-configured variables
set BUILD_DIR=install\App
set NAMESPACE=USER

set XML_EXPORT_DIR=docs
set INSTALL_PACKAGE_NAME=App

set NAMESPACE_TO_CREATE=RESTTODICOM
set SOURCE_DIR=src
set FRONT_DIR=front
set CSP_PATH=/api/resttodicom/v1
set CSP_PATH_PATIENT=/api/resttodicom/v1/patients
set CSP_FRONT=/worklist

:: Build and import application to IRIS
echo Importing project...
(


echo zn "%NAMESPACE%" set st = $system.Status.GetErrorText($system.OBJ.ImportDir("%~dp0%BUILD_DIR%",,"ck",,1^^^)^^^) w "IMPORT STATUS: "_$case(st="",1:"OK",:st^^^), ! 
echo set pVars("NAMESPACE"^^^) = "%NAMESPACE_TO_CREATE%"
echo set pVars("SourceDir"^^^) = "%~dp0%SOURCE_DIR%"
echo set pVars("DirFront"^^^)= "%~dp0%FRONT_DIR%"

echo Set pVars("CSPPath"^^^)="%CSP_PATH%"
echo Set pVars("CspPathPatient"^^^)="%CSP_PATH_PATIENT%"
echo Set pVars("CspFront"^^^)="%CSP_FRONT%"

echo do ##class(App.Installer^^^).setup(.pVars^^^)
echo zn "%%SYS"

echo zw ##class(Security.Applications^^^).Import("%~dp0%misc\ApplicationsExport.xml"^^^)


echo zn "%NAMESPACE_TO_CREATE%"
echo do $system.OBJ.ImportDir("%~dp0%SOURCE_DIR%","*.cls;*.inc","cubk",.errors,1^^^)

) | "%IRIS_DIR%\bin\irisdb.exe" -s "%IRIS_DIR%\mgr" -U %NAMESPACE%

echo:
echo ... Done
timeout 2 >nul
