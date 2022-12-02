from grongier.pex import BusinessProcess, Utils

import iris

from msg import FhirRequest

from fhir.resources.patient import Patient
from fhir.resources.observation import Observation

from fhir.resources.humanname import HumanName
from fhir.resources.reference import Reference
from fhir.resources.codeableconcept import CodeableConcept
from fhir.resources.coding import Coding
from fhir.resources.quantity import Quantity


class DicomToFhir(BusinessProcess):

    def create_patient_from_worklist(self, request:'iris.RestToDicom.Message.SetDicomToBddRequest'):

        t_patient = iris.ref(None)

        Utils.raise_on_error(iris.cls('RestToDicom.Transformation.DicomDocumentToPatient').Transform(request.Document, t_patient))

        t_patient = t_patient.value

        # create a FHIR Patient resource
        patient = Patient()

        self.log_info("Patient ID: " + t_patient.PatientID)

        # set the patient id
        patient.id = str(t_patient.PatientID).strip()

        # set the patient's name
        patient.name = [HumanName()]
        patient.name[0].given = [t_patient.PatientFirstName]
        patient.name[0].family = t_patient.PatientLastName

        # create an observation resource for the patient's size
        observation = Observation(status="final",code=CodeableConcept())
        observation.code = CodeableConcept()
        observation.code.coding = [Coding()]
        observation.code.coding[0].system = "http://loinc.org"
        observation.code.coding[0].code = "8302-2"
        observation.code.coding[0].display = "Body height"
        observation.valueQuantity = Quantity()
        observation.valueQuantity.value = t_patient.PatientSize
        observation.valueQuantity.unit = "cm"
        observation.valueQuantity.system = "http://unitsofmeasure.org"
        observation.valueQuantity.code = "cm"
        observation.subject = Reference()
        observation.subject.reference = f"Patient/{patient.id}"

        # create a FhirRequest
        fhir_request = FhirRequest()
        fhir_request.resource = patient

        self.send_request_sync("FHIR_CLIENT", fhir_request)

        fhir_request.resource = observation

        self.send_request_sync("FHIR_CLIENT", fhir_request)

    def send_to_fhir(self,request:FhirRequest):
        self.send_request_sync("FHIR_CLIENT", request)


if __name__ == '__main__':
    bp = DicomToFhir()
    request = iris.cls('RestToDicom.Message.SetDicomToBddRequest')._OpenId(698)
    bp.create_patient_from_worklist(request)
    print("Done")