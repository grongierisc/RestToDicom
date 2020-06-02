/// Classe de persitence des objects dicom dans la base de données IRIS
Class RestToDicom.Operation.DicomBDD Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method OnTask() As %Status [ Internal ]
{
		try {
			If '..%WarnedLatest&&'..%ClassIsLatestVersion() {
				$$$ThrowOnError(##class(Ens.Director).EnableConfigItem(..%ConfigName,0,0))
				$$$ThrowOnError(##class(Ens.Director).EnableConfigItem(..%ConfigName,1,0))
			}
			If $IsObject(..Adapter)&&'..Adapter.%WarnedLatest&&'..Adapter.%ClassIsLatestVersion() {
				$$$ThrowOnError(##class(Ens.Director).EnableConfigItem(..%ConfigName,0,0))
				$$$ThrowOnError(##class(Ens.Director).EnableConfigItem(..%ConfigName,1,0))
			}
			$$$ThrowOnError(##super())
		}
		catch exp
		{
			Set tStatus = exp.AsStatus()
			
		}

		
		Quit $$$OK
}

// Methode de persitence des Objects Dicom vers la table RestToDicom.Table.Patient

Method SetDicomToBdd(pRequest As RestToDicom.Message.SetDicomToBddRequest, Output pResponse As RestToDicom.Message.SetDicomToBddResponse) As %Status
{
	set tStatus = $$$OK
	
	Set pResponse = ##class(RestToDicom.Message.SetDicomToBddResponse).%New()

	try{

		Set out = ##class(RestToDicom.Table.Patient).%New()

		$$$LOGINFO("titi")

        $$$ThrowOnError(##class(RestToDicom.Transformation.DicomDocumentToPatient).Transform(pRequest.Document,.out))


		Set out.SessionId = pRequest.SessionId
		
		Set pResponse.Patient = out

        $$$ThrowOnError(out.%Save())
					
	}
	catch exp
	{
		Set tStatus = exp.AsStatus()
		
	}
	
	Quit tStatus
}

/// initialize Business Host object
Method %OnNew(pConfigName As %String, adapterOverride As Ens.Adapter = {$$$NULLOREF}) As %Status
{
	   do ##super(pConfigName)
	   
	   // Used for unit testing injection only.
	   set:($IsObject(adapterOverride)) ..Adapter = adapterOverride
	   
	   quit $$$OK
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
