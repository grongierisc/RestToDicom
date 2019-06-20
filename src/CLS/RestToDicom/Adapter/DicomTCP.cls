Class RestToDicom.Adapter.DicomTCP Extends EnsLib.DICOM.Adapter.TCP
{

/// This method sends the specified document to the connected peer
Method SendDocument(pDocument As EnsLib.DICOM.Document) As %Status
{
        #dim tSC,tSCUPS,tSCTemp As %Status = $$$OK
        
        #dim tContextId,tSyntaxId,tDataSetType As %Integer
        #dim tStream As %Stream.TmpBinary
        #dim tShouldQuit As %Boolean
        #dim tAffectedSOPClassUID,tMsgType,tAbstractSyntax,tTransferSyntax,tResponseMsgId,tUPSSOPClassUID,tStatusCodes As %String
        
        try {
            
            #; If the adapter is not in the correct state then issue an error message
            If ..State'="State6" Set tSC=$$$EnsError($$$EnsDICOMNoActiveAssociation,..LocalAET,..RemoteAET) Quit
            
            #; Get the command field
            Set tMsgType=$$$MsgTyp2Str(pDocument.GetValueAt("CommandSet.(0000,0100)",,.tSC))
            If $$$ISERR(tSC) Quit
            
            #; Need special processing for C-CANCEL-RQ
            If tMsgType="C-CANCEL-RQ" {
                
                #; C-CANCEL-RQ may have a context try to find it
                Set tTransferSyntax=$$$IMPLICITVRLETRANSFERSYNTAX,tContextId=0
                
                #; Get the AbstractSyntax from the command set (this is the AffectedSOPClassUID)
                Set tAffectedSOPClassUID=pDocument.GetValueAt("CommandSet.(0000,0002)",,.tSC)
                If $$$ISERR(tSC) {
                    #; Not found, try the RequestedSOPClassUID
                    Set tSC=$$$OK Set tAffectedSOPClassUID=pDocument.GetValueAt("CommandSet.(0000,0003)",,.tSC)
                }

                Set tSC=..FindContextForOutboundTransfer(tAffectedSOPClassUID,tTransferSyntax,.tContextId) 
                If $$$ISERR(tSC) {
                    set tContextId=0
                }

                #; C-CANCEL-RQ has no AffectedSOPClassUID
                //Set tSC=pDocument.SetValueAt(tAffectedSOPClassUID,"CommandSet.(0000,0002)","clear")
                If $$$ISERR(tSC) Quit
                Set tSC=pDocument.SetValueAt(tAffectedSOPClassUID,"CommandSet.(0000,0003)","clear")
                If $$$ISERR(tSC) Quit

            } else {
            
                #; Get the AbstractSyntax from the command set (this is the AffectedSOPClassUID)
                Set tAffectedSOPClassUID=pDocument.GetValueAt("CommandSet.(0000,0002)",,.tSC)
                If $$$ISERR(tSC) {
                    #; Not found, try the RequestedSOPClassUID
                    Set tSC=$$$OK Set tAffectedSOPClassUID=pDocument.GetValueAt("CommandSet.(0000,0003)",,.tSC)
                    If $$$ISERR(tSC) Quit
                }
               
                If tAffectedSOPClassUID="" Set tSC=$$$EnsError($$$EnsDICOMUnrecognizedAbstractSyntax,"(null)") Quit
                
                #; Get the transfer syntax which this document is encoded in
                Set tTransferSyntax=pDocument.DataSet.TransferSyntax
                
                #; Find the context which matches this SOP UID, if we haven't got a match there is no sense trying to send this
                Set tSC=..FindContextForOutboundTransfer(tAffectedSOPClassUID,tTransferSyntax,.tContextId) 
                If $$$ISERR(tSC) {
                    /*
                        For DIMSE-N Services, the Affected SOP Class UID (0000,0002) or
                        Requested SOP Class UID (0000,0003), when present, will be the UID
                        of the UPS Push SOP Class regardless of the negotiated Abstract Syntax UID.
                        The SCU and SCP will not reject DIMSE-N messages on the basis of the 
                        Affected/Requested SOP Class UID being that of the UPS Push SOP Class, 
                        rather than one of the other three SOP Class UIDs as listed in the Abstract 
                        Syntax UID during association negotiation.
                    */
                    #; Quit since error and not DIMSE-N nor UPS Push SOP Class
                    If ($E(tMsgType)'="N") || (tAffectedSOPClassUID'=$$$UPSPUSHSOPCLASS) {
                        $$$LOGERROR($System.Status.GetErrorText(tSC))
                        Quit
                    } Elseif ($System.Status.Equals(tSC,$$$EnsDICOMAbstractSyntaxNotRequested)) {
                        Do ..TraceMessage($$$Verbose,$$$FormatText($$$Text("Abstract Syntax '%1' not requested between peers '%2' and '%3'.  Trying other UPS SOP UIDs"),$$$AS2EYE($$$UPSPUSHSOPCLASS),..LocalAET,..RemoteAET))
                    } Elseif ($System.Status.Equals(tSC,$$$EnsDICOMAbstractSyntaxNotAccepted)) {
                        Do ..TraceMessage($$$Verbose,$$$FormatText($$$Text("Abstract Syntax '%1' rejected between between peers '%2' and '%3'.  Trying other UPS SOP UIDs"),$$$AS2EYE($$$UPSPUSHSOPCLASS),..LocalAET,..RemoteAET))
                    } Elseif ($System.Status.Equals(tSC,$$$EnsDICOMNoCompatibleTransferSyntaxFound)) {
                        Do ..TraceMessage($$$Verbose,$$$FormatText($$$Text("No negotiated transfer syntax for SOP class '%1' is compatible with document transfer syntax '%2'.  Trying other UPS SOP UIDs"),$$$AS2EYE($$$UPSPUSHSOPCLASS),tTransferSyntax))
                    } Else {
                        Do ..TraceMessage($$$Verbose,$$$FormatText($$$Text("Trying other UPS SOP UIDs after an error was encountered in trying to find context for Abstract Syntax '%1' :  "),$$$AS2EYE($$$UPSPUSHSOPCLASS))_$System.Status.GetErrorText(tSC))
                    }
    
                    #; Look to find context for one of the other 3 UPS SOP UIDs
                    For tUPSSOPClassUID = $$$UPSWATCHSOPCLASS,$$$UPSPULLSOPCLASS,$$$UPSEVENTSOPCLASS {
                        Set tSCTemp=..FindContextForOutboundTransfer(tUPSSOPClassUID,tTransferSyntax,.tContextId)
                        If $$$ISOK(tSCTemp) Quit
                        Set tSCUPS = $System.Status.AppendStatus(tSCUPS,tSCTemp)
                    }
                    
                    #; If still didn't find adjust error message
                    If $$$ISERR(tSCTemp) {
                        Set tSCUPS = $System.Status.AppendStatus(tSCUPS,tSC)
                        Set tStatusCodes = ","_$System.Status.GetErrorCodes(tSCUPS)_","
                        If tStatusCodes [ ",<EnsDICOM>NoCompatibleTransferSyntaxFound," {
                            Set tSC = $$$EnsError($$$EnsDICOMUPSNoCompatibleTransferSyntaxFound,tTransferSyntax)
                        } Elseif tStatusCodes [ ",<EnsDICOM>AbstractSyntaxNotAccepted," {
                            Set tSC = $$$EnsError($$$EnsDICOMUPSAbstractSyntaxesNotAccepted,..LocalAET,..RemoteAET)
                        } Elseif tStatusCodes [ ",<EnsDICOM>AbstractSyntaxNotRequested," {
                            Set tSC = $$$EnsError($$$EnsDICOMUPSAbstractSyntaxesNotRequested,..LocalAET,..RemoteAET)
                        } Else {
                            // leave original error code
                            $$$LOGERROR($System.Status.GetErrorText(tSC))
                        }
                        Quit
                    }
                }
                            
                #; Attempt to get the value, will throw if value does not exist (this is the MessageIDBeingRespondedTo)
                Set tResponseMsgId=pDocument.GetValueAt("CommandSet.(0000,0120)",,.tSC)
                
                #; Don't check status, value may be missing
                
                #; Check to see if there is a response id, if not then it means this is a request, not a response
                If (tResponseMsgId="") {
            
                    #; This is a request message, first check to see if the user has set a message id
                    Set tMsgId=pDocument.GetValueAt("CommandSet.(0000,0110)",,.tSC)
                    
                    #; Don't check status, value may not be present. 
                    
                    #; If the user has set a message id then update the internal counter
                    If tMsgId'="" {
                        
                        #; The counter will be updated to the correct value by GetNextMessageId() below 
                        Set ..MessageId=tMsgId-2
                    }
                    
                    #; Get a new message id and update the command set ( this is the MessageID )
                    Set tSC=pDocument.SetValueAt(..GetNextMessageId(),"CommandSet.(0000,0110)") If $$$ISERR(tSC) Quit
                }
    
                #; Get the association details
                Set tSC=..GetAssociationDetail($$$OUTBOUND,tContextId,.tAbstractSyntax,.tTransferSyntax)
                If $$$ISERR(tSC) Quit
            }
            
            Do ..TraceMessage($$$Terse,$$$Text("Sending  MSG type ")_tMsgType)
            
            #; Ask the document to send itself
            Set tSC=pDocument.SendWireStream(##this,tContextId,tTransferSyntax) If $$$ISERR(tSC) Quit
            
        } catch {
            Set tSC=$$$EnsSystemError
        }
        
        #; If an error has occurred notify the business host
        If $$$ISERR(tSC) Set tSC=..BusinessHost.OnAdapterErrored(tSC)
        
        Quit tSC
}

}
