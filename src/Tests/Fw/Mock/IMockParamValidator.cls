/// Base interface for mock parameter validator. These are used when a simple "=" is not enough or connot be used
/// to validate a parameter value.
Class Tests.Fw.Mock.IMockParamValidator [ Abstract ]
{

/// Validates that the parameter is as expected.
Method Validate(objectOrDataType) As %Status [ Abstract ]
{
}

/// Returns the assert description.
Method GetAssertDescription(nIndex As %Integer, strMethodName As %String) As %String [ Abstract ]
{
}

}
