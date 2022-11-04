#!/bin/bash
# Usage install.sh [instanceName] [password]

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 3 ] || die "Usage install.sh [instanceName] [password] [namespace]"

DIR=$(dirname $0)
if [ "$DIR" = "." ]; then
DIR=$(pwd)
fi

instanceName=$1
password=$2

ClassImportDir=$DIR/install
NameSpace="RESTTODICOM"
CspPath="/api/resttodicom/v1"
CspPathPatient="/api/resttodicom/v1/patients"
CspFront="/worklist"
DirFront=$DIR/front
DirSrc=$DIR/src

irissession $instanceName -U USER <<EOF 
sys
$password
do \$system.OBJ.ImportDir("$ClassImportDir","*.cls","cubk",.errors,1)
write "Complation de l'installer done"
Set pVars("NAMESPACE")="$NameSpace"
Set pVars("CSPPath")="$CspPath"
Set pVars("CspPathPatient")="$CspPathPatient"
Set pVars("DirFront")="$DirFront"
Set pVars("CspFront")="$CspFront"
Do ##class(App.Installer).setup(.pVars)
zn "%SYS"

zw ##class(Security.Applications).Import("$DIR/misc/ApplicationsExport.xml")
Do ##class(Security.Users).UnExpireUserPasswords("*")

zn "$NameSpace"
do \$system.OBJ.ImportDir("$DirSrc","*.cls;*.inc","cubk",.errors,1)

do \$classmethod("Ens.Director", "SetAutoStart", "RestToDicom.Production", 0)

halt
EOF
