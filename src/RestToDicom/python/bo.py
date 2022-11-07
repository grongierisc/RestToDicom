from grongier.pex import BusinessOperation,Utils

import iris

from grongier.pex import BusinessOperation

from msg import FhirRequest

from fhirpy import SyncFHIRClient
from fhir.resources import construct_fhir_element

import json

class FhirClient(BusinessOperation):
    client: SyncFHIRClient = None

    def on_init(self):
        """
        It changes the current url if needed using the params of the
        management portal
        :return: None
        """
        if not hasattr(self,'url'):
            self.url = 'http://localhost:52773/fhir/r4'

        self.client = SyncFHIRClient(url=self.url,extra_headers={"Content-Type":"application/json+fhir"})

        # Using an InterSystems server that need an api key, using the header x-api-key
        #self.client = SyncFHIRClient(url='https://fhir.8ty581k3dgzj.static-test-account.isccloud.io', extra_headers={"x-api-key":"sVgCTspDTM4iHGn51K5JsaXAwJNmHkSG3ehxindk"})

        return None


    def on_fhir_request(self, request:FhirRequest):
        """
        > When a FHIR request is received, create a FHIR resource from the request,
        and save it to the FHIR server. It can be any resource from the FHIR R4
        specification in a dict format.
        
        :param request: The FHIR request object
        :type request: FhirRequest
        :return: None
        """
        # Get the resource type from the request ( here "Organization" )
        resource_type = request.resource["resource_type"]

        # Create a resource of this type using the request's data
        resource = construct_fhir_element(resource_type, request.resource)

        # Save the resource to the FHIR server using the client
        self.client.resource(resource_type,**json.loads(resource.json())).save()

        return iris.cls('Ens.Response')._New()

    def on_message(self, message:'iris.HS.Message.FHIR.Request'):
        """
        > When a message is received, it calls the method on_message of the
        parent class (BusinessOperation) to handle the message.
        :param message: The message received
        :type message: iris.Message
        :return: None
        """
        response = iris.cls('HS.Message.FHIR.Response')._New()
        response.Status = "200"

        json_payload = json.loads(message.Payload.Read())
        try:
            self.client.resource(message.Type,**json_payload).save()
        except Exception as e:
            response.Status = "500"
        
        return response



class RestToDicomBO(BusinessOperation):

    def save_in_bdd(self, request:'iris.RestToDicom.Message.SetDicomToBddRequest'):

        response = iris.cls('RestToDicom.Message.SetDicomToBddResponse')._New()

        t_patient = iris.ref(None)

        Utils.raise_on_error(iris.cls('RestToDicom.Transformation.DicomDocumentToPatient').Transform(request.Document, t_patient))

        t_scheduled_procedure_step = iris.ref(None)

        Utils.raise_on_error(iris.cls('RestToDicom.Transformation.ScheduledProcedureStepSequenceToRest').Transform(request.Document, t_scheduled_procedure_step))

        # here out is RestToDicom.Object.Patient
        t_patient = t_patient.value
        t_scheduled_procedure_step = t_scheduled_procedure_step.value

        # Upsert in Patient Table
        if iris.cls('RestToDicom.Table.Patient')._ExistsId(t_patient.PatientID): 
            orm = iris.cls('RestToDicom.Table.Patient')._OpenId(t_patient.PatientID)
        else:
            orm = iris.cls('RestToDicom.Table.Patient')._New()

        orm.PatientID = t_patient.PatientID
        orm.PatientFullName = t_patient.PatientFullName
        orm.PatientFirstName = t_patient.PatientFirstName
        orm.PatientLastName  = t_patient.PatientLastName
        orm.StudyInstanceID = 	t_patient.StudyInstanceID
        orm.PatientSize = t_patient.PatientSize

        orm._Save()

        # Insert in PatientWorklist Table
        t_patient_worklist = iris.cls('RestToDicom.Table.PatientWorklist')._New()
        t_patient_worklist.PatientID = t_patient.PatientID
        t_patient_worklist.PatientFullName = t_patient.PatientFullName
        t_patient_worklist.PatientFirstName = t_patient.PatientFirstName
        t_patient_worklist.PatientLastName  = t_patient.PatientLastName
        t_patient_worklist.StudyInstanceID = 	t_patient.StudyInstanceID
        t_patient_worklist.PatientSize = t_patient.PatientSize
        t_scheduled_procedure_step_table = iris.cls('RestToDicom.Table.ScheduledProcedureStepSequence')._New()
        t_scheduled_procedure_step_table.Modality = t_scheduled_procedure_step.Modality
        t_scheduled_procedure_step_table.ScheduledProcedureStepDescription = t_scheduled_procedure_step.ScheduledProcedureStepDescription
        t_scheduled_procedure_step_table.ScheduledProcedureStepID = t_scheduled_procedure_step.ScheduledProcedureStepID
        t_scheduled_procedure_step_table.ScheduledProcedureStepStartDate = t_scheduled_procedure_step.ScheduledProcedureStepStartDate
        t_scheduled_procedure_step_table.ScheduledProcedureStepStartTime = t_scheduled_procedure_step.ScheduledProcedureStepStartTime
        t_scheduled_procedure_step_table.ScheduledStationAETitle = t_scheduled_procedure_step.ScheduledStationAETitle
        t_scheduled_procedure_step_table._Save()
        t_patient_worklist.ScheduledProcedureStepSequence = t_scheduled_procedure_step_table

        t_patient_worklist.SessionId = request.SessionId

        t_patient_worklist._Save()

        response.Patient = t_patient

        return response
