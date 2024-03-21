*&---------------------------------------------------------------------*
*& Report  ZGOOG_R_DEMO_FIREBASE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

report zgoog_r_demo_firebase.

include zgoog_i_demo_firebase_def.
include zgoog_i_demo_firebase_sel.
include zgoog_i_demo_firebase_impl.

start-of-selection.
  lcl_main=>authorization_check( ).
  create object go_demo
    exporting
      iv_client_key = p_key.

  go_demo->execute( ).

end-of-selection.
  go_demo->close_connection( ).
