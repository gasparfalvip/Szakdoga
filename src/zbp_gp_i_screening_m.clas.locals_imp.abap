CLASS lhc_ZGP_I_SCREENING_M DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validatedates
      FOR VALIDATE ON SAVE
      IMPORTING
        keys FOR zgp_i_screening_m~validatedates.

    METHODS validatescrtype
      FOR VALIDATE ON SAVE
      IMPORTING
        keys FOR zgp_i_screening_m~validatescrtype.

    METHODS validatelocation
      FOR VALIDATE ON SAVE
      IMPORTING
       keys FOR zgp_i_screening_m~validatelocation.

    METHODS validateinstitution
      FOR VALIDATE ON SAVE
      IMPORTING
        keys FOR zgp_i_screening_m~validateinstitution.

    METHODS earlynumbering_create
      FOR NUMBERING
      IMPORTING
        entities FOR CREATE zgp_i_screening_m.

    METHODS earlynumbering_create_a
      FOR NUMBERING
      IMPORTING
        entities FOR CREATE zgp_i_screening_m\_Appointment.

ENDCLASS.

CLASS lhc_ZGP_I_SCREENING_M IMPLEMENTATION.

*  METHOD get_instance_authorizations.
*
*   " Just for debugging
*
*    IF 1 = 1.
*    ENDIF.
* ENDMETHOD.

  METHOD validateDates.
    " This method is responsible to....

    READ ENTITIES OF zgp_i_screening_m IN LOCAL MODE
        ENTITY zgp_i_screening_m
            FIELDS ( screeningid screening_start_date screening_end_date ) WITH CORRESPONDING #( keys )
        RESULT DATA(screenings).

    " validate date per screening
    LOOP AT screenings INTO DATA(screening).

      " If screen end date is lower then start date
      " It is an error
      IF screening-screening_end_date < screening-screening_start_date.
        APPEND VALUE #( %tky = screening-%tky ) TO failed-zgp_i_screening_m.
        APPEND VALUE #( %tky               = screening-%tky
                        %state_area        = 'VALIDATE_DATES'
