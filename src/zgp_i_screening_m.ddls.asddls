@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data model for Screenings'

define root view entity ZGP_I_SCREENING_M
  as select from zgp_screening
  composition [0..*] of ZGP_I_SCREENING_APPOINTMENT_M as _Appointment
  /*Assiciations*/
  association [0..1] to ZGP_I_LOCATION_M              as _Location       on $projection.locationid = _Location.Locationid
  association [1..1] to ZGP_I_SCREENING_TYPE_M        as _Screening_Type on $projection.screeningtypeid = _Screening_Type.screening_type_id
  association [1..1] to ZGP_I_INSTITUTION_M           as _Institution    on $projection.institutionid = _Institution.Institutionid
{
  key screeningid,
      screeningtypeid,
      institutionid,
      locationid,

      screening_start_date,
      screening_end_date,

      _Screening_Type,
      _Institution,
      _Location,
      _Appointment


}
