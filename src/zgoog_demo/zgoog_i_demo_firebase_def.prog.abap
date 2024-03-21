*&---------------------------------------------------------------------*
*&  Include           ZGOOG_I_DEMO_FIREBASE_DEF
*&---------------------------------------------------------------------*

class lcl_main definition.
  public section.
    methods:
      constructor       importing iv_client_key type /goog/keyname,
      execute,
      close_connection.

    class-methods: authorization_check.

  private section.

    data: mo_client type ref to zcl_goog_fcm_v1.
    methods:
      send_message_topic importing iv_dryrun type abap_bool
                                   iv_title  type string
                                   iv_body   type string
                                   iv_topic  type string.
    methods send_message_multicast importing iv_dryrun type abap_bool
                                             iv_title  type string
                                             iv_body   type string
                                             it_tokens type string_table .

endclass.                    "lcl_main DEFINITION
