from grongier.pex import BusinessOperation,Utils

import iris

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
