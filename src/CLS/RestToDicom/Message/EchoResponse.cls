Class RestToDicom.Message.EchoResponse Extends Ens.Response
{

Property SessionId As %Integer;

Property Status As %String;

Storage Default
{
<Data name="PatientsResponseDefaultData">
<Subscript>"PatientsResponse"</Subscript>
<Value name="1">
<Value>SessionId</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
</Data>
<DefaultData>PatientsResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
