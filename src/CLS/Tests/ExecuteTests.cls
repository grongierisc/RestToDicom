Class Tests.ExecuteTests Extends Tests.Fw.CExecuteTests
{

ClassMethod RunTests(bIsClass As %Boolean = 0)
{
   #dim strClassName As %String = ..%ClassName(1)
   set:('bIsClass) strClassName = ..%PackageName()
   do ##class(Tests.Fw.InterSystems.CManager).RunTest(strClassName)
}

}
