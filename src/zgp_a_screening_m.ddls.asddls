@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'API for screening'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZGP_A_SCREENING_M
  as projection on ZGP_I_SCREENING_M
  //  association [0..1] to ZGP_I_LOCATION_VH as _Location_VH on $projection.locationid = _Location_VH.Locationid
{

  key screeningid,
      screeningtypeid,
      institutionid,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZGP_I_LOCATION_VH', element: 'Locationid'}}]
      locationid,
      screening_start_date,
      screening_end_date
      /* Associations */
      //      _Appointment : redirected to composition child ZGP_C_SCR_APPOINTMENT,
      //      _Institution,
      //      _Location,
      //      _Screening_Type,
      //      _Location_VH
}
