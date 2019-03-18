Include %outUnitTest

/// This is the main class for the mocking framework. Mocks are objects pre-programmed with expectations which
/// form a specification of the calls they are expected to receive. They are used to replace a class injected
/// dependencies when testing that class. Using mocks you can make sure the which methods are called on a
/// dependency, validate parameters passed to each method an control the return value.
/// 
/// Usage example :
/// In this example we'll test the method Test() from class A. Class A has 2 injected dependencies which are class B and C.
/// The Test method on class A calls the Name() method on class B followed by a Location() method on class C and returns the
/// concatenation of both returned value.
/// 
/// First create the mocks:
/// set mockB = ..CreateMock()
/// set mockC = ..CreateMock())
/// 
/// Now create the test object:
/// set objectA = ##class("Name.Of.Package.A").%New(mockB, mockC)
/// 
/// Now do the expectation:
/// do ..Expect(mockB.Name()).AndReturn("Name")
/// do ..Expect(mockC.Location("Name")).AndReturn("Location")
/// 
/// Now go in test mode:
/// do ..ReplayAllMocks()
/// 
/// Do the test
/// do $$$AssertEquals(objectA.Test(), "Name" _ "Location")
/// 
/// Finally verify the mocks:
/// do ..VerifyAllMocks()
/// 
/// For more example see UnitTestsMock.CMockTest or tests that use the ..
/// See also: Tests.Fw.Mock.CExpectation
Class Tests.Fw.Mock.CMockManager [ Abstract ]
{

Property bInReplayMode As %Boolean [ InitialExpression = 0, Private ];

Property lstExpectation As %ListOfObjects [ Private ];

Property lstOfCreatedClass As %ListOfDataTypes [ Private ];

/// This methods creates a mock object extending CMockBase and the provided interface and returns it.
/// strInterfaceName: Name of the interface with the package information.
/// Usage example: set mock = ..CreateMock()
Method CreateMock(strInterfaceName As %String = "") As Tests.Fw.Mock.CMockBase
{
   #dim returnClass = $$$NULLOREF
   if (strInterfaceName '= "")
   {
      #dim strNewClassName As %String = "UnitTests." _ strInterfaceName _ "Mock"

      #dim strExtends As %String = strInterfaceName _ ",Tests.Fw.Mock.CMockBase"
      if ($$$ISOK(..CreateClass(strNewClassName, strExtends)))
      {
         do ..lstOfCreatedClass.Insert(strNewClassName)
         set returnClass = $ClassMethod(strNewClassName, "%New", $THIS)
      }
   }
   else
   {
      set returnClass = ##class(Tests.Fw.Mock.CMockBase).%New($THIS)
   }
   quit returnClass
}

/// Adds an expectation to the list. Return the parameter to enable chaining.
/// expectation: The expectation should not be created directly but by calling a method on the mock.
/// Usage example: do ..expect(mock.call(param1, param2, param3)).andReturn("return").times(1)
/// See also: Tests.Fw.Mock.CExpectation.
Method Expect(expectation As Tests.Fw.Mock.CExpectation) As Tests.Fw.Mock.CExpectation
{
   do ..lstExpectation.Insert(expectation)
   quit expectation
}

/// Sets the mockmanager in test mode. Must be called after the Expect but before doing the actual test.
/// Usage example: do ..ReplayAllMocks()
Method ReplayAllMocks()
{
   set ..bInReplayMode = 1
}

/// Verifies that all expected methods have been called.
/// Usage example: do ..VerifyAllMocks()
Method VerifyAllMocks()
{
   do $$$AssertEquals(..lstExpectation.Count(), 0, "Expectation list not empty")
   
   #Dim strFirstUnconsumedQuery As %String = ""
   do $$$AssertNotTrue(..IsUnconsumedResultSetLeft(.strFirstUnconsumedQuery), "Some defined ResultSet were not consumed (" _ strFirstUnconsumedQuery _ ")")
   
   set ..bInReplayMode = 0
   
   do ..CleanUp()
}

/// Creates a CNotNullObjectMockParamValidator. Use this during an expect when you don't know the specific
/// value of a parameter. This will validate it is the correct class and is not null.
/// strClassName: Name of the exected class with the package information.
/// Usage example: do ..expect(mock.call(..NotNullObject("%Stream.GlobalCharacter"), param2, param3))
Method NotNullObject(strClassName As %String) As Tests.Fw.Mock.IMockParamValidator
{
   quit ##class(Tests.Fw.Mock.CNotNullObjectMockParamValidator).%New(strClassName)
}

/// Creates a CIsEqualObjectParamValidator. Use this to validate that two objects are equals. Note that
/// for this method to work you need to have a IsEqual(object) method on your object. This parameter validator
/// will simply call that method.
Method IsEqualObject(object As %RegisteredObject)
{
   quit ##class(Tests.Fw.Mock.CIsEqualObjectParamValidator).%New(object)
}

/// Creates a CIsNotEqualParamValidator. Use this to validate that two datatypes objects are notequals. Note that
/// for this method to work on objects you need to have a IsEqual(object) method on your object.
Method IsNotEqual(objectorDatatype) As Tests.Fw.Mock.CIsNotEqualParamValidator
{
   quit ##class(Tests.Fw.Mock.CIsNotEqualParamValidator).%New(objectorDatatype)
}

Method UseCustomFunctionValidation(object As %RegisteredObject, strMethodName As %String) As Tests.Fw.Mock.CCustomFunctionParamValidator
{
   quit ##class(Tests.Fw.Mock.CCustomFunctionParamValidator).%New(object, strMethodName)
}

/// Creates a CMockByRefParam. Use this with ByRef parameters during an expect.
/// expectedValue: Expected value.
/// replaceByValue: Value to set in the parameter.
/// Usage example: do ..expect(mock.call(..ByRefParam("Expected", "ReplacedBy"), param2, param3))
Method ByRefParam(expectedValue, replaceByValue) As Tests.Fw.Mock.CMockByRefParam
{
   quit ##class(Tests.Fw.Mock.CMockByRefParam).%New(expectedValue, replaceByValue)
}

/**********************************************
      Internal methods do not call
***********************************************/
Method CleanUp() [ Internal ]
{
   
   #dim i As %Integer = 0
   for i = 1:1:..lstOfCreatedClass.Count()
   {
      do ..DeleteClass(..lstOfCreatedClass.GetAt(i))
   }
   do ..lstOfCreatedClass.Clear()
   
   // Also cleanup every defined ResultSet Overrides
   kill ^||CResultSetTools
   kill ^CResultSetTools

   set ..bInReplayMode = 0
   
   do $$$AssertEquals(..lstExpectation.Count(), 0, "Expectation list not empty")
   do ..lstExpectation.Clear()
}

Method CreateExpectation(instance As Tests.Fw.Mock.CMockBase, strMethodName As %String, lstParams As %ListOfDataTypes) As Tests.Fw.Mock.CExpectation [ Internal ]
{
   quit ##class(Tests.Fw.Mock.CExpectation).%New(instance, strMethodName, lstParams)
}

/// Since the return type is unknown we cant't specify %RegisteredObject or %DataType as the return value.
Method MethodCalled(instance As Tests.Fw.Mock.CMockBase, strMethodName As %String, ByRef lstParams As %ListOfDataTypes) [ Internal ]
{
   #dim returnValue = $$$NULLOREF
   
   #dim expectation As Tests.Fw.Mock.CExpectation = ..GetNextExpectation(instance, strMethodName)
   if (expectation '= $$$NULLOREF)
   {
      if ($$$ISOK(..ValidateMethodCalled(expectation, instance, strMethodName, lstParams)))
      {
         do ..DecrementExpectationTimes(expectation)
         
         do ..ProcessParameters(expectation, .lstParams, strMethodName)

         set returnValue = expectation.GetReturnValue()            
      }
   }
   
   quit returnValue
}

Method IsInReplayMode() As %Boolean [ Internal ]
{
   quit ..bInReplayMode
}

/// Used to retrieve a resultSet obtained by "%New". Used for Tests purpose.
Method SetMockResultSet(strQueryName As %String, xDataResultSetName As %String, bPrivateProcessGlobal As %Boolean = 1)
{
   #Dim nextUnusedIndex As %String = ""
   
   // NOTE : Using the ^|| global prefix creates a "process private global", 
   //        automatically deleted when the process execution ends.
   if (bPrivateProcessGlobal)
   {
      set nextUnusedIndex = ($Order(^||CResultSetTools("_" _ strQueryName, ""), -1) + 1)
      set ^||CResultSetTools("_" _ strQueryName, nextUnusedIndex) = xDataResultSetName
   }
   else
   {
      set nextUnusedIndex = ($Order(^CResultSetTools("_" _ strQueryName, ""), -1) + 1)
      set ^CResultSetTools("_" _ strQueryName, nextUnusedIndex) = xDataResultSetName
   }
}

ClassMethod GetMockResultSet(strQueryName As %String = "") As %ResultSet
{
   #Dim rs As %ResultSet = $$$NULLOREF
   
   try 
   {
      #Dim nextUnconsumedGlobal As %String = ""
      #Dim xDataResultSetName As %String = ""
      // First look at the private process globals
      if ($Data(^||CResultSetTools("_" _ strQueryName)))
      {
         // Get the first unconsumed XData and build a CMockResultSet, if any.
         set nextUnconsumedGlobal = $Order(^||CResultSetTools("_" _ strQueryName, ""))
         set xDataResultSetName = ^||CResultSetTools("_" _ strQueryName, nextUnconsumedGlobal)
         set:(xDataResultSetName '= "") rs = ##class(Tests.Fw.Mock.CMockResultSet).CreateFromXData(xDataResultSetName)
         
         // This result set was used with success, mark it
         kill:($IsObject(rs)) ^||CResultSetTools("_" _ strQueryName, nextUnconsumedGlobal)
      }
      elseif ($Data(^CResultSetTools("_" _ strQueryName)))
      {
         // Get the first unconsumed XData and build a CMockResultSet, if any.
         set nextUnconsumedGlobal = $Order(^CResultSetTools("_" _ strQueryName, ""))
         set xDataResultSetName = ^CResultSetTools("_" _ strQueryName, nextUnconsumedGlobal)
         set:(xDataResultSetName '= "") rs = ##class(Tests.Fw.Mock.CMockResultSet).CreateFromXData(xDataResultSetName)
         
         // This result set was used with success, mark it
         kill:($IsObject(rs)) ^CResultSetTools("_" _ strQueryName, nextUnconsumedGlobal)
      }
   }
   catch
   {
      // Trying to access an undefined global throws an error. Ignore it.
   }
   
   // If there are no defined CMockResultSet, create a standard one.
   set:('$IsObject(rs)) rs = ##class(%ResultSet).%New(strQueryName)   
   
   quit rs
}

// --- Private methods ---

Method GetNextExpectation(instance As Tests.Fw.Mock.CMockBase, strMethodName As %String) As Tests.Fw.Mock.CExpectation [ Internal, Private ]
{
   #dim expectation As Tests.Fw.Mock.CExpectation = $$$NULLOREF
   do $$$AssertTrue(..lstExpectation.Count() > 0, ..GetNoMoreMethodExpectedDescription(instance, strMethodName))
   if (..lstExpectation.Count() > 0)
   {
      set expectation = ..lstExpectation.GetAt(1)
   }
   
   quit expectation
}

Method ValidateMethodCalled(expectation As Tests.Fw.Mock.CExpectation, instance As Tests.Fw.Mock.CMockBase, strMethodName As %String, lstParams As %ListOfDataTypes) As %Status [ Internal, Private ]
{
   #dim status As %Status = $$$ERROR("")
   do $$$AssertEquals(expectation.GetInstance(), instance, ..GetUnexpectedMethodDescription(expectation, instance, strMethodName, lstParams))
   if (expectation.GetInstance() = instance)
   {
      do $$$AssertEquals(expectation.GetMethodName(), strMethodName, ..GetUnexpectedMethodDescription(expectation, instance, strMethodName, lstParams))
      if (expectation.GetMethodName() = strMethodName)
      {
         set status = $$$OK
      }
   }
   
   quit status
}

Method ProcessParameters(expectation As Tests.Fw.Mock.CExpectation, ByRef lstParams As %ListOfDataTypes, strMethodName As %String) [ Internal, Private ]
{
   do $$$AssertEquals(expectation.GetLstParameters().Count(), lstParams.Count(), ..GetParameterCountDescription(expectation, lstParams, strMethodName))
   
   if (expectation.GetLstParameters().Count() = lstParams.Count())
   {
      #dim i As %Integer = 1
      for i = 1:1:lstParams.Count()
      {
         do ..ProcessParameterAtIndex(i, expectation.GetLstParameters().GetAt(i), .lstParams, strMethodName)
      }
   }
}

Method ProcessParameterAtIndex(nIndex As %Integer, parameterExpected, ByRef lstParams As %ListOfDataTypes, strMethodName As %String) [ Internal, Private ]
{
   if ($IsObject(parameterExpected) && 
       parameterExpected.%Extends(##class(Tests.Fw.Mock.IMockParamValidator).%ClassName(1)))
   {
      do $$$AssertStatusOK(parameterExpected.Validate(lstParams.GetAt(nIndex)), parameterExpected.GetAssertDescription(nIndex, strMethodName))
   }
   elseif ($IsObject(parameterExpected) &&
           parameterExpected.%IsA(##class(Tests.Fw.Mock.CMockByRefParam).%ClassName(1)))
   {
      do ..ProcessParameterAtIndex(nIndex, parameterExpected.expectedValue, .lstParams, strMethodName)
      do lstParams.SetAt(parameterExpected.replaceByValue, nIndex)
   }
   else
   {
      #dim strAssertDescription = ..GetParameterDescription(parameterExpected,
                                                            lstParams.GetAt(nIndex),
                                                            nIndex,
                                                            strMethodName)
      
      // %Status datatype need to be compared in a special way !
      try
      { 
         #Dim dummy As %Status = parameterExpected
         do $System.Status.AppendStatus(dummy, lstParams.GetAt(nIndex))
         do $$$AssertStatusEquals(parameterExpected, lstParams.GetAt(nIndex), strAssertDescription)
      }
      catch
      {
         do $$$AssertEquals(parameterExpected, lstParams.GetAt(nIndex), strAssertDescription)
      }
   }
}

Method DecrementExpectationTimes(ByRef expectation As Tests.Fw.Mock.CExpectation) [ Internal, Private ]
{
   do expectation.DecrementTimes()
   if (expectation.GetTimes() = 0)
   {
      do ..lstExpectation.RemoveAt(1)
   }
}

// --- Private error helpers ---

Method GetUnexpectedMethodDescription(expectation As Tests.Fw.Mock.CExpectation, instance As Tests.Fw.Mock.CMockBase, strMethodNameReceived As %String, lstParamsReceived As %ListOfDataTypes) As %String [ Internal, Private ]
{
   #Dim strOutput As %String ="Expected Method: " _ expectation.GetInstance() _ "::" _ expectation.GetMethodName() _ " "
   set strOutput = strOutput _"Got: " _ instance _ "::" _strMethodNameReceived _ "("
   #Dim i As %Integer = 0
   for i=1:1:lstParamsReceived.Count()-1
   {  
      set strOutput = strOutput _ lstParamsReceived.GetAt(i)_", "
   }
   set strOutput = strOutput _ lstParamsReceived.GetAt(lstParamsReceived.Count())_") "
   
   quit strOutput
}

Method GetParameterCountDescription(expectation As Tests.Fw.Mock.CExpectation, lstParamsReceived As %ListOfDataTypes, strMethodName As %String) As %String [ Internal, Private ]
{
   quit "Expected Parameter count: " _ expectation.GetLstParameters().Count() _ " for method: " _ strMethodName _
        " Got: " _ lstParamsReceived.Count() _ " "
}

Method GetParameterDescription(expectedParameter, receivedParameter, nIndex As %Integer, strMethodName As %String) As %String [ Internal, Private ]
{
   quit "Expected Parameter(" _ nIndex _ ") value: '" _ expectedParameter _ "' for method: " _ strMethodName _
        " Got: '" _ receivedParameter _ "' "
}

Method GetNoMoreMethodExpectedDescription(instance As Tests.Fw.Mock.CMockBase, strMethodName As %String) As %String [ Internal, Private ]
{
   quit "Expected no more methods " _
        "Got: " _ instance.%ClassName(1) _ "::" _strMethodName _ " "
}

Method IsUnconsumedResultSetLeft(ByRef strFirstUnconsumedQuery As %String = "") As %Boolean [ Private ]
{
   set strFirstUnconsumedQuery = $Order(^||CResultSetTools(""))
   set:(strFirstUnconsumedQuery="") strFirstUnconsumedQuery = $Order(^CResultSetTools(""))
   quit (strFirstUnconsumedQuery '= "")
}

ClassMethod CreateClass(strNewClassName As %String, strExtends As %String = "", aParameters As %ArrayOfDataTypes = {$$$NULLOREF}) As %Status
{
   #dim classDef As %Dictionary.ClassDefinition = ##class(%Dictionary.ClassDefinition).%New(strNewClassName)
   if (strExtends '= "") 
   {
      set classDef.Super = strExtends
   }
   
   // Create/Override parameters in this class if required
   if ($IsObject(aParameters))
   {
      #Dim strParameterName As %String = ""
      #Dim strParameterValue As %String = aParameters.GetNext(.strParameterName)
      while (strParameterName '=  "")  
      {
         if (strParameterName '= "")
         {
            set parameter = ##class(%Dictionary.ParameterDefinition).%New(strNewClassName _ ":" _ strParameterName)
            set parameter.Default = strParameterValue
            do classDef.Parameters.Insert(parameter)
         }         
         set strParameterValue = aParameters.GetNext(.strParameterName)
      }   
   }
   
   do classDef.%Save()
   
   quit ##class(%SYSTEM.OBJ).Compile(strNewClassName)
}

ClassMethod DeleteClass(strClassName As %String) As %Status
{
   quit ##class(%Dictionary.ClassDefinition).%DeleteId(strClassName)
}

}
