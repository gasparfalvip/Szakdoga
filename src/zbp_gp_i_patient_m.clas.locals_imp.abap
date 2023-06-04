CLASS lhc_zgp_i_screening_results DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateScrType FOR VALIDATE ON SAVE
      IMPORTING keys FOR zgp_i_screening_results~validateScrType.

ENDCLASS.

CLASS lhc_zgp_i_screening_results IMPLEMENTATION.

  METHOD validateScrType.

    READ ENTITIES OF zgp_i_patient_m IN LOCAL MODE
        ENTITY zgp_i_screening_results
            FIELDS ( Patientid Resultid ScreeningtypeId ) WITH CORRESPONDING #( keys )
        RESULT DATA(results).

    READ ENTITIES OF zgp_i_patient_m IN LOCAL MODE
        ENTITY zgp_i_patient_m
            FIELDS ( Patientid Gender ) WITH CORRESPONDING #( keys )
        RESULT DATA(patients).

    DATA scrtypes TYPE SORTED TABLE OF zgp_scrnng_type WITH UNIQUE KEY screening_type_id.

    scrtypes = CORRESPONDING #( results DISCARDING DUPLICATES MAPPING screening_type_id = ScreeningtypeId EXCEPT * ).
    DELETE scrtypes WHERE screening_type_id IS INITIAL.
    IF scrtypes IS NOT INITIAL.
      SELECT FROM zgp_scrnng_type FIELDS target_gender
        FOR ALL ENTRIES IN @scrtypes
        WHERE screening_type_id = @scrtypes-screening_type_id
        INTO TABLE @DATA(scrtypes_db).
    ENDIF.

    LOOP AT patients INTO DATA(patient).
      LOOP AT results INTO DATA(result) WHERE Resultid = patient-Patientid.

        APPEND VALUE #(  %tky        = result-%tky
                       %state_area = 'VALIDATE_RESULT' )
        TO reported-zgp_i_screening_results.

        IF result-ScreeningtypeId IS NOT INITIAL AND NOT line_exists( scrtypes_db[ target_gender = 'B' ] ).
          IF NOT line_exists( scrtypes_db[ target_gender = patient-Gender ] ).
            APPEND VALUE #(  %tky = result-%tky ) TO failed-zgp_i_screening_results.

            APPEND VALUE #(  %tky        = result-%tky
                     %state_area = 'VALIDATE_RESULT'
                     %element-patientid = if_abap_behv=>mk-on )
            TO reported-zgp_i_screening_results.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZGP_I_PATIENT_M DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zgp_i_patient_m RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zgp_i_patient_m RESULT result.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE zgp_i_patient_m.

    METHODS earlynumbering_cba_result FOR NUMBERING
      IMPORTING entities FOR CREATE zgp_i_patient_m\_result.

ENDCLASS.

CLASS lhc_ZGP_I_PATIENT_M IMPLEMENTATION.

  METHOD get_instance_authorizations.
    DATA: update_requested TYPE abap_bool,
          update_granted   TYPE abap_bool.

    READ ENTITIES OF zgp_i_patient_m IN LOCAL MODE
      ENTITY zgp_i_patient_m
      FIELDS ( Patientid Name ) WITH CORRESPONDING #( keys )
      RESULT DATA(requested_patents)
      FAILED failed.
    CHECK requested_patents IS NOT INITIAL.

    update_requested = COND #( WHEN requested_authorizations-%update = if_abap_behv=>mk-on THEN abap_true ELSE abap_false ).

    LOOP AT requested_patents ASSIGNING FIELD-SYMBOL(<ls_requested_patent>).
      IF <ls_requested_patent>-Name NE sy-uname.    " I can edit only my data
        APPEND VALUE #( %tky = <ls_requested_patent>-%tky ) TO failed-zgp_i_patient_m.
        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                        %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                            text = 'No authorization to update this patent!'
                        )
        ) TO reported-zgp_i_patient_m.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA patients TYPE SORTED TABLE OF zgp_patient WITH UNIQUE KEY patientid.
*    DATA: max_id TYPE int1.
*    IF patients IS INITIAL.
*      SELECT MAX( patientid ) FROM zgp_patient INTO @max_id.
*    ELSE.
*      max_id = patients[ lines( patients ) ]-patientid.
*    ENDIF.
*
*    max_id += 1.

    DATA: lv_number TYPE zgp_database_external_id.

    TRY.

        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = '01'
            object            = 'Z_GP_PID'
          IMPORTING
             number            = DATA(lv_patent_id) ).
      CATCH cx_nr_object_not_found
            cx_number_ranges.
        RETURN.
    ENDTRY.

    DELETE patients WHERE patientid IS INITIAL.
    IF patients IS NOT INITIAL.
      SELECT FROM zgp_patient FIELDS patientid
        WHERE patientid = @lv_patent_id
        INTO TABLE @DATA(patient_db).
    ENDIF.


    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>).
      INSERT VALUE #( %cid            = <ls_entity>-%cid
                      patientid  = lv_patent_id ) INTO TABLE mapped-zgp_i_patient_m.
    ENDLOOP.

  ENDMETHOD.

  METHOD earlynumbering_cba_Result.

    DATA patients TYPE SORTED TABLE OF zgp_patient WITH UNIQUE KEY patientid.
    DATA results TYPE SORTED TABLE OF zgp_scr_results WITH UNIQUE KEY resultid.
    DATA: max_id TYPE int1.


    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entity>).
      IF results IS INITIAL.
        SELECT MAX( resultid ) FROM zgp_scr_results WHERE patientid = @<ls_entity>-patientid INTO @max_id.
      ELSE.
        SELECT MAX( resultid ) FROM zgp_scr_results WHERE patientid = @<ls_entity>-patientid INTO @max_id.
      ENDIF.
      max_id += 1.

      LOOP AT <ls_entity>-%target ASSIGNING FIELD-SYMBOL(<ls_result_create>).
        INSERT VALUE #( %cid            = <ls_result_create>-%cid
                    patientid = <ls_entity>-patientid
                    resultid = max_id ) INTO TABLE mapped-zgp_i_screening_results.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_global_authorizations.

    " Check if update operation is triggered or not
    IF requested_authorizations-%update = if_abap_behv=>mk-on.

      AUTHORITY-CHECK
               OBJECT 'Z_GP_PTNT'
                   ID 'ACTVT' FIELD '02'.

      IF sy-subrc EQ 0.
        " Change access is allowed
        result-%update = if_abap_behv=>auth-allowed.
      ELSE.
        " Change access is not allowed
        result-%update = if_abap_behv=>auth-unauthorized.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
