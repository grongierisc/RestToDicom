Class RestToDicom.Object.ScheduledProcedureStepSequence Extends (%Persistent, Form.Adaptor, %XML.Adaptor)
{

/// Form name, not a global key so it can be anything
/// Set to empty string (like here) to not have a class as a form 
Parameter FORMNAME = "Patient";

/// Default permissions
/// Objects of this form can be Created, Read, Updated and Deleted
/// Redefine this parameter to change permissions for everyone
/// Redefine checkPermission method (see Form.Security) for this class
/// to add custom security based on user/roles/etc.
Parameter OBJPERMISSIONS As %String = "CRUD";

/// Property used for basic information about the object
/// By default getObjectDisplayName method gets its value from it
Parameter DISPLAYPROPERTY As %String = "Modality";

/// Use value of this parameter in SQL, as ORDER BY clause value 
Parameter FORMORDERBY As %String = "ScheduledProcedureStepID";

Property Modality As %String(DISPLAYNAME = "Modality");

Property ScheduledStationAETitle As %String(DISPLAYNAME = "ScheduledStationAETitle");

Property ScheduledProcedureStepStartDate As %String(DISPLAYNAME = "ScheduledProcedureStepStartDate");

Property ScheduledProcedureStepStartTime As %String(DISPLAYNAME = "ScheduledProcedureStepStartTime");

Property ScheduledProcedureStepDescription As %String(DISPLAYNAME = "ScheduledProcedureStepDescription");

Property ScheduledProcedureStepID As %String(DISPLAYNAME = "ScheduledProcedureStepID");

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
<DataLocation>^RestToDico95BB.ScheduledPr49D8D</DataLocation>
<DefaultData>ScheduledProcedureStepSequenceDefaultData</DefaultData>
<IdLocation>^RestToDico95BB.ScheduledPr49D8D</IdLocation>
<IndexLocation>^RestToDico95BB.ScheduledPr49D8I</IndexLocation>
<StreamLocation>^RestToDico95BB.ScheduledPr49D8S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
