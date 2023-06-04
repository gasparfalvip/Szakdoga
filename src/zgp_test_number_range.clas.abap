CLASS zgp_test_number_range DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZGP_TEST_NUMBER_RANGE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

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
        out->write( 'Hiba a numebr range-el' ).
        RETURN.
    ENDTRY.

    out->write( lv_patent_id ).

  ENDMETHOD.
ENDCLASS.