*                        %msg = new_message_with_text(
*                            severity = if_abap_behv_message=>severity-error
*                            text = 'End date must be after start date!')
                        %element-screening_start_date = if_abap_behv=>mk-on
                        %element-screening_end_date   = if_abap_behv=>mk-on ) TO reported-zgp_i_screening_m.
        CONTINUE.
      ENDIF.

      " If start date is lower then actual system date
      " It is not a valid input
      IF screening-screening_start_date < cl_abap_context_info=>get_system_date( ).
        APPEND VALUE #( %tky               = screening-%tky ) TO failed-zgp_i_screening_m.
        APPEND VALUE #( %tky               = screening-%tky
                        %state_area        = 'VALIDATE_DATES'
                        %element-screening_start_date = if_abap_behv=>mk-on ) TO reported-zgp_i_screening_m.
        CONTINUE.
      ENDIF.

      " If everything was okay -> add a success validation message?
      APPEND VALUE #(
            %tky        = screening-%tky
            %state_area = 'VALIDATE_DATES' )
      TO reported-zgp_i_screening_m.

    ENDLOOP.
  ENDMETHOD.

  METHOD validateScrType.
    READ ENTITIES OF zgp_i_screening_m IN LOCAL MODE
        ENTITY zgp_i_screening_m
            FIELDS ( screeningid screeningtypeid ) WITH CORRESPONDING #( keys )
        RESULT DATA(screenings).

    " Validate only screen types with already known screen types
    DATA scrtypes TYPE SORTED TABLE OF zgp_scrnng_type WITH UNIQUE KEY screening_type_id.
    scrtypes = CORRESPONDING #( screenings DISCARDING DUPLICATES MAPPING screening_type_id = screeningtypeid EXCEPT * ).
    DELETE scrtypes WHERE screening_type_id IS INITIAL.

    IF scrtypes IS NOT INITIAL.
      SELECT FROM zgp_scrnng_type FIELDS screening_type_id
        FOR ALL ENTRIES IN @scrtypes
        WHERE screening_type_id = @scrtypes-screening_type_id
        INTO TABLE @DATA(scrtypes_db).
    ENDIF.

    LOOP AT screenings INTO DATA(screening).
      APPEND VALUE #(  %tky        = screening-%tky
                       %state_area = 'VALIDATE_SCREENING_TYPE' )
        TO reported-zgp_i_screening_m.

      IF screening-screeningtypeid IS INITIAL OR NOT line_exists( scrtypes_db[ screening_type_id = screening-screeningtypeid ] ).
        APPEND VALUE #(  %tky = screening-%tky ) TO failed-zgp_i_screening_m.

        APPEND VALUE #(  %tky        = screening-%tky
                         %state_area = 'VALIDATE_SCREENING_TYPE'
                         %element-screeningtypeid = if_abap_behv=>mk-on )
          TO reported-zgp_i_screening_m.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD validateLocation.
    READ ENTITIES OF zgp_i_screening_m IN LOCAL MODE
        ENTITY zgp_i_screening_m
            FIELDS ( screeningid locationid ) WITH CORRESPONDING #( keys )
        RESULT DATA(screenings).
    DATA locations TYPE SORTED TABLE OF zgp_location WITH UNIQUE KEY locationid.

    locations = CORRESPONDING #( screenings DISCARDING DUPLICATES MAPPING locationid = locationid EXCEPT * ).
    DELETE locations WHERE locationid IS INITIAL.
    IF locations IS NOT INITIAL.
      SELECT FROM zgp_location FIELDS locationid
        FOR ALL ENTRIES IN @locations
        WHERE locationid = @locations-locationid
        INTO TABLE @DATA(locations_db).
    ENDIF.

    LOOP AT screenings INTO DATA(screening).
      APPEND VALUE #(  %tky        = screening-%tky
                       %state_area = 'VALIDATE_LOCATION' )
        TO reported-zgp_i_screening_m.

      IF screening-locationid IS INITIAL OR NOT line_exists( locations_db[ locationid = screening-locationid ] ).
        APPEND VALUE #(  %tky = screening-%tky ) TO failed-zgp_i_screening_m.

        APPEND VALUE #(  %tky        = screening-%tky
                         %state_area = 'VALIDATE_LOCATION'
                         %element-locationid = if_abap_behv=>mk-on )
          TO reported-zgp_i_screening_m.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateInstitution.
    READ ENTITIES OF zgp_i_screening_m IN LOCAL MODE
        ENTITY zgp_i_screening_m
            FIELDS ( screeningid institutionid ) WITH CORRESPONDING #( keys )
        RESULT DATA(screenings).
    DATA institutions TYPE SORTED TABLE OF zgp_institution WITH UNIQUE KEY institutionid.

    institutions = CORRESPONDING #( screenings DISCARDING DUPLICATES MAPPING institutionid = institutionid EXCEPT * ).
    DELETE institutions WHERE institutionid IS INITIAL.
    IF institutions IS NOT INITIAL.
      SELECT FROM zgp_institution FIELDS institutionid
        FOR ALL ENTRIES IN @institutions
        WHERE institutionid = @institutions-institutionid
        INTO TABLE @DATA(institutions_db).
    ENDIF.

    LOOP AT screenings INTO DATA(screening).
      APPEND VALUE #(  %tky        = screening-%tky
                       %state_area = 'VALIDATE_INSTITUTION' )
        TO reported-zgp_i_screening_m.

      IF screening-institutionid IS INITIAL OR NOT line_exists( institutions_db[ institutionid = screening-institutionid ] ).
        APPEND VALUE #(  %tky = screening-%tky ) TO failed-zgp_i_screening_m.

        APPEND VALUE #(  %tky        = screening-%tky
                         %state_area = 'VALIDATE_INSTITUTION'
                         %element-institutionid = if_abap_behv=>mk-on )
          TO reported-zgp_i_screening_m.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA screenings TYPE SORTED TABLE OF zgp_screening WITH UNIQUE KEY screeningid.
    DATA: max_id TYPE int1.
    IF screenings IS INITIAL.
      SELECT MAX( screeningid ) FROM zgp_screening INTO @max_id.
    ELSE.
      max_id = screenings[ lines( screenings ) ]-screeningid.
    ENDIF.

    max_id += 1.
    INSERT VALUE #( screeningid = max_id ) INTO TABLE screenings.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>).
      INSERT VALUE #( %cid            = <ls_entity>-%cid
                      screeningid  = max_id ) INTO TABLE mapped-zgp_i_screening_m.
    ENDLOOP.


  ENDMETHOD.


  METHOD earlynumbering_create_a.

    DATA screenings TYPE SORTED TABLE OF zgp_screening WITH UNIQUE KEY screeningid.
    DATA appointments TYPE SORTED TABLE OF zgp_scr_appntmnt WITH UNIQUE KEY appointmentid.
    DATA: max_id TYPE int1.


    INSERT VALUE #( appointmentid = max_id ) INTO TABLE appointments.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>).
      IF appointments IS INITIAL.
        SELECT MAX( appointmentid ) FROM zgp_scr_appntmnt WHERE screeningid = @<ls_entity>-screeningid INTO @max_id.
      ELSE.
        SELECT MAX( appointmentid ) FROM zgp_scr_appntmnt WHERE screeningid = @<ls_entity>-screeningid INTO @max_id.
      ENDIF.
      max_id += 1.

      LOOP AT <ls_entity>-%target ASSIGNING FIELD-SYMBOL(<ls_appointment_create>).
        INSERT VALUE #( %cid            = <ls_appointment_create>-%cid
                    screeningid = <ls_entity>-screeningid
                    appointmentid = max_id ) INTO TABLE mapped-zgp_i_screening_appointment_m.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
