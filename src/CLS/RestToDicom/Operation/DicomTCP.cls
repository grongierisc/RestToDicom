Class RestToDicom.Operation.DicomTCP Extends EnsLib.DICOM.Operation.TCP
{

Method OnInit() As %Status
{
    Do ##super()

    do ..CreateAssociationLite(..Adapter.LocalAET,..Adapter.RemoteAET,$ListBuild($$$IMPLICITVRLETRANSFERSYNTAX,$$$RAWDATAEXPLICITVRLTLENDIAN,$$$DEFLATEDEXPLICITVRLTLENDIAN,$$$RAWDATAEXPLICITVRBIGENDIAN,$$$PAPYRUSIMPLICITVRLTLENDIAN))
    
    Quit $$$OK
}

ClassMethod CreateAssociationLite(pCallingAET As %String, pCalledAET As %String, pTransferSyntaxes As %List = {$ListBuild($$$IMPLICITVRLETRANSFERSYNTAX)}) As %Status
{
        #dim tSC As %Status = $$$OK
        #dim tAC As EnsLib.DICOM.Util.AssociationContext
        #dim tPC As EnsLib.DICOM.Util.PresentationContext
        #dim tUID,tData As %String
        #dim tI As %Integer
        
        Do  {
          
          #; Delete the pre-existing instance
          If ##class(EnsLib.DICOM.Util.AssociationContext).AETExists(pCallingAET,pCalledAET) {
            Set tSC=##class(EnsLib.DICOM.Util.AssociationContext).AETDelete(pCallingAET,pCalledAET) If $$$ISERR(tSC) Quit
          }
      
           #; Create a new association context
          Kill %objlasterror Set tAC=##class(EnsLib.DICOM.Util.AssociationContext).%New(pCallingAET,pCalledAET)
           If '$IsObject(tAC) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.Util.AssociationContext")) Quit
      
          #; For every SOP in the dictionary
          Set tUID="" For {
            
            Set tUID=$Order(^EnsDICOM.Dictionary("as","u",tUID),1,tData) If tUID="" Quit
            
            #; Only want those SOP classes for GET,FIND,STORAGE and MOVE
            If ((tData["FIND")||(tData["Verification")) {
              
              Kill %objlasterror Set tPC=##class(EnsLib.DICOM.Util.PresentationContext).%New(tUID)
               If '$IsObject(tPC) Set tSC=$Get(%objlasterror,$$$EnsError($$$FailedToNewClass,"EnsLib.DICOM.Util.PresentationContext")) Quit
             
               For tI=1:1:$ListLength(pTransferSyntaxes) {
                 Set tSC=tPC.TransferSyntaxes.Insert($List(pTransferSyntaxes,tI)) If $$$ISERR(tSC) Quit
               }
             
               Set tSC=tAC.PresentationContexts.Insert(tPC) If $$$ISERR(tSC) Quit
            }
          }
      
          Set tSC=tAC.%Save() If $$$ISERR(tSC) Quit
       
        } while (0)
        
        Quit tSC
}

}
