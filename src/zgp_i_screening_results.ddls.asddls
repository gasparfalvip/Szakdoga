@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data model for Results'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGP_I_SCREENING_RESULTS
  as select from zgp_scr_results
  association        to parent ZGP_I_PATIENT_M as _Patient       on _Patient.Patientid = $projection.Patientid
  association [1..1] to ZGP_I_SCREENING_TYPE_M as _ScreeningType on _ScreeningType.screening_type_id = $projection.ScreeningtypeId
{
  key patientid        as Patientid,
  key resultid         as Resultid,
      screeningtype_id as ScreeningtypeId,
      scr_date         as ScrDate,
      scr_result       as ScrResult,

      _Patient,
      _ScreeningType
}
