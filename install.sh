#!/bin/bash
# Usage install.sh [instanceName] [password]

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 2 ] || die "Usage install.sh [instanceName] [password]"

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
SrcDir=$DIR/src

irissession $instanceName -U USER <<EOF 
SuperUser
$password
do \$system.OBJ.ImportDir("$ClassImportDir","*.cls","cubk",.errors,1)
write "Complation de l'installer done"
Set pVars("NAMESPACE")="$NameSpace"
Set pVars("CSPPath")="$CspPath"
Set pVars("CspPathPatient")="$CspPathPatient"
Do ##class(App.Installer).setup(.pVars)
zn "%SYS"

zw ##class(Security.Applications).Import("$DIR/misc/ApplicationsExport.xml")

zn "$NameSpace"
do \$system.OBJ.ImportDir("$SrcDir","*.*","cubk",.errors,1)

Do ##class(Ens.Director).StartProduction("RestToDicom.Production")

halt
EOF