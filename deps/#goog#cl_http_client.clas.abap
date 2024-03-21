class /GOOG/CL_HTTP_CLIENT definition
  public
  create public.

public section. 

constants C_RET_CODE_461 type i value 461.
constants C_METHOD_POST type STRING value 'POST' ##NO_TEXT.
data GV_PROJECT_ID type string .

  methods MAKE_REQUEST
    importing
      !IV_BODY type STRING optional
      !IV_XBODY type XSTRING optional
      !IV_URI type STRING optional
      !IV_METHOD type STRING
      !IV_CONTENT_TYPE type STRING default 'application/json'
    exporting
      !ES_DATA type DATA
      !ES_RESPONSE type STRING
      !EV_EXIST type CHAR01
      !EV_RET_CODE type I
      !EV_ERR_TEXT type STRING
      !EV_OAUTH type CHAR01
      !EV_ERR_RESP type /GOOG/ERR_RESP
    raising
      /GOOG/CX_SDK .
  methods RAISE_ERROR
    importing
      !IV_ERR_TEXT type STRING optional
      !IV_RET_CODE type I optional
      !IV_ERR_RESP type /GOOG/ERR_RESP optional
      !IV_METHOD type STRING optional
      !IV_INP type CHAR1 optional
      !IV_OAUTH type CHAR1 optional
    exporting
      !EV_EXIST type CHAR01
    raising
      /GOOG/CX_SDK .
   
  methods CLOSE_HTTP_CLIENT .
  methods CONSTRUCTOR
    importing
      !IS_KEY type /GOOG/CLIENT_KEY optional
      !IV_ENDPOINT type STRING optional
      !IV_ENDPOINT_SUFFIX type STRING optional
      !IV_SERVICE_NAME type /GOOG/SERVICE_NAME optional
      !IV_LOG_OBJ type BALOBJ_D optional
      !IV_LOG_SUBOBJ type BALSUBOBJ optional
    raising
      /GOOG/CX_SDK .
   
  class-methods IS_SUCCESS
    importing
      !IV_CODE type I
    returning
      value(RV_RESULT) type ABAP_BOOL .
  
  methods IS_STATUS_OK
    returning
      value(RV_RESULT) type ABAP_BOOL .
protected section.

*"* protected components of class /GOOG/CL_HTTP_CLIENT
*"* do not include other source files here!!!
data GO_HTTP type ref to IF_HTTP_CLIENT .
data GT_NAME_MAPPINGS type /UI2/CL_JSON=>NAME_MAPPINGS .
data GT_COMMON_QPARAMS type /GOOG/T_HTTP_KEYS .
data GV_ENDPOINT_SUFFIX type string.
  
  PRIVATE SECTION.
*"* private components of class /GOOG/CL_HTTP_CLIENT
*"* do not include other source files here!!!
ENDCLASS.



CLASS /GOOG/CL_HTTP_CLIENT IMPLEMENTATION.
  METHOD make_request.
    RETURN. " todo, implement method
  ENDMETHOD.
  METHOD raise_error.
    RETURN. " todo, implement method
  ENDMETHOD.
  METHOD close_http_client.
    RETURN. " todo, implement method
  ENDMETHOD.
  METHOD constructor.
    RETURN. " todo, implement method
  ENDMETHOD.
  METHOD is_success.
    RETURN. " todo, implement method
  ENDMETHOD.
  METHOD is_status_ok.
    RETURN. " todo, implement method
  ENDMETHOD.

 
ENDCLASS.
