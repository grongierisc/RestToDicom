Class RestToDicom.Object.Patient Extends (%SerialObject, %XML.Adaptor)
{

Property PatientName As %String;

Property PatientID As %String;

Property StudyDate As %String;

Property StudyInstanceID As %String(MAXLEN = "");

Storage Default
{
<Data name="PatientState">
<Value name="1">
<Value>PatientName</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>StudyDate</Value>
</Value>
<Value name="4">
<Value>StudyInstanceID</Value>
</Value>
</Data>
<State>PatientState</State>
<StreamLocation>^RestToDicom.Object.PatientS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
