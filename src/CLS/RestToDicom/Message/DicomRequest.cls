Class RestToDicom.Message.DicomRequest Extends Ens.Request
{

Property RequestType As %String;

Storage Default
{
<Data name="DicomRequestDefaultData">
<Subscript>"DicomRequest"</Subscript>
<Value name="1">
<Value>RequestType</Value>
</Value>
</Data>
<DefaultData>DicomRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
