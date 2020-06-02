Class RestToDicom.Table.ScheduledProcedureStepSequence Extends (%Persistent, %JSON.Adaptor, RestToDicom.Object.ScheduledProcedureStepSequence)
{

Parameter XMLTYPE = "ScheduledProcedureStepSequenceTable";

Storage Default
{
<Data name="ScheduledProcedureStepSequenceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Modality</Value>
</Value>
<Value name="3">
<Value>ScheduledStationAETitle</Value>
</Value>
<Value name="4">
<Value>ScheduledProcedureStepStartDate</Value>
</Value>
<Value name="5">
<Value>ScheduledProcedureStepStartTime</Value>
</Value>
<Value name="6">
<Value>ScheduledProcedureStepDescription</Value>
</Value>
<Value name="7">
<Value>ScheduledProcedureStepID</Value>
</Value>
</Data>
<DataLocation>^RestToDicoACDA.ScheduledPr49D8D</DataLocation>
<DefaultData>ScheduledProcedureStepSequenceDefaultData</DefaultData>
<IdLocation>^RestToDicoACDA.ScheduledPr49D8D</IdLocation>
<IndexLocation>^RestToDicoACDA.ScheduledPr49D8I</IndexLocation>
<StreamLocation>^RestToDicoACDA.ScheduledPr49D8S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
