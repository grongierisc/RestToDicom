Class RestToDicom.Operation.DicomBDD Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

// Set storage max pour ce processus

Method SetDicomToBdd(pRequest As RestToDicom.Message.SetDicomToBddRequest, Output pResponse As Ens.Response) As %Status
{
	set tStatus = $$$OK
	
	try{

        Set out = ##class(RestToDicom.Table.Patient).%New()

        $$$ThrowOnError(##class(RestToDicom.Transformation.DicomDocumentToPatient).Transform(pRequest.Document,.out))

        Set out.SessionId = pRequest.SessionId

        $$$ThrowOnError(out.%Save())
					
	}
	catch exp
	{
		Set tStatus = exp.AsStatus()
		
	}
	
	Quit tStatus
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="RestToDicom.Message.SetDicomToBddRequest"> 
		<Method>SetDicomToBdd</Method>
	</MapItem>
</MapItems>
}

}
