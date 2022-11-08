select * from AA.Patient P
join RestToDicom_Table.PatientWorklist PW on P.ID = 'Patient/'+PW.PatientID
join RestToDicom_Table.ScheduledProcedureStepSequence S on PW.ScheduledProcedureStepSequence = S.ID