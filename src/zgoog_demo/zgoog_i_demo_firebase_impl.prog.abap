*&---------------------------------------------------------------------*
*&  Include           ZGOOG_I_DEMO_FIREBASE_IMPL
*&---------------------------------------------------------------------*


class lcl_main implementation.
  method constructor.
    data: lv_msg       type string,
          lo_exception type ref to /goog/cx_sdk.

    try.
        create object mo_client
          exporting
            iv_key_name = iv_client_key.
      catch /goog/cx_sdk into lo_exception.
        lv_msg = lo_exception->get_text( ).
        message lv_msg type 'S' display like 'E'.
    endtry.
  endmethod.

  method authorization_check.

    authority-check object 'ZGOOG_SDK'
      id 'ACTVT' field '16'.
    if sy-subrc <> 0.
      message e003(/goog/sdk_msg) with /goog/cl_googauth_v1=>c_ret_code_461.
    endif.

  endmethod.

  method execute.

    data: lv_token  type string,
          lt_tokens type string_table.

    field-symbols <ls_r_token> like line of s_tokens[].

    if go_demo->mo_client is bound.

      if p_rb1 = abap_true.
        "Topic
        send_message_topic( iv_dryrun = p_dryrun
                            iv_title  = p_title
                            iv_body   = p_body
                            iv_topic  = p_topic ).
      elseif p_rb2 = abap_true.
        "Device Tokens
        loop at s_tokens[] assigning <ls_r_token>.
          lv_token = <ls_r_token>-low.
          insert lv_token into table lt_tokens.
        endloop.
        send_message_multicast( iv_dryrun = p_dryrun
                                iv_title  = p_title
                                iv_body   = p_body
                                it_tokens = lt_tokens ).
      endif.

    endif.

  endmethod.


  method send_message_topic.

**  Data Declarations
    data:
      ls_input           type zcl_goog_fcm_v1=>ty_messages_send,
      lv_fcm_projects_id type string,
      lv_msg             type string,
      lv_ret_code        type i,
      lv_err_text        type string,
      ls_err_resp        type /goog/err_resp,
      ls_output          type zcl_goog_fcm_v1=>ty_single_message,
      lo_exception       type ref to /goog/cx_sdk.

    lv_fcm_projects_id = mo_client->gv_project_id.

    ls_input-message-topic = iv_topic.
    ls_input-validate_only = iv_dryrun.
    ls_input-message-notification-title = iv_title.
    ls_input-message-notification-body = iv_body.

    try.
        call method mo_client->messages_send
          exporting
            is_input           = ls_input
            iv_fcm_projects_id = lv_fcm_projects_id
          importing
            es_output          = ls_output
            ev_ret_code        = lv_ret_code
            ev_err_text        = lv_err_text
            es_err_resp        = ls_err_resp.

      catch /goog/cx_sdk into lo_exception.
        lv_msg = lo_exception->get_text( ).
        message lv_msg type 'S' display like 'E'.
        return.
    endtry.

    if mo_client->is_success( lv_ret_code ) = abap_true.
      if ls_output is not initial.
        cl_demo_output=>display( ls_output ).
      else.
        cl_demo_output=>display( 'Unable to retrieve Result' ).
      endif.
    else.
      lv_msg = lv_ret_code && ':' && lv_err_text.
      cl_demo_output=>display( lv_msg ).
    endif.

  endmethod.

  method send_message_multicast.

**  Data Declarations
    data:
      ls_input           type zcl_goog_fcm_v1=>ty_messages_send_each_for_mc,
      lv_fcm_projects_id type string,
      lt_output          type zcl_goog_fcm_v1=>ty_t_send_each_res,
      lv_msg             type string,
      lo_exception       type ref to /goog/cx_sdk.

    lv_fcm_projects_id = mo_client->gv_project_id.

    ls_input-message-tokens = it_tokens.
    ls_input-validate_only = iv_dryrun.
    ls_input-message-notification-title = iv_title.
    ls_input-message-notification-body = iv_body.

    try.
        call method mo_client->messages_send_each_for_mc
          exporting
            is_input           = ls_input
            iv_fcm_projects_id = lv_fcm_projects_id
          importing
            et_output          = lt_output.

      catch /goog/cx_sdk into lo_exception.
        lv_msg = lo_exception->get_text( ).
        message lv_msg type 'S' display like 'E'.
        return.
    endtry.

    cl_demo_output=>display( lt_output ).


  endmethod.
  method close_connection.
    if mo_client is bound.
      mo_client->close( ).
    endif.
  endmethod.

endclass.
