Class Tests.Fw.Mock.CMockByRefParam Extends %RegisteredObject
{

/// No As ... on these properties so they can be a dataType or an object (which have no common base).
Property expectedValue;

Property replaceByValue;

Method %OnNew(expectedValue, replaceByValue) As %Status [ Internal ]
{
   set ..expectedValue = expectedValue
   set ..replaceByValue = replaceByValue
   quit $$$OK
}

}
