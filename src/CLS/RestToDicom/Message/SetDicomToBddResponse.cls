Class RestToDicom.Message.SetDicomToBddResponse Extends Ens.Response
{

Property Patient As RestToDicom.Object.Patient;

Storage Default
{
<Data name="SetDicomToBddResponseDefaultData">
<Subscript>"SetDicomToBddResponse"</Subscript>
<Value name="1">
<Value>Patient</Value>
</Value>
</Data>
<DefaultData>SetDicomToBddResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
