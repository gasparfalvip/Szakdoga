@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data model for Screening Appointments'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGP_I_SCREENING_APPOINTMENT_M
  as select from zgp_scr_appntmnt
  association [0..1] to zgp_patient              as _Patient   on $projection.patientid = _Patient.patientid
  association        to parent ZGP_I_SCREENING_M as _Screening on _Screening.screeningid = $projection.screeningid


{
  key screeningid,
  key appointmentid,
      patientid,
      appointment_date,
      appointment_time,

      _Screening,
      _Patient
}
