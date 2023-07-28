CLASS lcl_report DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS get_me IMPORTING !iv_bukrs        TYPE bukrs
                                   !iv_run_date     TYPE dats
                         RETURNING VALUE(re_obj_me) TYPE REF TO lcl_report.
    METHODS constructor
      IMPORTING
        !iv_bukrs    TYPE bukrs
        !iv_run_date TYPE dats.

    METHODS initialization.

    METHODS start
      IMPORTING !i_rng_carr_id TYPE typ_r_carrid.
  PROTECTED SECTION.
    CLASS-DATA a_ref TYPE REF TO lcl_report.

  PRIVATE SECTION.
    DATA a_bukrs TYPE bukrs.
    DATA a_run_date TYPE dats.
    DATA a_rng_carr_id TYPE  typ_r_carrid.
ENDCLASS.

CLASS lcl_report IMPLEMENTATION.
  METHOD get_me.
    re_obj_me = a_ref = COND #( WHEN a_ref IS BOUND
                  THEN a_ref
                  ELSE NEW lcl_report( iv_bukrs = iv_bukrs
                                       iv_run_date = iv_run_date ) ).
  ENDMETHOD.

  METHOD constructor.
    me->a_bukrs = iv_bukrs.
    me->a_run_date = iv_run_date.
  ENDMETHOD.

  METHOD initialization.
    DATA l_secu TYPE progname.

    SELECT SINGLE secu FROM trdir INTO l_secu
      WHERE name = sy-cprog.

    AUTHORITY-CHECK OBJECT 'Z_YOUR_OBJECT'
             ID 'Z_PROGNAME' FIELD sy-cprog
             ID 'P_GROUP'    FIELD l_secu
             ID 'ACTVT'      FIELD '02'."edit --> change for your permission check
    IF sy-subrc <> 0.
      MESSAGE e010(zrep_msg).
    ENDIF.
  ENDMETHOD.

  METHOD start.
    me->a_rng_carr_id = i_rng_carr_id.

    "Implementation from business requirments
  ENDMETHOD.
