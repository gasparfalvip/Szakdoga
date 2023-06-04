CLASS zgp_create_health_app_nrange DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZGP_CREATE_HEALTH_APP_NRANGE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA : lo_norange  TYPE REF TO cl_numberrange_objects,
           lo_interval TYPE REF TO cl_numberrange_intervals,
           lo_runtime  TYPE REF TO cl_numberrange_runtime.

    DATA : ls_nr_attribute TYPE cl_numberrange_objects=>nr_attribute,
           ls_obj_text     TYPE cl_numberrange_objects=>nr_obj_text,

           lv_returncode   TYPE cl_numberrange_objects=>nr_returncode,
           lv_errors       TYPE cl_numberrange_objects=>nr_errors,

           lt_nr_interval  TYPE cl_numberrange_intervals=>nr_interval,
           ls_nr_interval  LIKE LINE OF lt_nr_interval,

           nr_number       TYPE cl_numberrange_runtime=>nr_number,
           nr_interval1    TYPE cl_numberrange_runtime=>nr_interval,
           error           TYPE cl_numberrange_intervals=>nr_error,
           error_inf       TYPE cl_numberrange_intervals=>nr_error_inf,
           error_iv        TYPE cl_numberrange_intervals=>nr_error_iv,
           warning         TYPE cl_numberrange_intervals=>nr_warning.

    " Create number range
    ls_nr_attribute-object     = 'Z_GP_SID'.      " Number Range
    ls_nr_attribute-domlen     = 'ZGP_SCREENINGS_ID'. " Domain
    ls_nr_attribute-devclass   = 'Z_GP_HEALTH'.   " Package where number range actually gets created
    ls_nr_attribute-buffer     = 'X'.
    ls_nr_attribute-percentage = 10.


    ls_obj_text-langu    = 'E'.
    ls_obj_text-object   = 'Z_GP_SID'.
    ls_obj_text-txt      = 'Screening ID Number Range'.
    ls_obj_text-txtshort = 'Scr ID'.

    ls_nr_interval-subobject  = ''.
    ls_nr_interval-nrrangenr  = '01'. " Number range interval
    ls_nr_interval-fromnumber = '0000001'. " starting number
    ls_nr_interval-tonumber   = '9999999'. " ending number
    ls_nr_interval-procind    = 'I'.
    APPEND ls_nr_interval TO lt_nr_interval.

    " Try to create the number range object
    TRY.
        cl_numberrange_objects=>create(
          EXPORTING
              attributes = ls_nr_attribute
              obj_text   = ls_obj_text
          IMPORTING
              errors     = lv_errors
              returncode = lv_returncode ).
        out->write( lv_errors ).
      CATCH cx_number_ranges INTO DATA(lx_number_range).
        out->write( 'Number range cannot be created').
        out->write( lx_number_range->get_text( ) ).
    ENDTRY.

    " Try to create the intevals
    TRY.
        cl_numberrange_intervals=>create(
          EXPORTING
            interval = lt_nr_interval
            object   = ls_nr_attribute-object
            subobject = '' ).
      CATCH cx_nr_object_not_found cx_number_ranges
        INTO DATA(lx_number_range_interval).
      out->write( 'Number range interval cannot be created.' ).
      out->write( lx_number_range_interval->get_text( ) ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
