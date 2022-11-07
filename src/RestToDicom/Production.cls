Include EnsDICOM

Class RestToDicom.Production Extends Ens.Production
{

Parameter SETTINGS = "ShutdownTimeout,UpdateTimeout,StorageLocation";

/// This is the storage location for the DICOM streams to be stored
Property StorageLocation As %String;

/// Override this in your Production class to do setup before the Production starts
ClassMethod OnStart(pTimeStarted As %String) As %Status
{
	#; Make sure that the association exists
	If '##class(EnsLib.DICOM.Util.AssociationContext).AETExists("ENS-SCU","ENS-SCP")
	{
		do ..CreateAssociationLite("ENS-SCU","ENS-SCP",$ListBuild($$$IMPLICITVRLETRANSFERSYNTAX))
  } 

	If '##class(EnsLib.DICOM.Util.AssociationContext).AETExists("ENS-SCP","ENS-SCU")
	{
		do ##class(EnsLib.DICOM.Util.AssociationContext).CreateAssociation("ENS-SCP","ENS-SCU",$ListBuild($$$IMPLICITVRLETRANSFERSYNTAX))
	}
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

XData ProductionDefinition
{
<Production Name="RestToDicom.Production" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Setting Target="Production" Name="ShutdownTimeout">120</Setting>
  <Setting Target="Production" Name="UpdateTimeout">10</Setting>
  <Setting Target="Production" Name="StorageLocation"></Setting>
  <Item Name="BOUCHON_TCP_WORKLIST" Category="" ClassName="EnsLib.DICOM.Service.TCP" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="DuplexTargetConfigName">BOUCHON_BP_WORKLIST</Setting>
    <Setting Target="Adapter" Name="LocalAET">ENS-SCP</Setting>
    <Setting Target="Adapter" Name="RemoteAET">ENS-SCU</Setting>
    <Setting Target="Adapter" Name="TraceVerbosity">2</Setting>
    <Setting Target="Adapter" Name="JobPerConnection">0</Setting>
    <Setting Target="Adapter" Name="IPPort">1112</Setting>
    <Setting Target="Adapter" Name="CallInterval">1</Setting>
  </Item>
  <Item Name="BOUCHON_BP_WORKLIST" Category="" ClassName="RestToDicom.Process.WorkList" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="NumberOfWorkListEntries">10</Setting>
  </Item>
  <Item Name="DICOM_TO_TCP" Category="" ClassName="RestToDicom.Operation.DicomTCP" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="DuplexTargetConfigName">PROC_DICOM</Setting>
    <Setting Target="Adapter" Name="LocalAET">ENS-SCU</Setting>
    <Setting Target="Adapter" Name="RemoteAET">ENS-SCP</Setting>
    <Setting Target="Adapter" Name="TraceVerbosity">2</Setting>
    <Setting Target="Adapter" Name="JobPerConnection">0</Setting>
    <Setting Target="Adapter" Name="IPPort">1112</Setting>
    <Setting Target="Adapter" Name="IPAddress">localhost</Setting>
  </Item>
  <Item Name="DICOM_TO_BDD" Category="" ClassName="Python.DicomBDD" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="%classpaths">/irisdev/app/src/RestToDicom/python</Setting>
  </Item>
  <Item Name="PROC_DICOM" Category="" ClassName="RestToDicom.Process.Dicom" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="InactivityTimeout">0</Setting>
    <Setting Target="Host" Name="OperationDuplexName">DICOM_TO_TCP</Setting>
    <Setting Target="Host" Name="OperationBDD">DICOM_TO_BDD</Setting>
  </Item>
  <Item Name="PROC_RESTTODICOM" Category="" ClassName="RestToDicom.Process.RestToDicom" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="WS_REST" Category="" ClassName="RestToDicom.Service.RestToDicom" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="DICOM_TO_FHIR" Category="" ClassName="Python.DicomToFhir" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="FHIR_CLIENT" Category="" ClassName="Python.FhirClient" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HL7_TO_SDA" Category="" ClassName="RestToDicom.Process.HL7toSDA" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">SDA_TO_FHIR</Setting>
  </Item>
  <Item Name="SDA_TO_FHIR" Category="" ClassName="HS.FHIR.DTL.Util.HC.SDA3.FHIR.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">FHIR_CLIENT</Setting>
    <Setting Target="Host" Name="FHIRMetadataSet">HL7v40 / FHIR R4 Core Specification</Setting>
    <Setting Target="Host" Name="TransmissionMode">individual</Setting>
  </Item>
  <Item Name="HL7_FILE" Category="" ClassName="EnsLib.HL7.Service.FileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="MessageSchemaCategory">2.5.1</Setting>
    <Setting Target="Host" Name="TargetConfigNames">HL7_TO_SDA</Setting>
    <Setting Target="Adapter" Name="FilePath">/irisdev/app/misc/hl7/in/</Setting>
    <Setting Target="Adapter" Name="ArchivePath">/irisdev/app/misc/hl7/archive/</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.hl7</Setting>
  </Item>
</Production>
}

}
