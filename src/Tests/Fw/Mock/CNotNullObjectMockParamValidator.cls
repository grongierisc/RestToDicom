Class Tests.Fw.Mock.CNotNullObjectMockParamValidator Extends (%RegisteredObject, Tests.Fw.Mock.IMockParamValidator)
{

Property strExpectedClassName As %String;

Method %OnNew(strExpectedClassName As %String) As %Status [ Internal ]
{
   set ..strExpectedClassName = strExpectedClassName
   
   quit $$$OK
}

Method Validate(object) As %Status [ Internal ]
{
   #dim status As %Status = $$$ERROR("Wrong class or null")
   if ($data(object) && (object '= $$$NULLOREF) && $IsObject(object) && object.%IsA(..strExpectedClassName))
   {
      set status = $$$OK
   }
   
   quit status
}

Method GetAssertDescription(nIndex As %Integer, strMethodName As %String) As %String [ Internal ]
{
   quit "Expected Parameter(" _ nIndex _ ") not null  for method: " _ strMethodName _ " Got either a null, not an object or a wrong object"
}

}
