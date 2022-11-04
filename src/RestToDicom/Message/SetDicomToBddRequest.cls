Class RestToDicom.Message.SetDicomToBddRequest Extends Ens.Request
{

Property SessionId As %Integer;

Property Document As EnsLib.DICOM.Document(XMLPROJECTION = "NONE");

Method %OnNew(pSessionId As %Integer = 0, pDoc As EnsLib.DICOM.Document = "") As %Status [ Private, ServerOnly = 1 ]
{

        Set ..SessionId = pSessionId

        Set ..Document = pDoc

        Quit $$$OK
}

/// From 'Ens.Util.MessageBodyMethods'
Method %ShowContents(pZenOutput As %Boolean = 0)
{
                Do ..Document.CommandSet.OutputHtmlToDevice()
                Write "</P>"
                Do ..Document.DataSet.OutputHtmlToDevice()
}

Storage Default
{
<Data name="SetDicomToBddRequestDefaultData">
<Subscript>"SetDicomToBddRequest"</Subscript>
<Value name="1">
<Value>SessionId</Value>
</Value>
<Value name="2">
<Value>Document</Value>
</Value>
</Data>
<DefaultData>SetDicomToBddRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
