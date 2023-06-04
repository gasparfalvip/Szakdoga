CLASS zgp_generate_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZGP_GENERATE_DATA IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.

** institution **

DATA institution_itab TYPE TABLE OF zgp_institution.

institution_itab = VALUE #(
( institutionid = '2' name = 'NEAK2' )
).

DELETE FROM zgp_institution.

INSERT zgp_institution FROM TABLE @institution_itab.

out->write( |{ sy-dbcnt } institution entries inserted successfully!| ).


** locations **

DATA location_itab TYPE TABLE OF zgp_location.

location_itab = VALUE #(
( locationid = '1' location_name = 'Borsod-Abaúj-Zemplén Megyei Központi Kórház és Egyetemi Oktatókórház' location_post_code = '3526' location_city = 'Miskolc' location_address = 'Szentpéteri kapu' location_house_number = '72-76' )
).

DELETE FROM zgp_location.

INSERT zgp_location FROM TABLE @location_itab.

out->write( |{ sy-dbcnt } location entries inserted successfully!| ).


** patients **

DATA patient_itab TYPE TABLE OF zgp_patient.

patient_itab = VALUE #(
( patientid = '1' name = 'Cserepes Virág' age = '70' gender = 'F' )
( patientid = '2' name = 'Kiss Ödön' age = '58' gender = 'M' )
( patientid = '3' name = 'Kiss László' age = '66' gender = 'M' )
).

DELETE FROM zgp_patient.

INSERT zgp_patient FROM TABLE @patient_itab.

out->write( |{ sy-dbcnt } patient entries inserted successfully!| ).


** results **

DATA result_itab TYPE TABLE OF zgp_scr_results.

result_itab = VALUE #(
**( patientid = '' resultid = '' scr_date = '' scr_result = '' )
( patientid = '1' resultid = '1' scr_date = '20230105' scr_result = 'N' )
( patientid = '2' resultid = '1' scr_date = '20230104' scr_result = 'N' )

).

DELETE FROM zgp_scr_results.

INSERT zgp_scr_results FROM TABLE @result_itab.

out->write( |{ sy-dbcnt } patient's result entries inserted successfully!| ).


** screenings **

DATA screening_itab TYPE TABLE OF zgp_screening.

screening_itab = VALUE #(
( screeningid = '1' screeningtypeid = '1' institutionid = '1' screening_start_date = '20230102' screening_end_date = '20230107' locationid = '1')
).

DELETE FROM zgp_screening.

INSERT zgp_screening FROM TABLE @screening_itab.

out->write( |{ sy-dbcnt } screening entries inserted successfully!| ).


** appointment **

DATA appointment_itab TYPE TABLE OF zgp_scr_appntmnt.

appointment_itab = VALUE #(
( appointmentid = '1' screeningid = '1' patientid = '2' appointment_date = '20230104' appointment_time = '120000')
( appointmentid = '2' screeningid = '1' patientid = '1' appointment_date = '20230105' appointment_time = '120000')
).

DELETE FROM zgp_scr_appntmnt.

INSERT zgp_scr_appntmnt FROM TABLE @appointment_itab.

out->write( |{ sy-dbcnt } screening appointment entries inserted successfully!| ).


** screening types **

DATA screeningtype_itab TYPE TABLE OF zgp_scrnng_type.

screeningtype_itab = VALUE #(
( screening_type_id = '1' name = 'Végbél rák szűrés' target_age_group_from = '50' target_age_group_to = '70' target_gender = 'B' optimal_frequency = '2'  )
( screening_type_id = '2' name = 'Emlő rák szűrés' target_age_group_from = '45' target_age_group_to = '65' target_gender = 'F' optimal_frequency = '2')
( screening_type_id = '3' name = 'Méhnyak rák szűrés' target_age_group_from = '45' target_age_group_to = '65' target_gender = 'F' optimal_frequency = '2')
).

DELETE FROM zgp_scrnng_type.

INSERT zgp_scrnng_type FROM TABLE @screeningtype_itab.

out->write( |{ sy-dbcnt } screening_type entries inserted successfully!| ).



ENDMETHOD.
ENDCLASS.
