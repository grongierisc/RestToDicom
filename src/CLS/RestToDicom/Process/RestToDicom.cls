/// 
Class RestToDicom.Process.RestToDicom Extends Ens.BusinessProcessBPL
{


/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='RestToDicom.Message.DicomRequest' response='RestToDicom.Message.PatientsResponse' height='2000' width='2000' >
<context>
<property name='DicomDocuments' type='EnsLib.DICOM.Document' collection='list' instantiate='0' />
<property name='key' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='Patient' type='RestToDicom.Object.Patient' instantiate='0' />
<property name='tPatients' type='RestToDicom.Object.Patient' collection='list' instantiate='0' />
</context>
<sequence xend='200' yend='800' >
<if name='FIND ?' condition='request.RequestType="CFINDRQ"' xpos='200' ypos='250' xend='200' yend='600' >
<true>
<call name='CallDicomProcessFind' target='PROC_DICOM' async='0' xpos='470' ypos='400' >
<request type='RestToDicom.Message.DicomRequest' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='RestToDicom.Message.DicomResponse' >
<assign property="context.DicomDocuments" value="callresponse.Documents" action="set" />
</response>
</call>
<foreach name='PourChaqueDocument' property='context.DicomDocuments' key='context.key' xpos='470' ypos='500' xend='200' yend='550' >
<transform name='DicomToObject' class='RestToDicom.Transformation.DicomDocumentToPatient' source='context.DicomDocuments.GetAt(context.key)' target='context.Patient' xpos='200' ypos='250' />
<assign name="Set Response" property="context.tPatients" value="context.Patient" action="insert" key="context.key" xpos='200' ypos='350' disabled="true"/>
<code name='Set Response' xpos='200' ypos='450' >
<![CDATA[ do response.Patients.SetAt(##class(RestToDicom.Object.Patient).%New(),context.key)
 set response.Patients.GetAt(context.key).PatientID = context.Patient.PatientID 
 set response.Patients.GetAt(context.key).PatientFullName = context.Patient.PatientFullName 
 set response.Patients.GetAt(context.key).PatientFirstName = context.Patient.PatientFirstName 
 set response.Patients.GetAt(context.key).PatientLastName = context.Patient.PatientLastName 
 set response.Patients.GetAt(context.key).StudyInstanceID = context.Patient.StudyInstanceID
 set response.Patients.GetAt(context.key).ScheduledProcedureStepSequence = context.Patient.ScheduledProcedureStepSequence 
     ]]>
</code>
</foreach>
</true>
<false>
<call name='CallDicomProcessEcho' target='PROC_DICOM' async='0' xpos='200' ypos='400' >
<request type='RestToDicom.Message.DicomRequest' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='RestToDicom.Message.DicomResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
<code name='Set EchoResponse' xpos='200' ypos='500' >
<![CDATA[ 
                   set response = ##class(RestToDicom.Message.EchoResponse).%New() 
                   set response.Status = "OK"
                  ]]>
</code>
</false>
</if>
<assign name="SessionId" property="response.SessionId" value="..%Process.%SessionId" action="set" xpos='200' ypos='700' />
</sequence>
</process>
}

}
