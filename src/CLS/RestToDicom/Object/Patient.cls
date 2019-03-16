Class RestToDicom.Object.Patient Extends (%Persistent, Form.Adaptor, %XML.Adaptor)
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
Parameter DISPLAYPROPERTY As %String = "PatientFullName";

/// Use value of this parameter in SQL, as ORDER BY clause value 
Parameter FORMORDERBY As %String = "TimeStamp";

Property PatientFullName As %String(DISPLAYNAME = "Name");

Property PatientFirstName As %String(DISPLAYNAME = "FirstName");

Property PatientLastName As %String(DISPLAYNAME = "LastName");

Property PatientID As %String(DISPLAYNAME = "ID");

Property PatientSize As %String(DISPLAYNAME = "Size");

Property StudyInstanceID As %String(DISPLAYNAME = "Study ID", MAXLEN = "");

Property ScheduledProcedureStepSequence As list Of RestToDicom.Object.ScheduledProcedureStepSequence(DISPLAYNAME = "Procedure");

Property TimeStamp As %Library.PosixTime(DISPLAYNAME = "Date Query") [ InitialExpression = {##class(%Library.PosixTime).CurrentTimeStamp()} ];

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientName</Value>
</Value>
<Value name="3">
<Value>PatientID</Value>
</Value>
<Value name="4">
<Value>StudyDate</Value>
</Value>
<Value name="5">
<Value>PatientSize</Value>
</Value>
<Value name="6">
<Value>StudyInstanceID</Value>
</Value>
<Value name="7">
<Value>TimeStamp</Value>
</Value>
<Value name="8">
<Value>ScheduledProcedureStepSequence</Value>
</Value>
<Value name="9">
<Value>PatientFullName</Value>
</Value>
<Value name="10">
<Value>PatientFirstName</Value>
</Value>
<Value name="11">
<Value>PatientLastName</Value>
</Value>
</Data>
<DataLocation>^RestToDicom.Object.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<IdLocation>^RestToDicom.Object.PatientD</IdLocation>
<IndexLocation>^RestToDicom.Object.PatientI</IndexLocation>
<StreamLocation>^RestToDicom.Object.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
