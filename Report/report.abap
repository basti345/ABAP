REPORT z_rep_test.

INCLUDE z_inc_test_gui.

INCLUDE z_inc_test_class.

INITIALIZATION.

  lcl_report=>get_me( iv_bukrs = p_bukrs
                      iv_run_date = p_runda )->initialization( ).

START-OF-SELECTION.

  "shows how an input parameter of a select-option is passed
  lcl_report=>get_me( iv_bukrs = p_bukrs
                      iv_run_date = p_runda )->start( i_rng_carr_id = so_carr[] ).
