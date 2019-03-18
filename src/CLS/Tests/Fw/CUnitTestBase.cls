/// Supports : 
///  $$$AssertEquals       Returns true if expressions are equal.           do $$$AssertEquals(x,y,"x equals y")
///  $$$AssertNotEquals    Returns true if expressions are not equal.       do $$$AssertNotEquals(x,y,"x is not equal to y")
///  $$$AssertStatusOK     Returns true if the returned status code is 1.   do $$$AssertStatusOK(sc,"Status is OK")
///  $$$AssertStatusNotOK  Returns true if the returned status code is 0.   do $$$AssertStatusNotOK(sc,"Status is NotOK")
///  $$$AssertTrue         Returns true if the expression is true.          do $$$AssertTrue(x=y,"Expression x=y is true")
///  $$$AssertNotTrue      Returns true if the expression is not true.      do $$$AssertNotTrue(x=y,"Expression x=y is not true")
///  $$$AssertFilesSame    Returns true if two files are identical.         do $$$AssertFilesSame(output.log,reference.log,"Comparing output.log to reference.log")
///  $$$LogMessage         Writes a log message to the ^UnitTestLog global. do $$$LogMessage("My message")
/// 
/// This class is only a wrapper, to prevent having to inherit a "InterSystems" class in CHS classes.
Class Tests.Fw.CUnitTestBase Extends (Tests.Fw.InterSystems.CUnitTest, Tests.Fw.CExecuteTests, Tests.Fw.Mock.CMockManager)
{

Parameter bSQLTransactionEnabled As %Boolean = 1;

ClassMethod RunTests()
{
   do ##super(1)
}

Method EnableSuccessfulAssert(bEnable As %Boolean, ByRef bPreviousValue As %Boolean)
{
   do ..LogMessage("Turning successful Assert " _ $case(bEnable, 1 :"ON", 0 : "OFF"))
   set bPreviousValue = ..Manager.bShowSuccessfulAssert
   set ..Manager.bShowSuccessfulAssert = bEnable
}

/// Extracts the data of a XData test section into a stream.
/// If the data is test encapsulated in <CDATA> nodes, they are
/// removed from the stream content.
Method GetXDataPayload(strXDataName As %String) As %Stream.Object
{
   set xDataContentStream = ##class(%Stream.TmpCharacter).%New()
   
   // If no class name is given, use the current one.
   set:(strXDataName '[ "||") strXDataName = ..%ClassName(1) _ "||" _ strXDataName
   
   set xData = ##class(%Dictionary.CompiledXData).%OpenId(strXDataName)
   
   if ($IsObject(xData))
   {
      #Dim line As %String = xData.Data.ReadLine()

      // If the first line starts by <CDATA>, it is removed, as well as the closing tag.
      if (line = "<CDATA></CDATA>")
      {
         do xDataContentStream.WriteLine("")
      }
      elseif (line = "<CDATA>")
      {
         while ('xData.Data.AtEnd)
         {
            set line = xData.Data.ReadLine()
            do:(line '= "</CDATA>") xDataContentStream.WriteLine(line)
         }
      }
      else
      {
         do xDataContentStream.CopyFrom(xData.Data)   
      }
   }

   do xDataContentStream.Rewind()
      
   quit xDataContentStream
}

Method GetHL7FromString(strHL7Message As %String, strMessageSchemaCategory As %String = "") As EnsLib.HL7.Message
{
   #Dim hl7Message As EnsLib.HL7.Message = ##class(EnsLib.HL7.Message).ImportFromString(strHL7Message)
   set srv = ##class(EnsLib.HL7.Service.FileService).%New("Name")
   set srv.MessageSchemaCategory = strMessageSchemaCategory
   set:(strMessageSchemaCategory = "") srv.MessageSchemaCategory = hl7Message.TypeVersion
   do hl7Message.PokeDocType(srv.resolveDocType(hl7Message))
   quit hl7Message
}

Method GetHL7FromXData(strXDataName As %String, strMessageSchemaCategory As %String = "") As EnsLib.HL7.Message
{
   quit ..GetHL7FromString(..GetXDataPayload(strXDataName).Read(1000000), strMessageSchemaCategory)
}

Method GetResultSetFromXData(strXDataName As %String) As Tests.Fw.Mock.CMockResultSet
{
	quit ##class(Tests.Fw.Mock.CMockResultSet).CreateFromXData(strXDataName)
}

}
