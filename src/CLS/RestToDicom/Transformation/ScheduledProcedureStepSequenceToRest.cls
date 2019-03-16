Class RestToDicom.Transformation.ScheduledProcedureStepSequenceToRest Extends Ens.DataTransformDTL [ DependsOn = (EnsLib.DICOM.Document, RestToDicom.Object.ScheduledProcedureStepSequence) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='EnsLib.DICOM.Document' targetClass='RestToDicom.Object.ScheduledProcedureStepSequence' create='new' language='objectscript' >
<assign value='source.DataSet.GetValueAt("ScheduledProcedureStepSequence[1].Modality",0)' property='target.Modality' action='set' />
<assign value='source.DataSet.GetValueAt("ScheduledProcedureStepSequence[1].ScheduledStationAETitle",0)' property='target.ScheduledStationAETitle' action='set' />
<assign value='source.DataSet.GetValueAt("ScheduledProcedureStepSequence[1].ScheduledProcedureStepStartDate",0)' property='target.ScheduledProcedureStepStartDate' action='set' />
<assign value='source.DataSet.GetValueAt("ScheduledProcedureStepSequence[1].ScheduledProcedureStepStartTime",0)' property='target.ScheduledProcedureStepStartTime' action='set' />
<assign value='source.DataSet.GetValueAt("ScheduledProcedureStepSequence[1].ScheduledProcedureStepDescription",0)' property='target.ScheduledProcedureStepDescription' action='set' />
<assign value='source.DataSet.GetValueAt("ScheduledProcedureStepSequence[1].ScheduledProcedureStepID",0)' property='target.ScheduledProcedureStepID' action='set' />
</transform>
}

}
