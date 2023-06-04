@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gender domain Value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZGP_I_GENDER_DVH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T(p_domain_name: 'ZGP_PATIENT_GENDER')
{
  key domain_name,
  key value_position,
      @Semantics.language: true
  key language,
      @UI.textArrangement: #TEXT_ONLY
      value_low,

      @Semantics.text: true
      text
}
