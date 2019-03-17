Class RestToDicom.Transformation.DicomDocumentToPatient Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.DICOM.Document, RestToDicom.Object.Patient) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.DICOM.Document' targetClass='RestToDicom.Object.Patient' create='existing' language='objectscript' >
<assign value='source.DataSet.GetValueAt("PatientName",0)' property='target.PatientFullName' action='set' />
<assign value='$P(source.DataSet.GetValueAt("PatientName",0),"^",1)' property='target.PatientFirstName' action='set' />
<assign value='$P(source.DataSet.GetValueAt("PatientName",0),"^",2)' property='target.PatientLastName' action='set' />
<assign value='source.DataSet.GetValueAt("PatientName",0)' property='target.PatientFullName' action='set' />
<assign value='source.DataSet.GetValueAt("PatientID",0)' property='target.PatientID' action='set' />
<assign value='source.DataSet.GetValueAt("RequestedProcedureID",0)' property='target.StudyInstanceID' action='set' />
<subtransform class='RestToDicom.Transformation.ScheduledProcedureStepSequenceToRest' targetObj='target.ScheduledProcedureStepSequence.(1)' sourceObj='source' />
</transform>
}

}
