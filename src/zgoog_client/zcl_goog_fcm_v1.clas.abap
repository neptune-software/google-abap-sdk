*----------------------------------------------------------------------*
*       CLASS ZCL_GOOG_FCM_V1 DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class ZCL_GOOG_FCM_V1 definition
  public
  inheriting from /GOOG/CL_HTTP_CLIENT
  create public .

public section.
  type-pools ABAP .

  types:
    begin of ty_android_notification,
                 title            type string,
                 body             type string,
                 icon             type string,
                 color            type string,
                 sound            type string,
                 tag              type string,
                 click_action     type string,
                 body_loc_key     type string,
      " Simplification for example
                 body_loc_args    type string_table,
                 title_loc_key    type string,
       " Simplification for example
                 title_loc_args   type string_table,
                 channel_id       type string,
                 ticker           type string,
                 sticky           type abap_bool,
                 event_time       type string,
                 local_only       type abap_bool,
                 notification_priority type string,
                 default_sound    type abap_bool,
                 default_vibrate_timings type abap_bool,
                 default_light_settings  type abap_bool,
      " Simplification for example
                 vibrate_timings  type string_table,
                 visibility       type string,
                 notification_count type int4,
      " Simplified, should be a structured type
                 light_settings   type string,
                 image            type string,
               end of ty_android_notification .
  types:
    begin of ty_fcm_options,
                 analytics_label type string,
               end of ty_fcm_options .
  types:
    begin of ty_android_config,
                 collapse_key            type string,
      "NORMAL | "HIGH
                 priority                type string,
                 ttl                     type string,
                 restricted_package_name type string,
                 data                    type ref to data,
                 notification            type ty_android_notification,
                 fcm_options             type ty_fcm_options,
                 direct_boot_ok          type abap_bool,
               end of ty_android_config .
  types:
    begin of ty_apns_payload,
       " This should be a complex structure; simplified here
                 aps type string,
               end of ty_apns_payload .
  types:
    begin of ty_apns_config,
                 headers type string_table,
                 payload type ty_apns_payload,
               end of ty_apns_config .
  types:
    begin of ty_notification,
                 title type string,
                 body  type string,
      " URL to the image
                 image type string,
               end of ty_notification .
  types:
    begin of ty_webpush_notification,
       " Simplified representation
                 actions         type ref to data,
                 title           type string,
                 body            type string,
                 icon            type string,
               end of ty_webpush_notification .
  types:
    begin of ty_webpush_config,
                 headers         type ref to data,
                 data            type ref to data,
                 notification    type ty_webpush_notification,
                 fcm_options     type ty_fcm_options,
               end of ty_webpush_config .
  types:
    begin of ty_base_message ,
      name         type string,
      data         type string,
      notification type ty_notification,
      android      type ty_android_config,
      apns         type ty_apns_config,
      webpush      type ty_webpush_config,
      fcm_options  type ty_fcm_options,
    end of ty_base_message .
  types:
    begin of ty_single_message.
            include type ty_base_message.
    types:
           token        type string,
           topic        type string,
           condition    type string,
         end of ty_single_message .
  types:
    begin of ty_send_each_res,
            output   type ty_single_message,
            raw      type string,
            ret_code type i,
            err_text type string,
            err_resp type /goog/err_resp,
           end of   ty_send_each_res .
  types:
    ty_t_send_each_res type standard table of ty_send_each_res with non-unique default key .
  types:
    begin of ty_multicast_message.
            include type ty_base_message.
    types:
           tokens        type string_table,
         end of ty_multicast_message .
  types:
    begin of ty_messages_send,
                 validate_only type abap_bool,
                 message       type ty_single_message,
               end of ty_messages_send .
  types:
    begin of ty_messages_send_each,
                 validate_only type abap_bool,
                 messages       type standard table of ty_single_message with non-unique default key,
               end of ty_messages_send_each .
  types:
    begin of ty_messages_send_each_for_mc,
                 validate_only type abap_bool,
                 message       type ty_multicast_message,
               end of ty_messages_send_each_for_mc .

  constants C_SERVICE_NAME type /GOOG/SERVICE_NAME value 'fcm:v1'. "#EC NOTEXT
  constants C_REVISION_DATE type DATUM value 20240321. "#EC NOTEXT     "#EC NEEDED
  constants C_SUPPORTED_AUTH type /GOOG/SUPP_AUTH value 'IJIJ'. "#EC NOTEXT     "#EC NEEDED
  constants C_ROOT_URL type STRING value 'https://fcm.googleapis.com'. "#EC NOTEXT
  constants C_PATH_PREFIX type STRING value ''. "#EC NOTEXT

  methods CLOSE .
  methods CONSTRUCTOR
    importing
      !IV_KEY_NAME type /GOOG/KEYNAME optional
      !IV_LOG_OBJ type BALOBJ_D optional
      !IV_LOG_SUBOBJ type BALSUBOBJ optional
    raising
      /GOOG/CX_SDK .
  methods MESSAGES_SEND
    importing
      !IS_INPUT type TY_MESSAGES_SEND optional
      !IV_FCM_PROJECTS_ID type STRING optional
    exporting
      !ES_OUTPUT type TY_SINGLE_MESSAGE
      !ES_RAW type DATA
      !EV_RET_CODE type I
      !EV_ERR_TEXT type STRING
      !ES_ERR_RESP type /GOOG/ERR_RESP
    raising
      /GOOG/CX_SDK .
  methods MESSAGES_SEND_EACH
    importing
      !IS_INPUT type TY_MESSAGES_SEND_EACH
      !IV_FCM_PROJECTS_ID type STRING
    exporting
      !ET_OUTPUT type TY_T_SEND_EACH_RES
    raising
      /GOOG/CX_SDK .
  methods MESSAGES_SEND_EACH_FOR_MC
    importing
      !IS_INPUT type TY_MESSAGES_SEND_EACH_FOR_MC
      !IV_FCM_PROJECTS_ID type STRING
    exporting
      !ET_OUTPUT type TY_T_SEND_EACH_RES
    raising
      /GOOG/CX_SDK .
