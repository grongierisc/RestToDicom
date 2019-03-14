Include %occInclude

Class App.Installer
{

XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>

 <Role Name="AppRole" Description="Role to access and use the App" Resources="%DB_IRISSYS:RW,%Admin_Secure:U" />

    <Log Text="Version d'IRIS ${VERSION}" Level="0"/>

    <If Condition='$L("${NAMESPACE}")=0'>
        <Error Status="$$$NamespaceDoesNotExist">
            <Arg Value="${NAMESPACE}"/>
        </Error>
    </If>

    <If Condition='(##class(Config.Namespaces).Exists("${NAMESPACE}")=0)'>
        <Log Text="Creating namespace ${NAMESPACE}" Level="0"/>
            
        <Namespace Name="${NAMESPACE}" Create="yes" Code="${NAMESPACE}" Ensemble="1" Data="${NAMESPACE}">
            <Configuration>
                <Database Name="${NAMESPACE}" Dir="${MGRDIR}/${NAMESPACE}" Create="yes"/>
            </Configuration>
        
            <CSPApplication Url="/csp/${NAMESPACE}" Directory="${CSPDIR}/${NAMESPACE}" AuthenticationMethods="64" IsNamespaceDefault="true" Grant="AppRole" />

        </Namespace>
    </If>

</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 0, pInstaller As %Installer.Installer) As %Status [ CodeMode = objectgenerator, Internal ]
{
	
     Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "Install")
}

}
