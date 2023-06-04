@EndUserText.label: 'Projection view for Screening results'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { typeName: 'Screening Result', typeNamePlural: 'Screening Results', title: { type: #STANDARD, value: '_ScreeningType.name' } } }

define view entity ZGP_C_RESULTS
  as projection on ZGP_I_SCREENING_RESULTS
{

      @UI.facet: [ { id:              'zgp_scr_results',
                         purpose:         #STANDARD,
                         type:            #IDENTIFICATION_REFERENCE,
                         label:           'Result',
                         position:        10 }
                         ]

      @UI: {
              lineItem:       [ { position: 10, importance: #HIGH  } ],
              identification: [ { position: 10, label: 'Patient id' } ]}
  key Patientid,
      @UI: {
              lineItem:       [ { position: 20, importance: #HIGH  } ],
              identification: [ { position: 20, label: 'Result id' } ]}
  key Resultid,
      @UI: {
          lineItem:       [ { position: 30, importance: #HIGH  } ],
          identification: [ { position: 30, label: 'Screeningtype id' } ]}
      ScreeningtypeId,
      @UI: {
          lineItem:       [ { position: 40, importance: #HIGH  } ],
          identification: [ { position: 40, label: '' } ]}
      ScrDate,
      @UI: {
          lineItem:       [ { position: 50, importance: #HIGH  } ],
          identification: [ { position: 50, label: 'Result of Screening' } ]}
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZGP_I_RESULT_DVH', element: 'value_low' } }]
      ScrResult,
      /* Associations */
      _Patient : redirected to parent ZGP_C_PATIENT,
      _ScreeningType
}