protected section.
private section.
ENDCLASS.



CLASS ZCL_GOOG_FCM_V1 IMPLEMENTATION.


method close.
  close_http_client( ).
  clear go_http.
endmethod.


method constructor.
  data: lv_err_text          type string,
          lv_endpoint        type string,
          lv_endpoint_suffix type  string.

  data: ls_key      type /goog/client_key,
        ls_err_resp type /goog/err_resp,
        ls_msg      type bapiret2,
        lt_msg      type bapiret2_t.

  /goog/cl_utility=>get_client_key( exporting iv_keyname    = iv_key_name
                                    importing es_client_key = ls_key
                                              et_msg        = lt_msg ).

  lv_endpoint = c_root_url.
  lv_endpoint_suffix = c_path_prefix.

  super->constructor( "is_key             = ls_key "#1
                      iv_key             = iv_key_name "#1
                      iv_endpoint        = lv_endpoint
                      iv_endpoint_suffix = lv_endpoint_suffix
                      iv_service_name    = c_service_name
                      iv_log_obj         = iv_log_obj
                      iv_log_subobj      = iv_log_subobj ).

  if ls_key is initial.

    loop at lt_msg into ls_msg.
      message id ls_msg-id type ls_msg-type number ls_msg-number
                 into lv_err_text
                 with ls_msg-message_v1 ls_msg-message_v2
                 ls_msg-message_v3 ls_msg-message_v4.
      ls_err_resp-error_description = ls_err_resp-error_description && lv_err_text.
    endloop.

    message id ls_msg-id type ls_msg-type number ls_msg-number
               into lv_err_text.
    ls_err_resp-error = lv_err_text.

    call method me->raise_error
      exporting
        iv_ret_code = /goog/cl_http_client=>c_ret_code_461
        iv_err_resp = ls_err_resp
        iv_err_text = ls_err_resp-error_description.

  endif.
endmethod.


method messages_send.

  data: lv_uri        type string,
        lv_json_final type string,
        lv_mid        type string,
        ls_output     like es_output,
        lv_response   type string.

  data: ls_common_qparam type /goog/s_http_keys.

  lv_uri = gv_endpoint_suffix && |v1/projects/{ iv_fcm_projects_id }/messages:send|.

  if gt_common_qparams is not initial.
    lv_uri = lv_uri && '?'.
    loop at gt_common_qparams into ls_common_qparam.
      if ls_common_qparam-name is not initial and
           ls_common_qparam-value is not initial.
        lv_uri = lv_uri && ls_common_qparam-name && '=' && ls_common_qparam-value.
        lv_uri = lv_uri && '&'.
      endif.
    endloop.
    lv_uri = substring( val = lv_uri off = 0 len = strlen( lv_uri ) - 1 ).
  endif.

  if gt_common_qparams is initial.
    lv_uri = lv_uri && '?'.
  else.
    lv_uri = lv_uri && '&'.
  endif.

  lv_uri = substring( val = lv_uri off = 0 len = strlen( lv_uri ) - 1 ).

  if is_input is supplied.
    concatenate c_service_name
                '#'
                'fcm.projects.messages.send'
                into lv_mid.

    lv_json_final = /goog/cl_json_util=>serialize_json(
      is_data          = is_input
      iv_method_id     = lv_mid
      it_name_mappings = gt_name_mappings ).
  endif.

* Call HTTP method
  call method make_request
    exporting
      iv_uri      = lv_uri
      iv_method   = c_method_post
      iv_body     = lv_json_final
    importing
      es_response = lv_response
      ev_ret_code = ev_ret_code
      ev_err_text = ev_err_text
      ev_err_resp = es_err_resp.

  es_raw = lv_response.

  /goog/cl_json_util=>deserialize_json( exporting iv_json          = lv_response
                                                  iv_pretty_name   = /ui2/cl_json=>pretty_mode-extended
                                                  it_name_mappings = gt_name_mappings
                                        importing es_data          = ls_output ).

  es_output = ls_output.
endmethod.


method messages_send_each.

  data: ls_output         like line of et_output,
        ls_messages_send  type ty_messages_send.

  clear: et_output.

  ls_messages_send-validate_only = is_input-validate_only.

  loop at is_input-messages into ls_messages_send-message.
    messages_send( exporting is_input           = ls_messages_send
                             iv_fcm_projects_id = iv_fcm_projects_id
                   importing es_output          = ls_output-output
                             es_raw             = ls_output-raw
                             ev_ret_code        = ls_output-ret_code
                             ev_err_text        = ls_output-err_text
                             es_err_resp        = ls_output-err_resp ).

    insert ls_output into table et_output.

  endloop.

endmethod.


method messages_send_each_for_mc.

  data: ls_output         like line of et_output,
        ls_messages_send  type ty_messages_send.

  clear: et_output.

  ls_messages_send-validate_only = is_input-validate_only.
  move-corresponding is_input-message to ls_messages_send-message.

  loop at is_input-message-tokens into ls_messages_send-message-token.
     messages_send( exporting is_input           = ls_messages_send
                              iv_fcm_projects_id = iv_fcm_projects_id
                    importing es_output          = ls_output-output
                              es_raw             = ls_output-raw
                              ev_ret_code        = ls_output-ret_code
                              ev_err_text        = ls_output-err_text
                              es_err_resp        = ls_output-err_resp ).

    insert ls_output into table et_output.

  endloop.


endmethod.
ENDCLASS.
