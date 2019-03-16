Class RestToDicom.Object.Patient Extends (%SerialObject, Form.Field) [ PropertyClass = Form.Field ]
{

Property PatientFullName As %String(DISPLAYNAME = "Name");

Property PatientFirstName As %String(DISPLAYNAME = "FirstName");

Property PatientLastName As %String(DISPLAYNAME = "LastName");

Property PatientID As %String(DISPLAYNAME = "ID");

Property PatientSize As %String(DISPLAYNAME = "Size");

Property StudyInstanceID As %String(DISPLAYNAME = "Study ID", MAXLEN = "");

Property ScheduledProcedureStepSequence As list Of RestToDicom.Object.ScheduledProcedureStepSequence(DISPLAYNAME = "Procedure");

Storage Default
{
<Data name="PatientState">
<Value name="1">
<Value>PatientFullName</Value>
</Value>
<Value name="2">
<Value>PatientFirstName</Value>
</Value>
<Value name="3">
<Value>PatientLastName</Value>
</Value>
<Value name="4">
<Value>PatientID</Value>
</Value>
<Value name="5">
<Value>PatientSize</Value>
</Value>
<Value name="6">
<Value>StudyInstanceID</Value>
</Value>
<Value name="7">
<Value>ScheduledProcedureStepSequence</Value>
</Value>
<Value name="8">
<Value>TimeStamp</Value>
</Value>
</Data>
<State>PatientState</State>
<StreamLocation>^RestToDicom.Object.PatientS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
