Class Tests.Unit.DicomBDD Extends Tests.Fw.CUnitTestBase
{

Property Operation As RestToDicom.Operation.DicomBDD;

Property DicomDocument As EnsLib.DICOM.Document;

Method OnBeforeAllTests() As %Status
{

    Set filePath = "/Users/grongier/git/RestToDicom/src/CLS/Tests/Data/DicomTest.dcm"

    Set stream=##class(%FileBinaryStream).%New()
    Set stream.Filename=filePath

    Do ##class(EnsLib.DICOM.Document).CreateFromDicomFileStream(stream,.tDicomDocument)

    Set ..DicomDocument = tDicomDocument

    Set ..Operation = ##class(RestToDicom.Operation.DicomBDD).%New("UnitTest")
      
  Quit $$$OK
}

/// Testing SetDicomToBdd
Method TestSetDicomToBdd()
{

    Set pRequest = ##class(RestToDicom.Message.SetDicomToBddRequest).%New(0,..DicomDocument)

    Do $$$AssertStatusOK(..Operation.SetDicomToBdd(pRequest, .pResponse), $$$OK)
    
    zw pResponse.Patient
	Do $$$AssertEquals(pResponse.Patient.PatientFirstName,"ALOHA")
    Do $$$AssertEquals(pResponse.Patient.PatientFullName,"ALOHA^JANE^^^ ")
    Do $$$AssertEquals(pResponse.Patient.PatientID,"122 ")
    Do $$$AssertEquals(pResponse.Patient.PatientLastName,"JANE")
    Do $$$AssertEquals(pResponse.Patient.SessionId,0)
}

}
