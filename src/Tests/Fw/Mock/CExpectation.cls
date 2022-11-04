Class Tests.Fw.Mock.CExpectation Extends %RegisteredObject
{

Property instance As %RegisteredObject [ Private ];

Property strMethodName As %String [ Private ];

Property lstParameters As %ListOfDataTypes [ Private ];

Property nTimes As %Integer [ InitialExpression = 1, Private ];

/// No As since it can be a DataType or an object which have no common base.
Property returnValue [ Private ];

Method %OnNew(instance As %RegisteredObject, strMethodName As %String, lstParameters As %ListOfDataTypes) As %Status [ Internal ]
{
   set ..instance = instance
   set ..strMethodName = strMethodName
   set ..lstParameters = lstParameters
   
   quit $$$OK
}

/// Sets the number of time to expect this method in a row. Returns $THIS to enable chaining.
/// Usage example: do ..expect(mock.call(param1, param2, param3)).andReturn("return").times(1)
/// See also: Tests.Fw.Mock.CMockManager
Method Times(nTimes As %Integer) As Tests.Fw.Mock.CExpectation
{
   set ..nTimes = nTimes
   
   quit $THIS
}

/// Specifies the return value of this expectation. Returns $THIS to enable chaining.
/// Usage example: do ..expect(mock.call(param1, param2, param3)).andReturn("return").times(1)
/// See also: Tests.Fw.Mock.CMockManager
Method AndReturn(returnValue) As Tests.Fw.Mock.CExpectation
{
   set ..returnValue = returnValue
   quit $THIS
}

Method GetInstance() As %RegisteredObject [ Internal ]
{
   quit ..instance
}

Method GetMethodName() As %String [ Internal ]
{
   quit ..strMethodName
}

Method GetLstParameters() As %ListOfDataTypes [ Internal ]
{
   quit ..lstParameters
}

Method GetTimes() As %Integer [ Internal ]
{
   quit ..nTimes
}

Method DecrementTimes() [ Internal ]
{
   set ..nTimes = ..nTimes - 1
}

/// Since the return type is unknown we cant't specify %RegisteredObject or %DataType as the return value.
Method GetReturnValue() [ Internal ]
{
   quit ..returnValue
}

}
