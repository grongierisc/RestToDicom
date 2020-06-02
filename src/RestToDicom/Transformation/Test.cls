Class RestToDicom.Transformation.Test Extends Ens.DataTransformDTL [ DependsOn = RestToDicom.Message.DicomRequest ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='RestToDicom.Message.DicomRequest' targetClass='RestToDicom.Message.DicomRequest' create='new' language='objectscript' >
<assign value='source.RequestType' property='target.RequestType' action='set' />
</transform>
}

}
