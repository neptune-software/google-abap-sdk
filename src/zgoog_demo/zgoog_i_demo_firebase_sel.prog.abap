*&---------------------------------------------------------------------*
*&  Include           ZGOOG_I_DEMO_FIREBASE_SEL
*&---------------------------------------------------------------------*


data: go_demo type ref to lcl_main.

data: g_token type c length 200.

selection-screen begin of block b1 with frame title text-t01.

parameters: p_rb1 type char1 radiobutton group rbg1 default 'X' user-command stt, " Topic
            p_rb2 type char1 radiobutton group rbg1. "Device Token

selection-screen end of block b1.

selection-screen begin of block b2 with frame title text-t02.
parameters: p_key   type /goog/keyname obligatory matchcode object /goog/sh_gcp_key_nm,
            p_dryrun as checkbox,
            p_title type string lower case default 'Hello',
            p_body  type string lower case default 'World'.
parameters: p_topic type string lower case modif id top.
select-options: s_tokens for g_token lower case no intervals modif id tok.
selection-screen end of block b2.

at selection-screen output.
  loop at screen.
    if p_rb1 is not initial.
      if screen-group1 = 'TOP'.
        screen-active = '1'.
      elseif screen-group1 = 'TOK'.
        screen-active = '0'.
      endif.
    elseif p_rb2 is not initial.
      if screen-group1 = 'TOP'.
        screen-active = '0'.
      elseif screen-group1 = 'TOK'.
        screen-active = '1'.
      endif.
    endif.

    modify screen.
  endloop.
