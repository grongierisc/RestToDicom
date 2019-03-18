Class Tests.Fw.Mock.CCustomFunctionParamValidator Extends (%RegisteredObject, Tests.Fw.Mock.IMockParamValidator)
{

Property objectReference As %RegisteredObject;

Property strFunctionName As %String;

Method %OnNew(objectReference As %RegisteredObject, strFunctionName As %String) As %Status [ Internal ]
{
   set ..objectReference = objectReference
   set ..strFunctionName = strFunctionName

   quit $$$OK
}

Method Validate(object) As %Status [ Internal ]
{
   #dim status As %Status = $$$ERROR("Function or object not defined")
   
   if ($IsObject(..objectReference) && (..strFunctionName '= ""))
   {
      try
      {
         do $Method(..objectReference, ..strFunctionName, object)
         set status = $$$OK
      }
      catch
      {
         set status = $ZERROR
      }
   }
   
   quit status
}

Method GetAssertDescription(nIndex As %Integer, strMethodName As %String) As %String [ Internal ]
{
   quit "Unable to invoke method """ _ ..strFunctionName _ "()"" on object " _ ..objectReference _
        " to validate parameter(" _ nIndex _ ") for method: " _ strMethodName
}

}
