/// *****************************************************
/// 
/// This class comes from InterSystens, provided at the
/// Global Summit 2015. It was not modified, except for 
/// the packages name.
/// 
/// *****************************************************
/// This is a class for tests that change transactional data.
/// It's run within a transaction which is rolled back at the end.
Class Tests.Fw.InterSystems.CUnitTestTransaction Extends Tests.Fw.InterSystems.CUnitTest
{

Method OnBeforeOneTest() As %Status
{
 TStart
 Quit $$$OK
}

Method OnAfterOneTest() As %Status
{
 TRollback
 Quit $$$OK
}

}
