Class RestToDicom.Message.DicomResponse Extends Ens.Response
{

Property Documents As list Of EnsLib.DICOM.Document(XMLPROJECTION = "NONE");

Storage Default
{
<Data name="DicomResponseDefaultData">
<Subscript>"DicomResponse"</Subscript>
<Value name="1">
<Value>Patients</Value>
</Value>
<Value name="2">
<Value>Documents</Value>
</Value>
</Data>
<DefaultData>DicomResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
