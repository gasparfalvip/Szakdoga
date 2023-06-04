@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data model for Patient'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZGP_I_PATIENT_M
  as select from zgp_patient
  composition [0..*] of ZGP_I_SCREENING_RESULTS as _Result
{
  key patientid as Patientid,
      name      as Name,
      age       as Age,
      gender    as Gender,

      _Result

}
