@EndUserText.label: 'Screening Type Data'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZGP_I_SCREENING_TYPE_M as select from zgp_scrnng_type
{
    key screening_type_id,
    name,
    target_age_group_from,
    target_age_group_to,
    target_gender,
    optimal_frequency
}
