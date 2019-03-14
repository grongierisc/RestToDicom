Class RestToDicom.Transformation.DicomDocumentToPatient Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.DICOM.Document, RestToDicom.Object.Patient) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.DICOM.Document' targetClass='RestToDicom.Object.Patient' create='new' language='objectscript' >
<assign value='source.DataSet.GetValueAt("PatientName",0)' property='target.PatientName' action='set' />
<assign value='source.DataSet.GetValueAt("PatientID",0)' property='target.PatientID' action='set' />
<assign value='source.DataSet.GetValueAt("StudyDate",0)' property='target.StudyDate' action='set' />
</transform>
}

}
