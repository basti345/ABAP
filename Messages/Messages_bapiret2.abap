class ZCL_MSG definition
  public
  create public .

public section.

  class-methods GET_BAL_MSG_FROM_YS_MSG
    returning
      value(R_STR_BAL_MSG) type BAL_S_MSG .
  class-methods GET_BAPIRET2
    importing
      !I_LANGU type SY-LANGU default SY-LANGU
      !I_MSGTY type SY-MSGTY
      !I_MSGID type SY-MSGID
      !I_MSGNO type SY-MSGNO
      !I_MSGV1 type SYST_MSGV optional
      !I_MSGV2 type SYST_MSGV optional
      !I_MSGV3 type SYST_MSGV optional
      !I_MSGV4 type SYST_MSGV optional
    returning
      value(R_STR_BAPIRET) type BAPIRET2 .
  class-methods GET_BAPIRET2_FROM_BDCMSG
    importing
      !I_STR_BDCMSG type BDCMSGCOLL
    returning
      value(R_STR_BAPIRET) type BAPIRET2 .
  class-methods GET_BAPIRET2_FROM_EXCEPTION
    importing
      !I_REF_EX type ref to CX_ROOT
    returning
      value(R_STR_BAPIRET) type BAPIRET2 .
  class-methods GET_BAPIRET2_FROM_SY_MSG
    returning
      value(R_STR_BAPIRET) type BAPIRET2 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_MSG IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_MSG=>GET_BAL_MSG_FROM_YS_MSG
* +-------------------------------------------------------------------------------------------------+
* | [<-()] R_STR_BAL_MSG                  TYPE        BAL_S_MSG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_bal_msg_from_ys_msg.
    CLEAR r_str_bal_msg.
    r_str_bal_msg-msgty = sy-msgty.
    r_str_bal_msg-msgid = sy-msgid.
    r_str_bal_msg-msgno = sy-msgno.
    r_str_bal_msg-msgv1 = sy-msgv1.
    r_str_bal_msg-msgv2 = sy-msgv2.
    r_str_bal_msg-msgv3 = sy-msgv3.
    r_str_bal_msg-msgv4 = sy-msgv4.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_MSG=>GET_BAPIRET2
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_LANGU                        TYPE        SY-LANGU (default =SY-LANGU)
* | [--->] I_MSGTY                        TYPE        SY-MSGTY
* | [--->] I_MSGID                        TYPE        SY-MSGID
* | [--->] I_MSGNO                        TYPE        SY-MSGNO
* | [--->] I_MSGV1                        TYPE        SYST_MSGV(optional)
* | [--->] I_MSGV2                        TYPE        SYST_MSGV(optional)
* | [--->] I_MSGV3                        TYPE        SYST_MSGV(optional)
* | [--->] I_MSGV4                        TYPE        SYST_MSGV(optional)
* | [<-()] R_STR_BAPIRET                  TYPE        BAPIRET2
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_bapiret2.
    CLEAR r_str_bapiret.
    CALL FUNCTION 'BALW_BAPIRETURN_GET2'
      EXPORTING
        type   = i_msgty
        cl     = i_msgid
        number = i_msgno
        par1   = i_msgv1
        par2   = i_msgv2
        par3   = i_msgv3
        par4   = i_msgv4
*       LOG_NO = ' '
*       LOG_MSG_NO       = ' '
*       PARAMETER        = ' '
*       ROW    = 0
*       FIELD  = ' '
      IMPORTING
        return = r_str_bapiret.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_MSG=>GET_BAPIRET2_FROM_BDCMSG
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_STR_BDCMSG                   TYPE        BDCMSGCOLL
* | [<-()] R_STR_BAPIRET                  TYPE        BAPIRET2
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_bapiret2_from_bdcmsg.
    r_str_bapiret = get_bapiret2( i_msgty = i_str_bdcmsg-msgtyp
                                  i_msgno = CONV syst_msgno( i_str_bdcmsg-msgnr )
                                  i_msgid = i_str_bdcmsg-msgid
                                  i_msgv1 = CONV syst_msgv( i_str_bdcmsg-msgv1 )
                                  i_msgv2 = CONV syst_msgv( i_str_bdcmsg-msgv2 )
                                  i_msgv3 = CONV syst_msgv( i_str_bdcmsg-msgv3 )
                                  i_msgv4 = CONV syst_msgv( i_str_bdcmsg-msgv4 ) ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_MSG=>GET_BAPIRET2_FROM_EXCEPTION
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_REF_EX                       TYPE REF TO CX_ROOT
* | [<-()] R_STR_BAPIRET                  TYPE        BAPIRET2
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_bapiret2_from_exception.
    DATA l_str_t100_key  TYPE scx_t100key.
    CLEAR r_str_bapiret.

    r_str_bapiret-message = i_ref_ex->get_text( ).

    r_str_bapiret-type = 'E'.

    cl_message_helper=>check_msg_kind( EXPORTING msg     = i_ref_ex
                                       IMPORTING t100key = l_str_t100_key ).

    IF l_str_t100_key IS INITIAL.
      RETURN.
    ENDIF.

    r_str_bapiret-id         = l_str_t100_key-msgid.
    r_str_bapiret-number     = l_str_t100_key-msgno.
    r_str_bapiret-message_v1 = l_str_t100_key-attr1.
    r_str_bapiret-message_v2 = l_str_t100_key-attr2.
    r_str_bapiret-message_v3 = l_str_t100_key-attr3.
    r_str_bapiret-message_v4 = l_str_t100_key-attr4.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_MSG=>GET_BAPIRET2_FROM_SY_MSG
* +-------------------------------------------------------------------------------------------------+
* | [<-()] R_STR_BAPIRET                  TYPE        BAPIRET2
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_bapiret2_from_sy_msg.
    r_str_bapiret = get_bapiret2( i_msgty = sy-msgty
                                  i_msgno = sy-msgno
                                  i_msgid = sy-msgid
                                  i_msgv1 = sy-msgv1
                                  i_msgv2 = sy-msgv2
                                  i_msgv3 = sy-msgv3
                                  i_msgv4 = sy-msgv4 ).
  ENDMETHOD.
ENDCLASS.
