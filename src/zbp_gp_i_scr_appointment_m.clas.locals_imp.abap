CLASS lhc_zgp_i_screening_appointmen DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZGP_I_SCREENING_APPOINTMENT_M~validateDate.
    METHODS validatePatient FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZGP_I_SCREENING_APPOINTMENT_M~validatePatient.
    METHODS validateTime FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZGP_I_SCREENING_APPOINTMENT_M~validateTime.
    METHODS validatePatientType FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZGP_I_SCREENING_APPOINTMENT_M~validatePatientType.
    METHODS auto_CreateAppointments FOR MODIFY
      IMPORTING keys FOR ACTION ZGP_I_SCREENING_APPOINTMENT_M~auto_CreateAppointments.

ENDCLASS.

CLASS lhc_zgp_i_screening_appointmen IMPLEMENTATION.

  METHOD validateDate.
    READ ENTITIES OF zgp_i_screening_m IN LOCAL MODE
        ENTITY zgp_i_screening_m
            FIELDS ( screeningid screening_start_date screening_end_date ) WITH CORRESPONDING #( keys )
        RESULT DATA(screenings).
    READ ENTITIES OF zgp_i_screening_m IN LOCAL MODE
        ENTITY zgp_i_screening_appointment_m
            FIELDS ( screeningid appointmentid appointment_date )  WITH CORRESPONDING #( keys )
        RESULT DATA(screening_appointments).

    LOOP AT screenings INTO DATA(screening).
            LOOP AT screening_appointments INTO DATA(screening_appointment) WHERE screeningid = screening-screeningid.
                APPEND VALUE #(  %tky        = screening_appointment-%tky
                                 %state_area = 'VALIDATE_DATES' )
                TO reported-zgp_i_screening_appointment_m.

                IF screening-screening_end_date < screening_appointment-appointment_date.
                    APPEND VALUE #( %tky = screening_appointment-%tky ) TO failed-zgp_i_screening_appointment_m.

                ELSEIF screening-screening_start_date > screening_appointment-appointment_date.
                    APPEND VALUE #( %tky = screening_appointment-%tky ) TO failed-zgp_i_screening_appointment_m.
                ENDIF.

            ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD validatePatient.
READ ENTITIES OF zgp_i_screening_m IN LOCAL MODE
        ENTITY zgp_i_screening_appointment_m
            FIELDS ( screeningid appointmentid patientid  ) WITH CORRESPONDING #( keys )
        RESULT DATA(appointments).
    DATA patients TYPE SORTED TABLE OF zgp_patient WITH UNIQUE KEY patientid.

    patients = CORRESPONDING #( appointments DISCARDING DUPLICATES MAPPING patientid = patientid EXCEPT * ).
    DELETE patients WHERE patientid IS INITIAL.
    IF patients IS NOT INITIAL.
      SELECT FROM zgp_patient FIELDS patientid
        FOR ALL ENTRIES IN @patients
        WHERE patientid = @patients-patientid
        INTO TABLE @DATA(patients_db).
    ENDIF.

    LOOP AT appointments INTO DATA(appointment).
      APPEND VALUE #(  %tky        = appointment-%tky
                       %state_area = 'VALIDATE_PATIENT' )
        TO reported-zgp_i_screening_appointment_m.

      IF appointment-patientid IS NOT INITIAL AND NOT line_exists( patients_db[ patientid = appointment-patientid ] ).
        APPEND VALUE #(  %tky = appointment-%tky ) TO failed-zgp_i_screening_appointment_m.

        APPEND VALUE #(  %tky        = appointment-%tky
                         %state_area = 'VALIDATE_PATIENT'
                         %element-patientid = if_abap_behv=>mk-on )
          TO reported-zgp_i_screening_appointment_m.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD validateTime.

  ENDMETHOD.

  METHOD validatePatientType.
  READ ENTITIES OF zgp_i_screening_m IN LOCAL MODE
        ENTITY zgp_i_screening_appointment_m
            FIELDS ( screeningid appointmentid patientid  ) WITH CORRESPONDING #( keys )
        RESULT DATA(appointments).
  READ ENTITIES OF zgp_i_screening_m IN LOCAL MODE
        ENTITY zgp_i_screening_m
            FIELDS ( screeningid screeningtypeid  ) WITH CORRESPONDING #( keys )
        RESULT DATA(screenings).
    DATA patients TYPE SORTED TABLE OF zgp_patient WITH UNIQUE KEY patientid.
    DATA scrtypes TYPE SORTED TABLE OF zgp_scrnng_type WITH UNIQUE KEY screening_type_id.

    patients = CORRESPONDING #( appointments DISCARDING DUPLICATES MAPPING patientid = patientid EXCEPT * ).
    DELETE patients WHERE patientid IS INITIAL.
    IF patients IS NOT INITIAL.
      SELECT FROM zgp_patient FIELDS gender
        FOR ALL ENTRIES IN @patients
        WHERE patientid = @patients-patientid
        INTO @DATA(patients_db).
        ENDSELECT.
    ENDIF.

    scrtypes = CORRESPONDING #( screenings DISCARDING DUPLICATES MAPPING screening_type_id = screeningtypeid EXCEPT * ).
    DELETE scrtypes WHERE screening_type_id IS INITIAL.
    IF scrtypes IS NOT INITIAL.
      SELECT FROM zgp_scrnng_type FIELDS target_gender
        FOR ALL ENTRIES IN @scrtypes
        WHERE screening_type_id = @scrtypes-screening_type_id
        INTO TABLE @DATA(scrtypes_db).
    ENDIF.

  LOOP AT appointments INTO DATA(appointment).
      APPEND VALUE #(  %tky        = appointment-%tky
                       %state_area = 'VALIDATE_PATIENT' )
        TO reported-zgp_i_screening_appointment_m.

        IF appointment-patientid IS NOT INITIAL AND NOT line_exists( scrtypes_db[ target_gender = 'B' ] ).
            IF NOT line_exists( scrtypes_db[ target_gender = patients_db ] ).
                APPEND VALUE #(  %tky = appointment-%tky ) TO failed-zgp_i_screening_appointment_m.

                APPEND VALUE #(  %tky        = appointment-%tky
                         %state_area = 'VALIDATE_PATIENT'
                         %element-patientid = if_abap_behv=>mk-on )
                TO reported-zgp_i_screening_appointment_m.
             ENDIF.
      ENDIF.
  ENDLOOP.




  ENDMETHOD.

  METHOD auto_CreateAppointments.

    READ ENTITIES OF zgp_i_screening_m IN LOCAL MODE
        ENTITY zgp_i_screening_m
            FIELDS ( screeningid screening_start_date screening_end_date ) WITH CORRESPONDING #( keys )
        RESULT DATA(screenings).

    LOOP AT screenings INTO DATA(screening).
    MODIFY ENTITIES OF zgp_i_screening_m IN LOCAL MODE
    ENTITY zgp_i_screening_m

        CREATE BY \_Appointment FROM VALUE #( (
        %target =  VALUE #(  ( screeningid = 1
        appointmentid = 1
        appointment_date = 20230427
        appointment_time = 202020

         ) ) ) )
        MAPPED mapped
        FAILED failed
        REPORTED reported.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
