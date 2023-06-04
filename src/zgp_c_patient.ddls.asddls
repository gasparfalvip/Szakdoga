@EndUserText.label: 'Projection view for Patient'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { typeName: 'Patient', typeNamePlural: 'Patients', title: { type: #STANDARD, value: 'Name' } } }

define root view entity ZGP_C_PATIENT
  as projection on ZGP_I_PATIENT_M
{
      @UI.facet: [ { id:              'zgp_patients',
                         purpose:         #STANDARD,
                         type:            #IDENTIFICATION_REFERENCE,
                         label:           'Patient',
                         position:        10 },

                     {id: 'Result',
                       purpose: #STANDARD,
                       type: #LINEITEM_REFERENCE,
                       label: 'Screening Results',
                       targetElement: '_Result',
                       position: 20
                       }
                       ]
      @UI: {
                  lineItem:       [ { position: 10, importance: #HIGH  } ],
                  identification: [ { position: 10, label: 'PatientID' } ]}
  key Patientid,
      @UI: {
                lineItem:       [ { position: 20, importance: #HIGH  } ],
                identification: [ { position: 20, label: 'Name' } ]}
      Name,
      @UI: {
            lineItem:       [ { position: 30, importance: #HIGH  } ],
            identification: [ { position: 30, label: 'Age' } ]}
      Age,
      @UI: {
            lineItem:       [ { position: 40, importance: #HIGH  } ],
            identification: [ { position: 40, label: 'Gender' } ]}
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZGP_I_GENDER_DVH', element: 'value_low' } }]
      Gender,
      /* Associations */
      _Result : redirected to composition child ZGP_C_RESULTS
}
