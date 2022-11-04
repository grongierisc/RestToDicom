Class RestToDicom.Service.RestToDicom Extends Ens.BusinessService
{

Parameter TARGET = "PROC_RESTTODICOM";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	set status = $$$OK
	try {
		set request = pInput
		
		if ($CLASSNAME(request)="RestToDicom.Message.DicomRequest") {
							
			$$$ThrowOnError(..SendRequestSync(..#TARGET, request, .pOutput))
				
		}
		
		} catch ex {
		set status = ex.AsStatus()
	}
	Quit status
}

}
