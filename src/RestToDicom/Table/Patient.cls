Class RestToDicom.Table.Patient Extends (%Persistent, Form.Adaptor, %JSON.Adaptor)
{

Property PatientFullName As %String(DISPLAYNAME = "Name", MAXLEN = "");

Property PatientFirstName As %String(DISPLAYNAME = "FirstName", MAXLEN = "");

Property PatientLastName As %String(DISPLAYNAME = "LastName", MAXLEN = "");

Property PatientID As %String(DISPLAYNAME = "ID", MAXLEN = "");

Property PatientSize As %String(DISPLAYNAME = "Size", MAXLEN = "");

Property StudyInstanceID As %String(DISPLAYNAME = "Study ID", MAXLEN = "");

Index PatientIDIndex On PatientID [ IdKey ];

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientFullName</Value>
</Value>
<Value name="3">
<Value>PatientFirstName</Value>
</Value>
<Value name="4">
<Value>PatientLastName</Value>
</Value>
<Value name="5">
<Value>PatientID</Value>
</Value>
<Value name="6">
<Value>StudyInstanceID</Value>
</Value>
<Value name="7">
<Value>PatientSize</Value>
</Value>
</Data>
<DataLocation>^RestToDicom.Table.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<IdLocation>^RestToDicom.Table.PatientD</IdLocation>
<IndexLocation>^RestToDicom.Table.PatientI</IndexLocation>
<StreamLocation>^RestToDicom.Table.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
