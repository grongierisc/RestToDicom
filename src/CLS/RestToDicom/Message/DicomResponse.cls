Class RestToDicom.Message.DicomResponse Extends Ens.Response
{

Property Patients As list Of RestToDicom.Object.Patient;

Storage Default
{
<Data name="DicomResponseDefaultData">
<Subscript>"DicomResponse"</Subscript>
<Value name="1">
<Value>Patients</Value>
</Value>
</Data>
<DefaultData>DicomResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
