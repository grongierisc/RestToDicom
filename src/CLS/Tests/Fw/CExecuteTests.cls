Class Tests.Fw.CExecuteTests Extends %RegisteredObject
{

/// Note ACGendron : Fonctionnement hasardeux avant Cach?2014 mais devrait 
///                  compiler quand m?e sans probl?e !
/// -----------------------------------------------------------------------------
ClassMethod RunTests(bIsClass As %Boolean = 0)
{
   #dim strClassName As %String = ..%ClassName(1)
   set:('bIsClass) strClassName = ..%PackageName()
   do ##class(Tests.Fw.InterSystems.CManager).RunTest(strClassName)
}

/// See http://localhost:8972/csp/docbook/DocBook.UI.Page.cls?KEY=TUNT_ExampleTestPortal 
ClassMethod EnableUnitTestFramework()
{
   #Dim strOldNS = $ZConvert($NAMESPACE, "L")
   ZNSpace "%SYS"
   set ^SYS("Security","CSP","AllowPrefix","/csp/"_strOldNS_"/","%UnitTest.") = 1
   ZNSpace strOldNS
}

ClassMethod DeleteAllOlderTest()
{
   do ##class(%UnitTest.Result.TestInstance).%DeleteExtent()
}

}
