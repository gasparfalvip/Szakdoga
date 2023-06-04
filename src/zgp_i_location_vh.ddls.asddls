@EndUserText.label: 'Value help for locations'
@Search.searchable: true
define view entity ZGP_I_LOCATION_VH
  as select from zgp_location
{
  key locationid            as Locationid,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      location_name         as LocationName,
      location_post_code    as LocationPostCode,
      location_city         as LocationCity,
      location_address      as LocationAddress,
      location_house_number as LocationHouseNumber
}
