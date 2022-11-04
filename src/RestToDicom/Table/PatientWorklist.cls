Class RestToDicom.Table.PatientWorklist Extends (%Persistent, RestToDicom.Object.Patient, Form.Adaptor, %JSON.Adaptor) [ DdlAllowed ]
{

Parameter XMLTYPE = "PatientsTable";

/// Form name, not a global key so it can be anything
/// Set to empty string (like here) to not have a class as a form 
Parameter FORMNAME = "PatientWorklist";

/// Default permissions
/// Objects of this form can be Created, Read, Updated and Deleted
/// Redefine this parameter to change permissions for everyone
/// Redefine checkPermission method (see Form.Security) for this class
/// to add custom security based on user/roles/etc.
Parameter OBJPERMISSIONS As %String = "CRUD";

/// Property used for basic information about the object
/// By default getObjectDisplayName method gets its value from it
Parameter DISPLAYPROPERTY As %String = "PatientFullName";

/// Use value of this parameter in SQL, as ORDER BY clause value 
Parameter FORMORDERBY As %String = "TimeStamp";

Property ScheduledProcedureStepSequence As RestToDicom.Table.ScheduledProcedureStepSequence;

Property SessionId As %Integer(DISPLAYNAME = "SessionId");

Property TimeStamp As %TimeStamp(DISPLAYNAME = "Timestamp") [ InitialExpression = {$ZDATETIME($ZTIMESTAMP, 3, 1, 3)} ];

Index SessionIdIDX On SessionId;

Storage Default
{
<Data name="PatientWorklistDefaultData">
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
<Value>ScheduledProcedureStepSequence</Value>
</Value>
<Value name="8">
<Value>SessionId</Value>
</Value>
<Value name="9">
<Value>TimeStamp</Value>
</Value>
</Data>
<DataLocation>^RestToDicoACDA.PatientWorkADDBD</DataLocation>
<DefaultData>PatientWorklistDefaultData</DefaultData>
<IdLocation>^RestToDicoACDA.PatientWorkADDBD</IdLocation>
<IndexLocation>^RestToDicoACDA.PatientWorkADDBI</IndexLocation>
<StreamLocation>^RestToDicoACDA.PatientWorkADDBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
