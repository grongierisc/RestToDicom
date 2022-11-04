Class RestToDicom.Message.PatientsResponse Extends Ens.Response
{

Property SessionId As %Integer;

Property Patients As list Of RestToDicom.Object.Patient;

Storage Default
{
<Data name="PatientsResponseDefaultData">
<Subscript>"PatientsResponse"</Subscript>
<Value name="1">
<Value>Documents</Value>
</Value>
<Value name="2">
<Value>Patients</Value>
</Value>
<Value name="3">
<Value>SessionId</Value>
</Value>
</Data>
<DefaultData>PatientsResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
