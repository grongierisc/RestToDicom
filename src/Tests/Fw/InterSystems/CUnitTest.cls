/// *****************************************************
/// 
/// This class comes from InterSystens, provided at the
/// Global Summit 2015. It was not modified, except for 
/// the packages name.
/// 
/// *****************************************************
/// This is an abstract Requirement class.
/// Requirement implement classic Cache's %UnitTest functionality.
/// Also it may be runned through web browser.
/// Each requirement may also be represented as a CSP page.
/// After execution, requirement results are stored in ^UnitTest.Result global.
Class Tests.Fw.InterSystems.CUnitTest Extends (%UnitTest.TestCase, %CSP.Page)
{

/// This Parameter is updated by Perforce
Parameter SrcVer = "$Id: //trak/main/projects/PATHWAY/internal/cls/UnitTest/Abstract.xml#6 $";

/// Your test title
Parameter TITLE As %String;

/// default maximum global accesses for a single row based method call
/// can overide per class or pur explicitly in each method call
Parameter GlobalsMaxMethod = 100;

/// default maximum global accesses for a query
/// can overide per class or pur explicitly in each method call
Parameter GlobalsMaxQuery = 1000;

/// This method is used to display a test page.
ClassMethod OnPage() As %Status [ ServerOnly = 1 ]
{
   // 2016.1 : We need to clear %session lock before running tests in a
   // "web page mode" without errors.
   lock
   do ##class(Tests.Fw.InterSystems.CFormatter).Run(..%ClassName(1))
   Quit $$$OK
}

/// Run this specific test (in debug mode)
ClassMethod Run(qualifiers As %String = "") As %Status [ ProcedureBlock = 1 ]
{
   set sc=##class(Tests.Fw.InterSystems.CManager).RunTest(..%ClassName(1),"/recursive=0"_qualifiers)
   quit sc
}

/// Run this test and all its children
ClassMethod RunRecursive(qualifiers As %String = "") As %Status [ ProcedureBlock = 1 ]
{
   set sc=##class(Tests.Fw.InterSystems.CManager).RunTest(..%ClassName(1),"/recursive=1"_qualifiers)
   quit sc
}

/// Execute expression using current object's context
Method Execute(expr) As %String
{
   n %result
   x "s %result="_expr
   quit %result
}

/// Log execution HTML result. Now it is stored as a log message.
Method LogResult(result)
{
   set oldDisplay=..Manager.Display
   set ..Manager.Display=""
   do ..LogMessage($g(result))
   set ..Manager.Display=oldDisplay
   quit
}

/// Get last test result instance id, dateTime, status, duration and HTML
/// All this information is stored in ^UnitTest.Result
ClassMethod GetLastResult(ByRef dateTime, ByRef status, ByRef duration, ByRef html, ByRef suite) As %String [ ProcedureBlock = 1 ]
{
   set (dateTime,status,duration,html,suite)=""
   set name=..%ClassName(1)
   &sql(select Duration, TestSuite->TestInstance, TestSuite->Name, TestSuite->TestInstance->DateTime
      into :qDuration, :qInstance, :qSuite, :qDateTime
      from %IGNOREINDICES %UnitTest_Result.TestCase.idxName %UnitTest_Result.TestCase
      where Name=:name
      order by TestSuite->TestInstance DESC)
   if SQLCODE quit ""
   set dateTime=qDateTime
   set duration=qDuration
   set status=##class(%UnitTest.Report).GetTestStatus($znspace, qInstance, qSuite, name)
   set htmlIndex=$o(^UnitTest.Result(qInstance, qSuite, name, "TestRequirement",""),-1)-1
   set html=$lg($g(^UnitTest.Result(qInstance, qSuite, name, "TestRequirement",htmlIndex)),3)
   set suite=qSuite
   quit qInstance
}

Method AssertEqualsViaMacro(autoquoted = "", value1 = "", value2 = "", description = "") As %Boolean
{
   Set manager=r%Manager
   Set description=$g(description)_": "_value1_"=="_value2_" in "_..ParseAutoQuoted(autoquoted,"equals")
   Set success=value1=value2
   Do manager.LogAssert(success,"AssertEquals",description)
   If 'success&&'..Debug Quit $$$ERROR(5001,description)
   If 'success Break
   Quit $$$OK
}

Method AssertNotEqualsViaMacro(autoquoted = "", value1 = "", value2 = "", description = "") As %Boolean
{
   s success=##super(autoquoted, value1, value2, description)
   i 'success quit $$$ERROR(5001,description_": "_value1_"=="_value2_" in "_autoquoted)
   q $$$OK
}

Method AssertTrueViaMacro(autoquoted = "", value = "", description = "") As %Boolean
{
   s success=##super(autoquoted, value, description)
   i 'success quit $$$ERROR(5001,description_": "_value_"!=TRUE in "_autoquoted)
   q $$$OK
}

Method AssertNotTrueViaMacro(autoquoted = "", value = "", description = "") As %Boolean
{
   s success=##super(autoquoted, value, description)
   i 'success quit $$$ERROR(5001,description_": "_value_"== TRUE in "_autoquoted)
   q $$$OK
}

Method AssertStatusOKViaMacro(autoquoted = "", status = "", description = "") As %Boolean
{
   s success=##super(autoquoted, status, .description)
   i 'success quit $$$ERROR(5001,description_" in "_autoquoted)
   q $$$OK
}

Method AssertStatusNotOKViaMacro(autoquoted = "", status = "", description = "") As %Boolean
{
   s success=##super(autoquoted, status, description)
   i 'success quit $$$ERROR(5001,description_" IS OK in "_autoquoted)
   q $$$OK
}

Method AssertStatusEqualsViaMacro(autoquoted = "", value1 = "", value2 = "", description = "") As %Boolean
{
   s success=##super(autoquoted, value1, value2, description)
   i 'success quit $$$ERROR(5001,description_": STATUS NOT EQUAL in "_autoquoted)
   q $$$OK
}

Method AssertFilesSameViaMacro(autoquoted, file1, file2, description) As %Boolean
{
   s success=##super(autoquoted, file1, file2, description)
   i 'success quit $$$ERROR(5001,description_": "_file1_"!="_file2_" in "_autoquoted)
   q $$$OK
}

/// Run a class method and:
/// 1. compare the result against an expected value, this can be a single value "A" or a list $lb("A","B","C")
/// 2. compare the global count against an expected maximum
/// itmid can uniquely identify a specific test in list within a test method e.g. #1.1,   #1.2  etc
/// output informative information about the code that was run, the actual value and the expected value
Method StringEquals(itmid, expectedvalue, globalsmax, classname, methodname, args...) As %Status [ Final ]
{
   If +$g(globalsmax)=0 set globalsmax=..#GlobalsMaxMethod
   Set tResult="-99999"
   
   try {
      Set pTime=$zh
      Set pLines=$zu(67,8,$j)
      Set pGlobals=$zu(67,9,$j)
      
      If $g(args)="" Set tResult=$classmethod(classname,methodname)
      If $g(args)=1 Set tResult=$classmethod(classname,methodname,args(1))
      If $g(args)=2 Set tResult=$classmethod(classname,methodname,args(1),args(2))
      If $g(args)=3 Set tResult=$classmethod(classname,methodname,args(1),args(2),args(3))
      If $g(args)=4 Set tResult=$classmethod(classname,methodname,args(1),args(2),args(3),args(4))
      If $g(args)=5 Set tResult=$classmethod(classname,methodname,args(1),args(2),args(3),args(4),args(5))
      If $g(args)=6 Set tResult=$classmethod(classname,methodname,args(1),args(2),args(3),args(4),args(5),args(6))
      If $g(args)=7 Set tResult=$classmethod(classname,methodname,args(1),args(2),args(3),args(4),args(5),args(6),args(7))
      If $g(args)=8 Set tResult=$classmethod(classname,methodname,args(1),args(2),args(3),args(4),args(5),args(6),args(7),args(8))
      //no reason this is limited to 8 - at the tme of writing this was more than enough for the ct classes

      Set pTime=$zh-pTime
      Set pLines=$zu(67,8,$j)-pLines
      Set pGlobals=$zu(67,9,$j)-pGlobals
   } catch(e) {
      //try and void the pain of hidden errors and put them
      Set tResult=e.Name_" "_e.Location

      Set pTime=""
      Set pLines=""
      Set pGlobals=""
   }
   

   //if both are lists should use $listsame... but for now format as strings
   if $listvalid(expectedvalue)&&(expectedvalue'="") set expectedvalue="["_$lts(expectedvalue,",")_"]"
   if $listvalid(tResult)&&(tResult'="") set tResult="["_$lts(tResult,",")_"]"

   set argsdisplay=""
   for j=1:1:$g(args) set argsdisplay=argsdisplay_$s(argsdisplay'="":",",1:"")_""""_args(j)_""""
   Do $$$AssertEquals(tResult,expectedvalue,"##Class("_classname_")."_methodname_"("_argsdisplay_") ["_itmid_"] Return Value: '"_tResult_"' Expected: '"_expectedvalue_"'")

   //less than or equals
   Do $$$AssertTrue(pGlobals'>globalsmax,"##Class("_classname_")."_methodname_"("_argsdisplay_") ["_itmid_"] Global Count: '"_pGlobals_"' Expected: '<="_globalsmax_"'")
}

/// Run a class query and:
/// 1. compare the result against an expected value, this is a list of lists (one list per expected row)
///   the comaprison will only check up to the first five rows returned
/// 2. compare the global count against an expected maximum
/// itmid can uniquely identify a specific test in list within a test method e.g. #1.1,   #1.2  etc
/// output informative information about the code that was run, the actual value and the expected value
Method QueryEquals(itmid, expectedvalue, globalsmax, classname, queryname, args...) As %Status [ Final ]
{
   If +$g(globalsmax)=0 set globalsmax=..#GlobalsMaxQuery
   Set tResult=$lb("-99999")
   try {
      Set pTime=$zh
      Set pLines=$zu(67,8,$j)
      Set pGlobals=$zu(67,9,$j)
      
      Set rs=##Class(%ResultSet).%New()
      Set rs.ClassName=classname
      Set rs.QueryName=queryname
      If $g(args)="" Set sc=rs.Execute()
      If $g(args)=1 Set sc=rs.Execute(args(1))
      If $g(args)=2 Set sc=rs.Execute(args(1),args(2))
      If $g(args)=3 Set sc=rs.Execute(args(1),args(2),args(3))
      If $g(args)=4 Set sc=rs.Execute(args(1),args(2),args(3),args(4))
      If $g(args)=5 Set sc=rs.Execute(args(1),args(2),args(3),args(4),args(5))
      If $g(args)=6 Set sc=rs.Execute(args(1),args(2),args(3),args(4),args(5),args(6))
      If $g(args)=7 Set sc=rs.Execute(args(1),args(2),args(3),args(4),args(5),args(6),args(7))
      If $g(args)=8 Set sc=rs.Execute(args(1),args(2),args(3),args(4),args(5),args(6),args(7),args(8))
      //no reason this is limited to 8 - at the tme of writing this was more than enough for the ct classes

      If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc)
      Set colcount=rs.GetColumnCount()
      Set tResult=""
      //test only first 5 rows
      For j=1:1:5 {
         If 'rs.Next() Quit
         
         Set valx=""
         for jj=1:1:colcount Set valx=valx_$lb(rs.GetData(jj))
         Set tResult=tResult_$lb(valx)
      }
      Do rs.Close()

      Set pTime=$zh-pTime
      Set pLines=$zu(67,8,$j)-pLines
      Set pGlobals=$zu(67,9,$j)-pGlobals

   } catch(e) {
      //try and void the pain of hidden errors and put them
      Set tResult=e.Name_" "_e.Location

      Set pTime=""
      Set pLines=""
      Set pGlobals=""
   }
   

   set argsdisplay=""
   for j=1:1:$g(args) set argsdisplay=argsdisplay_$s(argsdisplay'="":",",1:"")_$s($d(args(j)):""""_args(j)_"""",1:"")

   Do $$$AssertTrue($listsame(tResult,expectedvalue),"##Class("_classname_")."_queryname_"("_argsdisplay_") ["_itmid_"] Return Value: '"_..ListOfListToDisplay(tResult)_"' Expected: '"_..ListOfListToDisplay(expectedvalue)_"'")

   //less than or equals
   Do $$$AssertTrue(pGlobals'>globalsmax,"##Class("_classname_")."_queryname_"("_argsdisplay_") ["_itmid_"] Global Count: '"_pGlobals_"' Expected: '<="_globalsmax_"'")
}

/// output formatter to display a List of lists
ClassMethod ListOfListToDisplay(listoflist) As %String [ Final ]
{
   if '$listvalid(listoflist) Quit listoflist
   Set tResult=""
   for j=1:1:$ll(listoflist) {
      Set tResult=tResult_$s(tResult'="":",",1:"")_"$lb("""_$lts($lg(listoflist,j),""",""")_""")"
   }
   Quit $s(tResult'="":"$lb("_tResult_")",1:tResult)
}

}
