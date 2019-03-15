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
Parameter DISPLAYPROPERTY As %String = "PatientName";

/// Use value of this parameter in SQL, as ORDER BY clause value 
Parameter FORMORDERBY As %String = "StudyDate";

Property PatientName As %String;

Property PatientID As %String;

Property StudyDate As %String;

Property StudyInstanceID As %String(MAXLEN = "");

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
<Value>StudyInstanceID</Value>
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
