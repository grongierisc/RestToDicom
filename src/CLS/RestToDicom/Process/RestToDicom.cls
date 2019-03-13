/// 
Class RestToDicom.Process.RestToDicom Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='RestToDicom.Message.DicomRequest' response='Ens.Response' height='2000' width='2000' >
<sequence xend='200' yend='350' >
<call name='CallDicomProcess' target='PROC_DICOM' async='0' xpos='200' ypos='250' >
<request type='RestToDicom.Message.DicomRequest' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='RestToDicom.Message.DicomResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
