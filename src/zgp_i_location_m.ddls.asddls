@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data model for Location'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGP_I_LOCATION_M as select from zgp_location
{
    key locationid as Locationid,
    location_name as LocationName,
    location_post_code as LocationPostCode,
    location_city as LocationCity,
    location_address as LocationAddress,
    location_house_number as LocationHouseNumber
}
