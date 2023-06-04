@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for Screening types'


@UI: {
 headerInfo: { typeName: 'Screening Type', typeNamePlural: 'Screening Types', title: { type: #STANDARD, value: 'screening_type_id' } } }

define root view entity ZGP_C_SCREENING_TYPE_M as projection on ZGP_I_SCREENING_TYPE_M
{


    @UI.facet: [ { id:              'zgp_scrnng_type',
                     purpose:         #STANDARD,
                     type:            #IDENTIFICATION_REFERENCE,
                     label:           'Screening Types',
                     position:        10 } ]

    @UI.hidden: true
    @UI: {
          lineItem:       [ { position: 10, importance: #HIGH  } ],
          identification: [ { position: 10, label: 'Sreening type id' } ]}
    key screening_type_id,
    @UI: {
          lineItem:       [ { position: 20, importance: #HIGH } ],
          identification: [ { position: 20, label: 'Name' } ] }
      @Search.defaultSearchElement: true
    name as Name,
    @UI: {
          lineItem:       [ { position: 30, importance: #HIGH  } ],
          identification: [ { position: 30, label: 'Age From' } ],
          selectionField: [{ position : 10}]}
      @Search.defaultSearchElement: true
    target_age_group_from as AgeGroupFrom,
    @UI: {
          lineItem:       [ { position: 40, importance: #HIGH  } ],
          identification: [ { position: 40, label: 'Age To' } ]}
    target_age_group_to,
    @UI: {
          lineItem:       [ { position: 50, importance: #HIGH  } ],
          identification: [ { position: 50, label: 'Target Gender' } ]}
    target_gender,
    @UI: {
          lineItem:       [ { position: 50, importance: #HIGH  } ],
          identification: [ { position: 50, label: 'Optimal Frequency' } ]}
    optimal_frequency
}
