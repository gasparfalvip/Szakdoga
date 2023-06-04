CLASS zgp_clear_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
      INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZGP_CLEAR_DATA IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.

** institution
DELETE FROM zgp_institution.

** locations
DELETE FROM zgp_location.

**patients
DELETE FROM zgp_patient.

**results
DELETE FROM zgp_scr_results.

** screenings
DELETE FROM zgp_screening.

** appointment
DELETE FROM zgp_scr_appntmnt.

** screening types
DELETE FROM zgp_scrnng_type.

ENDMETHOD.
ENDCLASS.
