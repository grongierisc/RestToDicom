Class RestToDicom.Object.ScheduledProcedureStepSequence Extends (%SerialObject, Form.Field) [ PropertyClass = Form.Field ]
{

Property Modality As %String(DISPLAYNAME = "Modality");

Property ScheduledStationAETitle As %String(DISPLAYNAME = "ScheduledStationAETitle");

Property ScheduledProcedureStepStartDate As %String(DISPLAYNAME = "ScheduledProcedureStepStartDate");

Property ScheduledProcedureStepStartTime As %String(DISPLAYNAME = "ScheduledProcedureStepStartTime");

Property ScheduledProcedureStepDescription As %String(DISPLAYNAME = "ScheduledProcedureStepDescription");

Property ScheduledProcedureStepID As %String(DISPLAYNAME = "ScheduledProcedureStepID");

Storage Default
{
<Data name="ScheduledProcedureStepSequenceState">
<Value name="1">
<Value>Modality</Value>
</Value>
<Value name="2">
<Value>ScheduledStationAETitle</Value>
</Value>
<Value name="3">
<Value>ScheduledProcedureStepStartDate</Value>
</Value>
<Value name="4">
<Value>ScheduledProcedureStepStartTime</Value>
</Value>
<Value name="5">
<Value>ScheduledProcedureStepDescription</Value>
</Value>
<Value name="6">
<Value>ScheduledProcedureStepID</Value>
</Value>
</Data>
<State>ScheduledProcedureStepSequenceState</State>
<StreamLocation>^RestToDico95BB.ScheduledPr49D8S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
