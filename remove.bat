::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off

:: Parameter to modify
set IRIS_DIR="C:\InterSystems\IRIS"
set /p IRIS_DIR= "Please enter the path of the Intersystems IRIS directory [C:\Intersystems\IRIS] : "

set USERNAME="_SYSTEM"
set /p USERNAME= "Please enter your IRIS username [_SYSTEM] : "

set /p PASSWORD= "Please enter your password : "

:: Pre-configured variables
set NAMESPACE_TO_REMOVE=RESTTODICOM

:: Removing application from IRIS
echo Removing project...
(
echo %USERNAME%
echo %PASSWORD%

echo set NsExist = ##class(Config.Namespaces^^^).Exists("%NAMESPACE_TO_REMOVE%"^^^)
echo do:NsExist ##class(Config.Namespaces^^^).Delete("%NAMESPACE_TO_REMOVE%"^^^)
echo do:NsExist ##class(%%Library.EnsembleMgr^^^).DisableNamespace("%NAMESPACE_TO_REMOVE%"^^^) 

echo set CspExist = ##class(Security.Applications^^^).Exists("/csp/%NAMESPACE_TO_REMOVE%"^^^)
echo do:CspExist ##class(Security.Applications^^^).Delete("/csp/%NAMESPACE_TO_REMOVE%"^^^)

echo set DbExist = ##class(Config.Databases^^^).Exists("%NAMESPACE_TO_REMOVE%"^^^)
echo set Directory = ##class(Config.Databases^^^).GetDirectory("%NAMESPACE_TO_REMOVE%"^^^)
echo do:DbExist ##class(Config.Databases^^^).Delete("%NAMESPACE_TO_REMOVE%"^^^)
echo do ##class(SYS.Database^^^).DeleteDatabase(Directory^^^)

echo halt
) | "%IRIS_DIR%\bin\irisdb.exe" -s "%IRIS_DIR%\mgr" -U "%%SYS"

echo:
echo ... Done
timeout 2 >nul