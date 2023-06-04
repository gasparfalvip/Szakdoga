CLASS lhc_ZGP_I_SCREENING_TYPE_M DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zgp_i_screening_type_m RESULT result.
    METHODS validateagegroup FOR VALIDATE ON SAVE
      IMPORTING keys FOR zgp_i_screening_type_m~validateagegroup.

ENDCLASS.

CLASS lhc_ZGP_I_SCREENING_TYPE_M IMPLEMENTATION.

  METHOD get_instance_authorizations.

    " Just for debugging
    IF 1 = 1.
    ENDIF.

  ENDMETHOD.

  METHOD validateAgeGroup.
    READ ENTITY zgp_i_screening_type_m\\zgp_i_screening_type_m FROM VALUE #(
    FOR <root_key> IN keys ( %key-screening_type_id = <root_key>-screening_type_id
                              %control = VALUE #( target_age_group_from = if_abap_behv=>mk-on
                                                  target_age_group_to = if_abap_behv=>mk-on ) ) )
    RESULT DATA(lt_screening_types).

    LOOP AT lt_screening_types INTO DATA(ls_screening_types_results).

      IF ls_screening_types_results-target_age_group_from > ls_screening_types_results-target_age_group_to.

        APPEND VALUE #( %key = ls_screening_types_results-%key
                        screening_type_id = ls_screening_types_results-screening_type_id ) TO failed-zgp_i_screening_type_m.



      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
