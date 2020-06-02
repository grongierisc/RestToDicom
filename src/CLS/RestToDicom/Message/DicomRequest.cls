Class RestToDicom.Message.DicomRequest Extends Ens.Request
{

Property RequestType As %String;

Property PatientID As %String;

Storage Default
{
<Data name="DicomRequestDefaultData">
<Subscript>"DicomRequest"</Subscript>
<Value name="1">
<Value>RequestType</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
</Data>
<DefaultData>DicomRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
