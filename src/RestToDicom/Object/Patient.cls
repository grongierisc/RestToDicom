/// Object principale du projet
/// Classe mere de RestToDicom.Table.Patient 
Class RestToDicom.Object.Patient Extends (%SerialObject, %XML.Adaptor, Form.Field) [ PropertyClass = Form.Field ]
{

Property PatientFullName As %String(DISPLAYNAME = "Name", MAXLEN = "");

Property PatientFirstName As %String(DISPLAYNAME = "FirstName", MAXLEN = "");

Property PatientLastName As %String(DISPLAYNAME = "LastName", MAXLEN = "");

Property PatientID As %String(DISPLAYNAME = "ID", MAXLEN = "");

Property StudyInstanceID As %String(DISPLAYNAME = "Study ID", MAXLEN = "");

Property PatientSize As %String(DISPLAYNAME = "Size", MAXLEN = "");

Property ScheduledProcedureStepSequence As RestToDicom.Object.ScheduledProcedureStepSequence(DISPLAYNAME = "Procedure");

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
<Value>StudyInstanceID</Value>
</Value>
<Value name="6">
<Value>ScheduledProcedureStepSequence</Value>
</Value>
<Value name="7">
<Value>PatientSize</Value>
</Value>
</Data>
<State>PatientState</State>
<StreamLocation>^RestToDicom.Object.PatientS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
