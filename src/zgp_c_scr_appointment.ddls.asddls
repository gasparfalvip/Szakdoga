@EndUserText.label: 'Projection view for Appointments'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { typeName: 'Appointment', typeNamePlural: 'Appointments', title: { type: #STANDARD, value: 'appointmentid' } } }

define view entity ZGP_C_SCR_APPOINTMENT
  as projection on ZGP_I_SCREENING_APPOINTMENT_M
{

      @UI.facet: [ { id:              'zgp_scr_appntmnt',
                       purpose:         #STANDARD,
                       type:            #IDENTIFICATION_REFERENCE,
                       label:           'Appointment',
                       position:        10 }
                       ]


      @UI: {
            lineItem:       [ { position: 10, importance: #HIGH  } ,
            {type: #FOR_ACTION, dataAction: 'auto_CreateAppointments', label: 'Auto create'}],
            identification: [ { position: 10, label: 'Sreening id' } ]}
  key screeningid,
      @UI: {
            lineItem:       [ { position: 20, importance: #HIGH  } ],
            identification: [ { position: 20, label: 'Appointment id' } ]}
  key appointmentid,
      @UI: {
            lineItem:       [ { position: 30, importance: #HIGH  } ],
            identification: [ { position: 30, label: 'Patient id' } ]}
      patientid,
      @UI: {
            lineItem:       [ { position: 40, importance: #HIGH  } ],
            identification: [ { position: 40, label: 'Appointment date' } ]}
      appointment_date,
      @UI: {
            lineItem:       [ { position: 50, importance: #HIGH  } ],
            identification: [ { position: 50, label: 'Appointment time' } ]}
      appointment_time,
      /* Associations */
      _Patient,
      _Screening : redirected to parent ZGP_C_SCREENING_M
}
