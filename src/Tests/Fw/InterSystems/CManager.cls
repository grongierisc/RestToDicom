/// *****************************************************
/// 
/// This class comes from InterSystens, provided at the
/// Global Summit 2015. It was not modified, except for 
/// the packages name.
/// 
/// *****************************************************
/// Sightly changed %UnitTest manager.
/// The main goal is to use use class definitions instead of filesystem for testing
Class Tests.Fw.InterSystems.CManager Extends %UnitTest.Manager
{

Property bSQLTransactionEnabled As %Boolean [ InitialExpression = 1 ];

/*-------------------------------------------------------------------------------------------------------
// Modification to be able not to show the ASSERT that passed.
// The modification is simply to add the bShowSuccessfulAssert property, override LogAssert method 
// and change the last else into an Elseif (..bShowSuccessfulAssert = 1).
// The rest of the code was simply reformatted for better readability.
//-------------------------------------------------------------------------------------------------------*/
Property bShowSuccessfulAssert As %Boolean [ InitialExpression = 1 ];

Method LogAssert(success, action, description, extra)
{
   Set testsuite=i%TheStack(i%TheStack, "suite")
   Set testcase=i%TheStack(i%TheStack, "case")
   Set testmethod = i%TheStack(i%TheStack, "method")
   If testmethod = ""
   {
      Quit
   }
   Set next = $o(^||TempLog(i%TempLogIndex, testsuite, testcase, testmethod, ""), -1) + 1
   Set ^||TempLog(i%TempLogIndex, testsuite, testcase, testmethod, next) = $lb(success, action, description)
   Set line = action _ ":" _ description _ " (" _ ..GetTestState(success) _ ")"
   If 'success,..Display["error"
   {
      Do ..PrintErrorLine(line)
   }
   Elseif (..bShowSuccessfulAssert = 1)
   {
      Do ..PrintLine(line,4)
   }
}

/*-------------------------------------------------------------------------------------------------------
// End modification
//-------------------------------------------------------------------------------------------------------*/
/// Same as <b>RunTest</b>, but requires three arguments.  These arguments can be null, as ("","","").
ClassMethod RunTestSuites(testspec As %String = "", qspec As %String = "", userparam As %String = "") As %Status
{
   Set manager=..%New()
   If manager=$$$NULLOREF Quit %objlasterror
   
   Set sc=$$$qualifierParse("UnitTest",.qspec,.qstruct) q:$$$ISERR(sc) sc
   
   Set manager.Debug=$$$qualifierGetValue(qstruct,"debug")
   Set manager.Display=$s($$$qualifierGetValue(qstruct,"displaylog"):"log",1:"")_","_$s($$$qualifierGetValue(qstruct,"displayerror"):"error",1:"")
   Set manager.UserParam=userparam
   
   Set suite=$p(testspec,":",1)
   ; tests variable is divided by suites
   If $$$qualifierGetValue(qstruct,"recursive")=0 {
      Set tests(suite)=$lb(suite)
   } else {
      Set tests(suite)=$lb(suite)
      Set child=suite_"."
      Set pointCount=$l(child,".")
      For {
         Set child=$o(^oddDEF(child))
         If child'[(suite_".") q
         If '$$issubclassof^%occCompile(child,"%UnitTest.TestCase") Continue
         Set tests($p(child,".",1,pointCount))=$g(tests($p(child,".",1,pointCount)))_$lb(child)
      }
   }
   
   Set zhBegin=$zh
   
   Set suite="" For  Set suite=$o(tests(suite)) Quit:suite=""  Do
   . Do manager.RunOneTestSuite(suite,tests(suite),testspec,.qstruct)
   
   Do manager.SaveResult($zh-zhBegin)
   
   Set manager.Display="log,error"
   If $$$qualifierGetValue(qstruct,"run") Do manager.PrintURL()
   
   Quit $$$OK
}

Method RunOneTestSuite(suite As %String, tests As %String, testspec As %String, qstruct)
{
   Set testcase=$p(testspec,":",2)
   Set testmethod=$p(testspec,":",3)
   Do ..PrintLine("===============================================================================",0)
   Do ..PrintLine("Suite: "_suite,0)
   Do ..PrintLine("===============================================================================",0)
   
   Do ..LogStateBegin(suite) Do  Do ..LogStateEnd($zh-zhsBegin)
   . ;
   . Set zhsBegin=$zh
   . If tests="" Do ..PrintLine("No classes found for testsuite "_suite,1) Quit
   . ;
   . If $$$qualifierGetValue(qstruct,"run")=0 Do ..PrintLine("Skipping running testsuite "_suite,1)
   . Else  Do
   . . For i=1:1:$ll(tests) Do
   . . . Set class=$lg(tests,i)
   . . . If testcase'="",class'=testcase Quit
   . . . If '$$issubclassof^%occCompile(class,"%UnitTest.TestCase") Quit
   . . . Do ..RunOneTestCase(suite,class,testmethod)
   . ;
   . Set sc=$$$OK
   Do ..PrintLine("",0)
   
   Quit
}

Method RunOneTestCase(suite As %String, class As %String, test As %String = "")
{
   set ..bSQLTransactionEnabled = $Parameter(class, "bSQLTransactionEnabled")
   TStart:(..bSQLTransactionEnabled)
   do ##super(suite, class, test)
}

Method Cleanup() As %Status
{
   TRollback:(..bSQLTransactionEnabled)
   quit ##super()
}

ClassMethod OutputResultsXml(pFileName As %String) As %Status
{
   set File=##class(%File).%New(pFileName)
   set i=$o(^UnitTest.Result(""),-1)
   if i="" quit $$$OK // no results
   
   kill ^||TMP ; results global


   set suite="" for {
      set suite=$o(^UnitTest.Result(i,suite))
      quit:suite=""

      set ^||TMP("S",suite,"time")=$lg(^UnitTest.Result(i,suite),2)
      
      set case="" for {
         set case=$o(^UnitTest.Result(i,suite,case))
         quit:case=""
         
         if $i(^||TMP("S",suite,"tests"))
         set ^||TMP("S",suite,"C",case,"time")=$lg(^UnitTest.Result(i,suite),2)

         set method="" for {
            set method=$o(^UnitTest.Result(i,suite,case,method))
            quit:method=""

            set ^||TMP("S",suite,"C",case,"M",method,"time")=$lg(^UnitTest.Result(i,suite,case,method),2)

            set assert="" for {
               set assert=$o(^UnitTest.Result(i,suite,case,method,assert))
               quit:assert=""
               if $i(^||TMP("S",suite,"assertions"))
               if $i(^||TMP("S",suite,"C",case,"assertions"))
               if $i(^||TMP("S",suite,"C",case,"M",method,"assertions"))
               if $lg(^UnitTest.Result(i,suite,case,method,assert))=0 {
                  if $i(^||TMP("S",suite,"failures"))
                  if $i(^||TMP("S",suite,"C",case,"failures"))
                  if $i(^||TMP("S",suite,"C",case,"M",method,"failures"))
                  set ^||TMP("S",suite,"C",case,"M",method,"failure")=$get(^||TMP("S",suite,"C",case,"M",method,"failure"))
                     _$lg(^UnitTest.Result(i,suite,case,method,assert),2)
                     _": "_$lg(^UnitTest.Result(i,suite,case,method,assert),3)
                     _$C(13,10)
               }
            }

            if ($lg(^UnitTest.Result(i,suite,case,method))=0)
            && ('$d(^||TMP("S",suite,"C",case,"M",method,"assertions"))) {
               if $i(^||TMP("S",suite,"failures"))
               if $i(^||TMP("S",suite,"C",case,"failures"))
               if $i(^||TMP("S",suite,"C",case,"M",method,"failures"))
               set ^||TMP("S",suite,"C",case,"M",method,"failure")=$get(^||TMP("S",suite,"C",case,"M",method,"failure"))
                  _$lg(^UnitTest.Result(i,suite,case,method),3)
                  _": "_$lg(^UnitTest.Result(i,suite,case,method),4)
                  _$C(13,10)
            }

         }
         
         if $lg(^UnitTest.Result(i,suite,case))=0
         && ('$d(^||TMP("S",suite,"C",case,"M"))) {
            if $i(^||TMP("S",suite,"failures"))
            if $i(^||TMP("S",suite,"C",case,"failures"))
            if $i(^||TMP("S",suite,"C",case,"M",case,"failures"))
            set ^||TMP("S",suite,"C",case,"M",case,"failure")=$get(^||TMP("S",suite,"C",case,"M",case,"failure"))
               _$lg(^UnitTest.Result(i,suite,case),3)
               _": "_$lg(^UnitTest.Result(i,suite,case),4)
               _$C(13,10)
         }

      }
   }
   
   do File.Open("WSN")
   do File.WriteLine("<?xml version=""1.0"" encoding=""UTF-8"" ?>")
   do File.WriteLine("<testsuites>")
   set suite="" for {
      set suite=$o(^||TMP("S",suite))
      quit:suite=""

      do File.Write("<testsuite")
      do File.Write(" name="""_$zcvt(suite,"O","XML")_"""")
      do File.Write(" assertions="""_$g(^||TMP("S",suite,"assertions"))_"""")
      do File.Write(" time="""_$g(^||TMP("S",suite,"time"))_"""")
      do File.Write(" tests="""_$g(^||TMP("S",suite,"tests"))_"""")
      do File.WriteLine(">")

      set case="" for {
         set case=$o(^||TMP("S",suite,"C",case))
         quit:case=""

         do File.Write("<testsuite")
         do File.Write(" name="""_$zcvt(case,"O","XML")_"""")
         do File.Write(" assertions="""_$g(^||TMP("S",suite,"C",case,"assertions"))_"""")
         do File.Write(" time="""_$g(^||TMP("S",suite,"C",case,"time"))_"""")
         do File.Write(" tests="""_$g(^||TMP("S",suite,"C",case,"tests"))_"""")
         do File.WriteLine(">")

         
         set method="" for {
            set method=$o(^||TMP("S",suite,"C",case,"M",method))
            quit:method=""

            do File.Write("<testcase")
            do File.Write(" name="""_$zcvt(method,"O","XML")_"""")
            do File.Write(" assertions="""_$g(^||TMP("S",suite,"C",case,"M",method,"assertions"))_"""")
            do File.Write(" time="""_$g(^||TMP("S",suite,"C",case,"M",method,"time"))_"""")
            do File.WriteLine(">")
            if $d(^||TMP("S",suite,"C",case,"M",method,"failure")) {
               do File.Write("<failure type=""cache-error"" message=""Cache Error"">")
               do File.Write($zcvt(^||TMP("S",suite,"C",case,"M",method,"failure"),"O","XML"))
               do File.WriteLine("</failure>")
            }
            do File.WriteLine("</testcase>")
         }
         do File.WriteLine("</testsuite>")
      }
      do File.WriteLine("</testsuite>")
   }
   do File.WriteLine("</testsuites>")

   do File.Close()
   kill ^||TMP
   quit $$$OK
}

}
