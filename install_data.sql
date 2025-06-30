/* $Header: install_data.sql 11.1.1111.0 2025/04/11 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    install_data.sql                                                   |
REM |                                                                       |
REM | DESCRIPTION                                                           |
REM |    Inserta datos.                                                     |
REM |                                                                       |
REM | LANGUAGE                                                              |
REM |    PL/SQL                                                             |
REM |                                                                       |
REM | PRODUCT                                                               |
REM |    Oracle Cloud                                                       |
REM |                                                                       |
REM | HISTORY                                                               |
REM |    11-MAR-25  iloaiza       Created                                   |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL install_data.log


PROMPT =====================================================================
PROMPT Script install_data.sql
PROMPT =====================================================================


SHOW USER

SELECT TO_CHAR(SYSDATE,'DD-MON-YYYY HH24:MI:SS') AS "Start_Date"
  FROM dual;

SELECT 'Datatabase Name...: '||SYS_CONTEXT('USERENV','DB_NAME')||CHR(10)||
       'Instance Name.....: '||SYS_CONTEXT('USERENV','INSTANCE_NAME')||CHR(10)||
       'Service Name......: '||SYS_CONTEXT('USERENV','SERVICE_NAME') AS "Environment"
  FROM dual;


SET SERVEROUTPUT ON SIZE 1000000


PROMPT =====================================================================
PROMPT Creando Mensajes

DECLARE
  TYPE r_data IS RECORD(module         VARCHAR2(200)
                       ,message_code   VARCHAR2(100)
                       ,message_global VARCHAR2(1)
                       ,message        VARCHAR2(4000)
                       );
  TYPE t_data IS TABLE OF r_data INDEX BY BINARY_INTEGER;
  tbl_data t_data;
  PROCEDURE add_tbl(p_module         IN VARCHAR2
                   ,p_message_code   IN VARCHAR2
                   ,p_message_global IN VARCHAR2
                   ,p_message        IN VARCHAR2
                   )
  IS
    v_cnt_tbl NUMBER(18);
  BEGIN
    v_cnt_tbl := tbl_data.last;
    v_cnt_tbl := NVL(v_cnt_tbl,0) + 1;
    tbl_data(v_cnt_tbl).module         := UPPER(TRIM(p_module));
    tbl_data(v_cnt_tbl).message_code   := UPPER(TRIM(p_message_code));
    tbl_data(v_cnt_tbl).message_global := UPPER(TRIM(p_message_global));
    tbl_data(v_cnt_tbl).message        := TRIM(p_message);
  END add_tbl;
  PROCEDURE process
  IS
    v_language      VARCHAR2(30);
    v_user_name     VARCHAR2(64);
    v_return_status VARCHAR2(1);
    v_cnt           NUMBER(18);
    v_cnt_success   NUMBER(18);
    v_cnt_error     NUMBER(18);
    v_mesg_error    VARCHAR2(32767);
  BEGIN
    v_language  := 'ESA';
    v_user_name := 'gustavo.iturburu@oracle.com';
    FOR cnt IN tbl_data.first..tbl_data.last LOOP
        dbms_output.put_line('---------------------------------------------------------------------');
        dbms_output.put_line(SUBSTR('Mensaje: '||tbl_data(cnt).module||' '||tbl_data(cnt).message_code,1,250));
        v_return_status := NULL;
        v_mesg_error    := NULL;
        v_cnt           := NVL(v_cnt,0)+1;
        BEGIN
          xx_messages_pkg.create_update_message
            (p_module         => tbl_data(cnt).module
            ,p_message_code   => tbl_data(cnt).message_code
            ,p_message_global => tbl_data(cnt).message_global
            ,p_message        => tbl_data(cnt).message
            ,p_language       => v_language
            ,p_user_name      => v_user_name
            ,x_return_status  => v_return_status
            ,x_msg_error      => v_mesg_error
            );
        EXCEPTION
          WHEN others THEN
            v_mesg_error := 'Error llamando al procedimiento '        ||
                            'XX_MESSAGES_PKG.CREATE_UPDATE_MESSAGE. ' ||
                             SQLERRM                                  ||
                             '.';
        END;
        IF v_return_status = 'S' THEN
           v_cnt_success := NVL(v_cnt_success,0)+1;
        ELSE
           v_cnt_error := NVL(v_cnt_error,0)+1;
           dbms_output.put_line(SUBSTR('Mensaje: '||v_mesg_error,1,250));
        END IF;
    END LOOP;
    dbms_output.put_line('=====================================================================');
    dbms_output.put_line('Cant. de mensajes procesados..............: '||TO_CHAR(NVL(v_cnt,0)));
    dbms_output.put_line('Cant. de mensajes procesados con exito....: '||TO_CHAR(NVL(v_cnt_success,0)));
    dbms_output.put_line('Cant. de mensajes procesados con error....: '||TO_CHAR(NVL(v_cnt_error,0)));
  END process;
BEGIN
  add_tbl('FLA_PROPERTY_INT','XX_FLA_PROPERTY_GEN'                    ,'N','Error General en la ejecución de la integración. #1#.');
  add_tbl('FLA_PROPERTY_INT','XX_FLA_PROPERTY_INIT'                   ,'N','Error inicializando datos globales #1#.');
  add_tbl('FLA_PROPERTY_INT','ITEMS_GROUP_FOUND'                      ,'N','Error buscando los items del grupo de items Id #1#. #2#.');
  add_tbl('FLA_PROPERTY_INT','ITEMS_GROUP_NOT_FOUND'                  ,'N','No se encontraron los items del grupo de items Id #1#.');
  add_tbl('FLA_PROPERTY_INT','ITEMS_FOUND'                            ,'N','Error buscando los items  #1#. #2#.');
  add_tbl('FLA_PROPERTY_INT','XX_FLA_ITEMS_SEQ'                       ,'N','Error buscando la secuencia xx_fla_items_s #1#.');
  add_tbl('FLA_PROPERTY_INT','ITEM_PRICES_FOUND'                      ,'N','Error buscando los precios de items  #1#. #2#.');
  add_tbl('FLA_PROPERTY_INT','XX_FLA_ITEM_PRICES_SEQ'                 ,'N','Error buscando la secuencia xx_fla_item_prices_s #1#.');
  add_tbl('FLA_PROPERTY_INT','P_ITEM_PRICES_REQ'                      ,'N','Lista de precios requerida.');
  add_tbl('FLA_PROPERTY_INT','ITEM_FOUND'                             ,'N','Error buscando el item  #1#. #2#.');
  add_tbl('FLA_PROPERTY_INT','ITEM_NOT_FOUND'                         ,'N','No se encontraro el item #1#.');
  add_tbl('FLA_PROPERTY_INT','XX_FLA_ITEM_PRICES_INSERT'              ,'N','Error insertando los items de precio #1#.');
  add_tbl('FLA_PROPERTY_INT','XX_FLA_ITEM_PRICES_UPDATE'              ,'N','Error actualizando el item de precio #1#.');
  add_tbl('FLA_PROPERTY_INT','P_ITEM_REQ'                             ,'N','Lista de items requerido.');
  add_tbl('FLA_PROPERTY_INT','XX_FLA_ITEMS_INSERT'                    ,'N','Error insertando los items #1#.');
  add_tbl('FLA_PROPERTY_INT','XX_FLA_ITEMS_UPDATE'                    ,'N','Error actualizando el item #1#.');
  add_tbl('FLA_PROPERTY_INT','XX_FLA_SALES_SEQ'                       ,'N','Error buscando la secuencia xx_fla_sales_s #1#.');
  add_tbl('FLA_PROPERTY_INT','P_SALES_REQ'                            ,'N','Las ventas son requeridas.');
  add_tbl('FLA_PROPERTY_INT','XX_FLA_SALES_INSERT'                    ,'N','Error insertando las ventas #1#.');
  add_tbl('FLA_PROPERTY_INT','XX_FLA_SALES_UPDATE'                    ,'N','Error actualizando las ventas #1#.');
  add_tbl('FLA_PROPERTY_INT','XX_FLA_SALES_TAXES_SEQ'                 ,'N','Error buscando la secuencia xx_fla_sales_taxes_s #1#.');
  add_tbl('FLA_PROPERTY_INT','P_SALES_TAXES_REQ'                      ,'N','Los impuestos de ventas son requeridas.');
  add_tbl('FLA_PROPERTY_INT','XX_FLA_SALES_TAXES_INSERT'              ,'N','Error insertando los impuestos de las ventas #1#.');
  add_tbl('FLA_PROPERTY_INT','XX_FLA_SALES_TAXES_UPDATE'              ,'N','Error actualizando los impuestos de las ventas #1#.');
  add_tbl('FLA_PROPERTY_INT','XX_FLA_INDEX_HISTORY_LINES_SEQ'         ,'N','Error buscando la secuencia xx_fla_index_history_lines_s #1#.');
  add_tbl('FLA_PROPERTY_INT','P_INDEX_HISTORY_LINES_REQ'              ,'N','Los indices son requeridas.');
  add_tbl('FLA_PROPERTY_INT','XX_FLA_INDEX_HISTORY_LINES_INSERT'      ,'N','Error insertando los indices #1#.');
  add_tbl('FLA_PROPERTY_INT','XX_FLA_SALES_TAXES_UPDATE'              ,'N','Error actualizando los indices #1#.');



  process;
END;
/

COMMIT;

PROMPT =====================================================================
PROMPT Creando los tipos de lookups

DECLARE
  TYPE r_data IS RECORD(lookup_type_code VARCHAR2(100)
                       ,lookup_type_name VARCHAR2(240)
                       ,enabled_flag     VARCHAR2(1)
                       ,display_flag     VARCHAR2(1)
                       );
  TYPE t_data IS TABLE OF r_data INDEX BY BINARY_INTEGER;
  tbl_data t_data;
  PROCEDURE add_tbl(p_lookup_type_code IN VARCHAR2
                   ,p_lookup_type_name IN VARCHAR2
                   ,p_enabled_flag     IN VARCHAR2
                   ,p_display_flag     IN VARCHAR2
                   )
  IS
    v_cnt_tbl NUMBER(18);
  BEGIN
    v_cnt_tbl := tbl_data.last;
    v_cnt_tbl := NVL(v_cnt_tbl,0) + 1;
    tbl_data(v_cnt_tbl).lookup_type_code := UPPER(TRIM(p_lookup_type_code));
    tbl_data(v_cnt_tbl).lookup_type_name := UPPER(TRIM(p_lookup_type_name));
    tbl_data(v_cnt_tbl).enabled_flag     := TRIM(p_enabled_flag);
    tbl_data(v_cnt_tbl).display_flag     := TRIM(p_display_flag);
  END add_tbl;
  PROCEDURE process
  IS
    v_language      VARCHAR2(30);
    v_user_name     VARCHAR2(64);
    v_return_status VARCHAR2(1);
    v_cnt           NUMBER(18);
    v_cnt_success   NUMBER(18);
    v_cnt_error     NUMBER(18);
    v_mesg_error    VARCHAR2(32767);
  BEGIN
    v_language  := 'ESA';
    v_user_name := 'gustavo.iturburu@oracle.com';
    FOR cnt IN tbl_data.first..tbl_data.last LOOP
        dbms_output.put_line('---------------------------------------------------------------------');
        dbms_output.put_line(SUBSTR('Tipo de lookup: '||tbl_data(cnt).lookup_type_code,1,250));
        v_return_status := NULL;
        v_mesg_error    := NULL;
        v_cnt           := NVL(v_cnt,0)+1;
        BEGIN
          xx_lookup_pkg.create_update_type
            (p_lookup_type_code => tbl_data(cnt).lookup_type_code
            ,p_lookup_type_name => tbl_data(cnt).lookup_type_name
            ,p_enabled_flag     => tbl_data(cnt).enabled_flag
            ,p_display_flag     => tbl_data(cnt).display_flag
            ,p_user_name        => v_user_name
            ,x_return_status    => v_return_status
            ,x_msg_error        => v_mesg_error
            );
        EXCEPTION
          WHEN others THEN
            v_mesg_error := 'Error llamando al procedimiento '   ||
                            'XX_LOOKUP_PKG.CREATE_UPDATE_TYPE. ' ||
                             SQLERRM                             ||
                             '.';
        END;
        IF v_return_status = 'S' THEN
           v_cnt_success := NVL(v_cnt_success,0)+1;
        ELSE
           v_cnt_error := NVL(v_cnt_error,0)+1;
           dbms_output.put_line(SUBSTR('Mensaje: '||v_mesg_error,1,250));
        END IF;
    END LOOP;
    dbms_output.put_line('=====================================================================');
    dbms_output.put_line('Cant. de tipos de lookups procesados..............: '||TO_CHAR(NVL(v_cnt,0)));
    dbms_output.put_line('Cant. de tipos de lookups procesados con exito....: '||TO_CHAR(NVL(v_cnt_success,0)));
    dbms_output.put_line('Cant. de tipos de lookups procesados con error....: '||TO_CHAR(NVL(v_cnt_error,0)));
  END process;
BEGIN
	NULL;
  process;
END;
/

PROMPT =====================================================================
PROMPT Creando los codigos de lookups

DECLARE
  TYPE r_data IS RECORD(lookup_type_code  VARCHAR2(100)
                       ,lookup_value_code VARCHAR2(100)
                       ,enabled_flag      VARCHAR2(1)
                       ,start_date_active DATE
                       ,end_date_active   DATE
                       ,tag               VARCHAR2(150)
                       ,lookup_value_name VARCHAR2(240)
                       ,description       VARCHAR2(240)
                       );
  TYPE t_data IS TABLE OF r_data INDEX BY BINARY_INTEGER;
  tbl_data t_data;
  PROCEDURE add_tbl(p_lookup_type_code  IN VARCHAR2
                   ,p_lookup_value_code IN VARCHAR2
                   ,p_enabled_flag      IN VARCHAR2
                   ,p_start_date_active IN DATE
                   ,p_end_date_active   IN DATE
                   ,p_tag               IN VARCHAR2
                   ,p_lookup_value_name IN VARCHAR2
                   ,p_description       IN VARCHAR2
                   )
  IS
    v_cnt_tbl NUMBER(18);
  BEGIN
    v_cnt_tbl := tbl_data.last;
    v_cnt_tbl := NVL(v_cnt_tbl,0) + 1;
    tbl_data(v_cnt_tbl).lookup_type_code  := UPPER(TRIM(p_lookup_type_code));
    tbl_data(v_cnt_tbl).lookup_value_code := UPPER(TRIM(p_lookup_value_code));
    tbl_data(v_cnt_tbl).enabled_flag      := TRIM(p_enabled_flag);
    tbl_data(v_cnt_tbl).start_date_active := p_start_date_active;
    tbl_data(v_cnt_tbl).end_date_active   := p_end_date_active;
    tbl_data(v_cnt_tbl).tag               := TRIM(p_tag);
    tbl_data(v_cnt_tbl).lookup_value_name := TRIM(p_lookup_value_name);
    tbl_data(v_cnt_tbl).description       := TRIM(p_description);
  END add_tbl;
  PROCEDURE process
  IS
    v_language      VARCHAR2(30);
    v_user_name     VARCHAR2(64);
    v_return_status VARCHAR2(1);
    v_cnt           NUMBER(18);
    v_cnt_success   NUMBER(18);
    v_cnt_error     NUMBER(18);
    v_mesg_error    VARCHAR2(32767);
  BEGIN
    v_language  := 'ESA';
    v_user_name := 'gustavo.iturburu@oracle.com';
    FOR cnt IN tbl_data.first..tbl_data.last LOOP
        dbms_output.put_line('---------------------------------------------------------------------');
        dbms_output.put_line(SUBSTR('Codigo de lookup: '||tbl_data(cnt).lookup_type_code||'  -  '||tbl_data(cnt).lookup_value_code,1,250));
        v_return_status := NULL;
        v_mesg_error    := NULL;
        v_cnt           := NVL(v_cnt,0)+1;
        BEGIN
          xx_lookup_pkg.create_update_value
            (p_lookup_type_code  => tbl_data(cnt).lookup_type_code
            ,p_lookup_value_code => tbl_data(cnt).lookup_value_code
            ,p_enabled_flag      => tbl_data(cnt).enabled_flag
            ,p_start_date_active => tbl_data(cnt).start_date_active
            ,p_end_date_active   => tbl_data(cnt).end_date_active
            ,p_tag               => tbl_data(cnt).tag
            ,p_lookup_value_name => tbl_data(cnt).lookup_value_name
            ,p_description       => tbl_data(cnt).description
            ,p_language          => v_language
            ,p_user_name         => v_user_name
            ,x_return_status     => v_return_status
            ,x_msg_error         => v_mesg_error
            );
        EXCEPTION
          WHEN others THEN
            v_mesg_error := 'Error llamando al procedimiento '    ||
                            'XX_LOOKUP_PKG.CREATE_UPDATE_VALUE. ' ||
                             SQLERRM                              ||
                             '.';
        END;
        IF v_return_status = 'S' THEN
           v_cnt_success := NVL(v_cnt_success,0)+1;
        ELSE
           v_cnt_error := NVL(v_cnt_error,0)+1;
           dbms_output.put_line(SUBSTR('Mensaje: '||v_mesg_error,1,250));
        END IF;
    END LOOP;
    dbms_output.put_line('=====================================================================');
    dbms_output.put_line('Cant. de codigos de lookups procesados..............: '||TO_CHAR(NVL(v_cnt,0)));
    dbms_output.put_line('Cant. de codigos de lookups procesados con exito....: '||TO_CHAR(NVL(v_cnt_success,0)));
    dbms_output.put_line('Cant. de codigos de lookups procesados con error....: '||TO_CHAR(NVL(v_cnt_error,0)));
  END process;
BEGIN
	NULL;
  process;
END;
/

PROMPT =====================================================================
PROMPT Creando Customizaciones

DECLARE
  TYPE r_cus_hdr IS RECORD(custom_code  VARCHAR2(100)
                          ,version      VARCHAR2(30)
                          ,description  VARCHAR2(2000)
                          ,enabled_flag VARCHAR2(1)
                          ,team_members VARCHAR2(2000)
                          );
  TYPE t_cus_hdr IS TABLE OF r_cus_hdr INDEX BY BINARY_INTEGER;
  tbl_cus_hdr t_cus_hdr;
  TYPE r_cus_his IS RECORD(custom_code  VARCHAR2(100)
                          ,version      VARCHAR2(30)
                          ,history_date DATE
                          ,title        VARCHAR2(2000)
                          ,authors      VARCHAR2(2000)
                          ,detail       VARCHAR2(4000)
                          );
  TYPE t_cus_his IS TABLE OF r_cus_his INDEX BY BINARY_INTEGER;
  tbl_cus_his t_cus_his;
  TYPE r_cus_doc IS RECORD(custom_code     VARCHAR2(100)
                          ,version         VARCHAR2(30)
                          ,doc_type_code   VARCHAR2(30)
                          ,file_name       VARCHAR2(200)
                          ,doc_date        DATE
                          ,description     VARCHAR2(2000)
                          ,enabled_flag    VARCHAR2(1)
                          ,reference1      VARCHAR2(2000)
                          ,reference2      VARCHAR2(2000)
                          ,reference3      VARCHAR2(2000)
                          ,reference4      VARCHAR2(2000)
                          ,doc_data_format VARCHAR2(30)
                          );
  TYPE t_cus_doc IS TABLE OF r_cus_doc INDEX BY BINARY_INTEGER;
  tbl_cus_doc t_cus_doc;
  TYPE r_cus_obj IS RECORD(custom_code         VARCHAR2(100)
                          ,sequence_num        NUMBER(6)
                          ,object_type_level1  VARCHAR2(30)
                          ,object_type_level2  VARCHAR2(30)
                          ,object_type_level3  VARCHAR2(30)
                          ,object_type_level4  VARCHAR2(30)
                          ,object_type_level5  VARCHAR2(30)
                          ,object_type_level6  VARCHAR2(30)
                          ,object_value1       VARCHAR2(2000)
                          ,object_value2       VARCHAR2(2000)
                          ,object_value3       VARCHAR2(2000)
                          ,object_value4       VARCHAR2(2000)
                          ,object_value5       VARCHAR2(2000)
                          ,object_value6       VARCHAR2(2000)
                          ,object_value7       VARCHAR2(2000)
                          ,object_value8       VARCHAR2(2000)
                          ,inactive_date       DATE
                          ,service_reference   VARCHAR2(200)
                          ,extra_information1  VARCHAR2(2000)
                          ,extra_information2  VARCHAR2(2000)
                          ,extra_information3  VARCHAR2(2000)
                          ,extra_information4  VARCHAR2(2000)
                          ,extra_information5  VARCHAR2(2000)
                          ,extra_information6  VARCHAR2(2000)
                          ,extra_information7  VARCHAR2(2000)
                          ,extra_information8  VARCHAR2(2000)
                          ,extra_information9  VARCHAR2(2000)
                          ,extra_information10 VARCHAR2(2000)
                          );
  TYPE t_cus_obj IS TABLE OF r_cus_obj INDEX BY BINARY_INTEGER;
  tbl_cus_obj t_cus_obj;
  TYPE r_cus_prm IS RECORD(custom_code      VARCHAR2(100)
                          ,param_type       VARCHAR2(100)
                          ,param_code       VARCHAR2(100)
                          ,param_name       VARCHAR2(240)
                          ,enabled_flag     VARCHAR2(1)
                          ,environment_name VARCHAR2(100)
                          ,value_char       VARCHAR2(4000)
                          ,value_num        NUMBER
                          ,value_date       DATE
                          );
  TYPE t_cus_prm IS TABLE OF r_cus_prm INDEX BY BINARY_INTEGER;
  tbl_cus_prm t_cus_prm;
  PROCEDURE add_cus_hdr(p_custom_code  IN      VARCHAR2
                       ,p_version      IN      VARCHAR2
                       ,p_description  IN      VARCHAR2
                       ,p_enabled_flag IN      VARCHAR2
                       ,p_team_members IN      VARCHAR2
                       )
  IS
    v_cnt_tbl NUMBER(18);
  BEGIN
    v_cnt_tbl := tbl_cus_hdr.last;
    v_cnt_tbl := NVL(v_cnt_tbl,0) + 1;
    tbl_cus_hdr(v_cnt_tbl).custom_code  := UPPER(TRIM(p_custom_code));
    tbl_cus_hdr(v_cnt_tbl).version      := TRIM(p_version);
    tbl_cus_hdr(v_cnt_tbl).description  := TRIM(p_description);
    tbl_cus_hdr(v_cnt_tbl).enabled_flag := UPPER(TRIM(p_enabled_flag));
    tbl_cus_hdr(v_cnt_tbl).team_members := TRIM(p_team_members);
  END add_cus_hdr;
  PROCEDURE add_cus_his(p_custom_code  IN      VARCHAR2
                       ,p_version      IN      VARCHAR2
                       ,p_history_date IN      DATE
                       ,p_title        IN      VARCHAR2
                       ,p_authors      IN      VARCHAR2
                       ,p_detail       IN      VARCHAR2
                       )
  IS
    v_cnt_tbl NUMBER(18);
  BEGIN
    v_cnt_tbl := tbl_cus_his.last;
    v_cnt_tbl := NVL(v_cnt_tbl,0) + 1;
    tbl_cus_his(v_cnt_tbl).custom_code  := UPPER(TRIM(p_custom_code));
    tbl_cus_his(v_cnt_tbl).version      := TRIM(p_version);
    tbl_cus_his(v_cnt_tbl).history_date := p_history_date;
    tbl_cus_his(v_cnt_tbl).title        := TRIM(p_title);
    tbl_cus_his(v_cnt_tbl).authors      := TRIM(p_authors);
    tbl_cus_his(v_cnt_tbl).detail       := TRIM(p_detail);
  END add_cus_his;
  PROCEDURE add_cus_doc(p_custom_code     IN      VARCHAR2
                       ,p_doc_type_code   IN      VARCHAR2
                       ,p_file_name       IN      VARCHAR2
                       ,p_version         IN      VARCHAR2
                       ,p_doc_date        IN      DATE
                       ,p_description     IN      VARCHAR2
                       ,p_enabled_flag    IN      VARCHAR2
                       ,p_reference1      IN      VARCHAR2
                       ,p_reference2      IN      VARCHAR2
                       ,p_reference3      IN      VARCHAR2
                       ,p_reference4      IN      VARCHAR2
                       ,p_doc_data_format IN      VARCHAR2
                       )
  IS
    v_cnt_tbl NUMBER(18);
  BEGIN
    v_cnt_tbl := tbl_cus_doc.last;
    v_cnt_tbl := NVL(v_cnt_tbl,0) + 1;
    tbl_cus_doc(v_cnt_tbl).custom_code     := UPPER(TRIM(p_custom_code));
    tbl_cus_doc(v_cnt_tbl).doc_type_code   := UPPER(TRIM(p_doc_type_code));
    tbl_cus_doc(v_cnt_tbl).file_name       := TRIM(p_file_name);
    tbl_cus_doc(v_cnt_tbl).version         := TRIM(p_version);
    tbl_cus_doc(v_cnt_tbl).doc_date        := p_doc_date;
    tbl_cus_doc(v_cnt_tbl).description     := TRIM(p_description);
    tbl_cus_doc(v_cnt_tbl).enabled_flag    := UPPER(TRIM(p_enabled_flag));
    tbl_cus_doc(v_cnt_tbl).reference1      := TRIM(p_reference1);
    tbl_cus_doc(v_cnt_tbl).reference2      := TRIM(p_reference2);
    tbl_cus_doc(v_cnt_tbl).reference3      := TRIM(p_reference3);
    tbl_cus_doc(v_cnt_tbl).reference4      := TRIM(p_reference4);
    tbl_cus_doc(v_cnt_tbl).doc_data_format := UPPER(TRIM(p_doc_data_format));
  END add_cus_doc;
  PROCEDURE add_cus_obj(p_custom_code         IN      VARCHAR2
                       ,p_sequence_num        IN      NUMBER
                       ,p_object_type_level1  IN      VARCHAR2
                       ,p_object_type_level2  IN      VARCHAR2 DEFAULT NULL
                       ,p_object_type_level3  IN      VARCHAR2 DEFAULT NULL
                       ,p_object_type_level4  IN      VARCHAR2 DEFAULT NULL
                       ,p_object_type_level5  IN      VARCHAR2 DEFAULT NULL
                       ,p_object_type_level6  IN      VARCHAR2 DEFAULT NULL
                       ,p_object_value1       IN      VARCHAR2
                       ,p_object_value2       IN      VARCHAR2 DEFAULT NULL
                       ,p_object_value3       IN      VARCHAR2 DEFAULT NULL
                       ,p_object_value4       IN      VARCHAR2 DEFAULT NULL
                       ,p_object_value5       IN      VARCHAR2 DEFAULT NULL
                       ,p_object_value6       IN      VARCHAR2 DEFAULT NULL
                       ,p_object_value7       IN      VARCHAR2 DEFAULT NULL
                       ,p_object_value8       IN      VARCHAR2 DEFAULT NULL
                       ,p_inactive_date       IN      DATE
                       ,p_service_reference   IN      VARCHAR2
                       ,p_extra_information1  IN      VARCHAR2 DEFAULT NULL
                       ,p_extra_information2  IN      VARCHAR2 DEFAULT NULL
                       ,p_extra_information3  IN      VARCHAR2 DEFAULT NULL
                       ,p_extra_information4  IN      VARCHAR2 DEFAULT NULL
                       ,p_extra_information5  IN      VARCHAR2 DEFAULT NULL
                       ,p_extra_information6  IN      VARCHAR2 DEFAULT NULL
                       ,p_extra_information7  IN      VARCHAR2 DEFAULT NULL
                       ,p_extra_information8  IN      VARCHAR2 DEFAULT NULL
                       ,p_extra_information9  IN      VARCHAR2 DEFAULT NULL
                       ,p_extra_information10 IN      VARCHAR2 DEFAULT NULL
                       )
  IS
    v_cnt_tbl NUMBER(18);
  BEGIN
    v_cnt_tbl := tbl_cus_obj.last;
    v_cnt_tbl := NVL(v_cnt_tbl,0) + 1;
    tbl_cus_obj(v_cnt_tbl).custom_code         := UPPER(TRIM(p_custom_code));
    tbl_cus_obj(v_cnt_tbl).sequence_num        := p_sequence_num;
    tbl_cus_obj(v_cnt_tbl).object_type_level1  := UPPER(TRIM(p_object_type_level1));
    tbl_cus_obj(v_cnt_tbl).object_type_level2  := UPPER(TRIM(p_object_type_level2));
    tbl_cus_obj(v_cnt_tbl).object_type_level3  := UPPER(TRIM(p_object_type_level3));
    tbl_cus_obj(v_cnt_tbl).object_type_level4  := UPPER(TRIM(p_object_type_level4));
    tbl_cus_obj(v_cnt_tbl).object_type_level5  := UPPER(TRIM(p_object_type_level5));
    tbl_cus_obj(v_cnt_tbl).object_type_level6  := UPPER(TRIM(p_object_type_level6));
    tbl_cus_obj(v_cnt_tbl).object_value1       := TRIM(p_object_value1);
    tbl_cus_obj(v_cnt_tbl).object_value2       := TRIM(p_object_value2);
    tbl_cus_obj(v_cnt_tbl).object_value3       := TRIM(p_object_value3);
    tbl_cus_obj(v_cnt_tbl).object_value4       := TRIM(p_object_value4);
    tbl_cus_obj(v_cnt_tbl).object_value5       := TRIM(p_object_value5);
    tbl_cus_obj(v_cnt_tbl).object_value6       := TRIM(p_object_value6);
    tbl_cus_obj(v_cnt_tbl).object_value7       := TRIM(p_object_value7);
    tbl_cus_obj(v_cnt_tbl).object_value8       := TRIM(p_object_value8);
    tbl_cus_obj(v_cnt_tbl).inactive_date       := p_inactive_date;
    tbl_cus_obj(v_cnt_tbl).service_reference   := TRIM(p_service_reference);
    tbl_cus_obj(v_cnt_tbl).extra_information1  := TRIM(p_extra_information1);
    tbl_cus_obj(v_cnt_tbl).extra_information2  := TRIM(p_extra_information2);
    tbl_cus_obj(v_cnt_tbl).extra_information3  := TRIM(p_extra_information3);
    tbl_cus_obj(v_cnt_tbl).extra_information4  := TRIM(p_extra_information4);
    tbl_cus_obj(v_cnt_tbl).extra_information5  := TRIM(p_extra_information5);
    tbl_cus_obj(v_cnt_tbl).extra_information6  := TRIM(p_extra_information6);
    tbl_cus_obj(v_cnt_tbl).extra_information7  := TRIM(p_extra_information7);
    tbl_cus_obj(v_cnt_tbl).extra_information8  := TRIM(p_extra_information8);
    tbl_cus_obj(v_cnt_tbl).extra_information9  := TRIM(p_extra_information9);
    tbl_cus_obj(v_cnt_tbl).extra_information10 := TRIM(p_extra_information10);
  END add_cus_obj;
  PROCEDURE add_cus_prm(p_custom_code      IN      VARCHAR2
                       ,p_param_type       IN      VARCHAR2
                       ,p_param_code       IN      VARCHAR2
                       ,p_param_name       IN      VARCHAR2
                       ,p_enabled_flag     IN      VARCHAR2
                       ,p_environment_name IN      VARCHAR2 DEFAULT NULL
                       ,p_value_char       IN      VARCHAR2 DEFAULT NULL
                       ,p_value_num        IN      NUMBER   DEFAULT NULL
                       ,p_value_date       IN      DATE     DEFAULT NULL
                       )
  IS
    v_cnt_tbl NUMBER(18);
  BEGIN
    v_cnt_tbl := tbl_cus_prm.last;
    v_cnt_tbl := NVL(v_cnt_tbl,0) + 1;
    tbl_cus_prm(v_cnt_tbl).custom_code      := UPPER(TRIM(p_custom_code));
    tbl_cus_prm(v_cnt_tbl).param_type       := UPPER(TRIM(p_param_type));
    tbl_cus_prm(v_cnt_tbl).param_code       := UPPER(TRIM(p_param_code));
    tbl_cus_prm(v_cnt_tbl).param_name       := TRIM(p_param_name);
    tbl_cus_prm(v_cnt_tbl).enabled_flag     := UPPER(TRIM(p_enabled_flag));
    tbl_cus_prm(v_cnt_tbl).environment_name := TRIM(p_environment_name);
    tbl_cus_prm(v_cnt_tbl).value_char       := TRIM(p_value_char);
    tbl_cus_prm(v_cnt_tbl).value_num        := p_value_num;
    tbl_cus_prm(v_cnt_tbl).value_date       := p_value_date;
  END add_cus_prm;
  PROCEDURE process
  IS
    v_language                 VARCHAR2(30);
    v_user_name                VARCHAR2(64);
    v_cus_header_id            NUMBER(18);
    v_cus_history_id           NUMBER(18);
    v_cus_doc_id               NUMBER(18);
    v_cus_object_id            NUMBER(18);
    v_cus_param_id             NUMBER(18);
    v_object_type_level_concat VARCHAR2(32767);
    v_object_value_concat      VARCHAR2(32767);
    v_return_status            VARCHAR2(1);
    v_cnt                      NUMBER(18);
    v_cnt_success              NUMBER(18);
    v_cnt_error                NUMBER(18);
    v_mesg_error               VARCHAR2(32767);
  BEGIN
    v_language    := 'ESA';
    v_user_name   := 'gustavo.iturburu@oracle.com';
    v_cnt         := 0;
    v_cnt_success := 0;
    v_cnt_error   := 0;
    FOR cnt_cus_hdr IN tbl_cus_hdr.first..tbl_cus_hdr.last LOOP
        dbms_output.put_line('---------------------------------------------------------------------');
        dbms_output.put_line('Customizacion: '||tbl_cus_hdr(cnt_cus_hdr).custom_code);
        v_cus_header_id := NULL;
        v_return_status := NULL;
        v_mesg_error    := NULL;
        v_cnt           := NVL(v_cnt,0)+1;
        BEGIN
          xx_customs_pkg.header_create_update
            (p_custom_code   => tbl_cus_hdr(cnt_cus_hdr).custom_code
            ,p_version       => tbl_cus_hdr(cnt_cus_hdr).version
            ,p_description   => tbl_cus_hdr(cnt_cus_hdr).description
            ,p_enabled_flag  => tbl_cus_hdr(cnt_cus_hdr).enabled_flag
            ,p_team_members  => tbl_cus_hdr(cnt_cus_hdr).team_members
            ,p_language      => v_language
            ,p_user_name     => v_user_name
            ,x_cus_header_id => v_cus_header_id
            ,x_return_status => v_return_status
            ,x_msg_error     => v_mesg_error
            );
        EXCEPTION
          WHEN others THEN
            v_mesg_error := 'Error llamando al procedimiento '      ||
                            'XX_CUSTOMS_PKG.HEADER_CREATE_UPDATE. ' ||
                             SQLERRM                                ||
                             '.';
        END;
        IF v_return_status = 'S' THEN
           v_cnt_success := NVL(v_cnt_success,0)+1;
        ELSE
           v_cnt_error := NVL(v_cnt_error,0)+1;
           dbms_output.put_line(SUBSTR('Mensaje: '||v_mesg_error,1,250));
        END IF;
    END LOOP;
    dbms_output.put_line('---------------------------------------------------------------------');
    dbms_output.put_line('Cant. de customizaciones procesadas..............: '||TO_CHAR(NVL(v_cnt,0)));
    dbms_output.put_line('Cant. de customizaciones procesadas con exito....: '||TO_CHAR(NVL(v_cnt_success,0)));
    dbms_output.put_line('Cant. de customizaciones procesadas con error....: '||TO_CHAR(NVL(v_cnt_error,0)));
    v_cnt         := 0;
    v_cnt_success := 0;
    v_cnt_error   := 0;
    FOR cnt_cus_his IN tbl_cus_his.first..tbl_cus_his.last LOOP
        dbms_output.put_line('---------------------------------------------------------------------');
        dbms_output.put_line('Customizacion: '||tbl_cus_his(cnt_cus_his).custom_code||
                             ' - Version: '   ||tbl_cus_his(cnt_cus_his).version
                            );
        v_cus_history_id := NULL;
        v_return_status  := NULL;
        v_mesg_error     := NULL;
        v_cnt            := NVL(v_cnt,0)+1;
        BEGIN
          xx_customs_pkg.history_create_update
            (p_custom_code    => tbl_cus_his(cnt_cus_his).custom_code
            ,p_version        => tbl_cus_his(cnt_cus_his).version
            ,p_history_date   => tbl_cus_his(cnt_cus_his).history_date
            ,p_title          => tbl_cus_his(cnt_cus_his).title
            ,p_authors        => tbl_cus_his(cnt_cus_his).authors
            ,p_detail         => tbl_cus_his(cnt_cus_his).detail
            ,p_language       => v_language
            ,p_user_name      => v_user_name
            ,x_cus_history_id => v_cus_history_id
            ,x_return_status  => v_return_status
            ,x_msg_error      => v_mesg_error
            );
        EXCEPTION
          WHEN others THEN
            v_mesg_error := 'Error llamando al procedimiento '       ||
                            'XX_CUSTOMS_PKG.HISTORY_CREATE_UPDATE. ' ||
                             SQLERRM                                 ||
                             '.';
        END;
        IF v_return_status = 'S' THEN
           v_cnt_success := NVL(v_cnt_success,0)+1;
        ELSE
           v_cnt_error := NVL(v_cnt_error,0)+1;
           dbms_output.put_line(SUBSTR('Mensaje: '||v_mesg_error,1,250));
        END IF;
    END LOOP;
    dbms_output.put_line('---------------------------------------------------------------------');
    dbms_output.put_line('Cant. de actualizaciones procesadas..............: '||TO_CHAR(NVL(v_cnt,0)));
    dbms_output.put_line('Cant. de actualizaciones procesadas con exito....: '||TO_CHAR(NVL(v_cnt_success,0)));
    dbms_output.put_line('Cant. de actualizaciones procesadas con error....: '||TO_CHAR(NVL(v_cnt_error,0)));
    v_cnt         := 0;
    v_cnt_success := 0;
    v_cnt_error   := 0;
    IF NVL(tbl_cus_doc.count,0) > 0 THEN
       FOR cnt_cus_doc IN tbl_cus_doc.first..tbl_cus_doc.last LOOP
           dbms_output.put_line('---------------------------------------------------------------------');
           dbms_output.put_line('Customizacion: '||tbl_cus_doc(cnt_cus_doc).custom_code  ||
                                ' - Tipo Doc.: ' ||tbl_cus_doc(cnt_cus_doc).doc_type_code||
                                ' - Doc.: '      ||tbl_cus_doc(cnt_cus_doc).file_name    ||
                                ' - Version: '   ||tbl_cus_doc(cnt_cus_doc).version
                               );
           v_cus_doc_id    := NULL;
           v_return_status := NULL;
           v_mesg_error    := NULL;
           v_cnt           := NVL(v_cnt,0)+1;
           BEGIN
             xx_customs_pkg.doc_create_update
               (p_custom_code     => tbl_cus_doc(cnt_cus_doc).custom_code
               ,p_doc_type_code   => tbl_cus_doc(cnt_cus_doc).doc_type_code
               ,p_file_name       => tbl_cus_doc(cnt_cus_doc).file_name
               ,p_version         => tbl_cus_doc(cnt_cus_doc).version
               ,p_doc_date        => tbl_cus_doc(cnt_cus_doc).doc_date
               ,p_description     => tbl_cus_doc(cnt_cus_doc).description
               ,p_enabled_flag    => tbl_cus_doc(cnt_cus_doc).enabled_flag
               ,p_reference1      => tbl_cus_doc(cnt_cus_doc).reference1
               ,p_reference2      => tbl_cus_doc(cnt_cus_doc).reference2
               ,p_reference3      => tbl_cus_doc(cnt_cus_doc).reference3
               ,p_reference4      => tbl_cus_doc(cnt_cus_doc).reference4
               ,p_doc_data_format => tbl_cus_doc(cnt_cus_doc).doc_data_format
               ,p_language        => v_language
               ,p_user_name       => v_user_name
               ,x_cus_doc_id      => v_cus_doc_id
               ,x_return_status   => v_return_status
               ,x_msg_error       => v_mesg_error
               );
           EXCEPTION
             WHEN others THEN
               v_mesg_error := 'Error llamando al procedimiento '   ||
                               'XX_CUSTOMS_PKG.DOC_CREATE_UPDATE. ' ||
                                SQLERRM                             ||
                                '.';
           END;
           IF v_return_status = 'S' THEN
              v_cnt_success := NVL(v_cnt_success,0)+1;
           ELSE
              v_cnt_error := NVL(v_cnt_error,0)+1;
              dbms_output.put_line(SUBSTR('Mensaje: '||v_mesg_error,1,250));
           END IF;
       END LOOP;
    END IF;
    dbms_output.put_line('---------------------------------------------------------------------');
    dbms_output.put_line('Cant. de documentos procesadas..............: '||TO_CHAR(NVL(v_cnt,0)));
    dbms_output.put_line('Cant. de documentos procesados con exito....: '||TO_CHAR(NVL(v_cnt_success,0)));
    dbms_output.put_line('Cant. de documentos procesados con error....: '||TO_CHAR(NVL(v_cnt_error,0)));
    v_cnt         := 0;
    v_cnt_success := 0;
    v_cnt_error   := 0;
    IF NVL(tbl_cus_obj.count,0) > 0 THEN
       FOR cnt_cus_obj IN tbl_cus_obj.first..tbl_cus_obj.last LOOP
           v_object_type_level_concat := tbl_cus_obj(cnt_cus_obj).object_type_level1;
           IF tbl_cus_obj(cnt_cus_obj).object_type_level2 IS NOT NULL THEN
              v_object_type_level_concat := v_object_type_level_concat                   ||
                                            ' '                                          ||
                                            tbl_cus_obj(cnt_cus_obj).object_type_level2;
           END IF;
           IF tbl_cus_obj(cnt_cus_obj).object_type_level3 IS NOT NULL THEN
              v_object_type_level_concat := v_object_type_level_concat                   ||
                                            ' '                                          ||
                                            tbl_cus_obj(cnt_cus_obj).object_type_level3;
           END IF;
           IF tbl_cus_obj(cnt_cus_obj).object_type_level4 IS NOT NULL THEN
              v_object_type_level_concat := v_object_type_level_concat                   ||
                                            ' '                                          ||
                                            tbl_cus_obj(cnt_cus_obj).object_type_level4;
           END IF;
           IF tbl_cus_obj(cnt_cus_obj).object_type_level5 IS NOT NULL THEN
              v_object_type_level_concat := v_object_type_level_concat                   ||
                                            ' '                                          ||
                                            tbl_cus_obj(cnt_cus_obj).object_type_level5;
           END IF;
           IF tbl_cus_obj(cnt_cus_obj).object_type_level6 IS NOT NULL THEN
              v_object_type_level_concat := v_object_type_level_concat                   ||
                                            ' '                                          ||
                                            tbl_cus_obj(cnt_cus_obj).object_type_level6;
           END IF;
           v_object_value_concat := tbl_cus_obj(cnt_cus_obj).object_value1;
           IF tbl_cus_obj(cnt_cus_obj).object_value2 IS NOT NULL THEN
              v_object_value_concat := v_object_value_concat                   ||
                                       ' '                                     ||
                                       tbl_cus_obj(cnt_cus_obj).object_value2;
           END IF;
           IF tbl_cus_obj(cnt_cus_obj).object_value3 IS NOT NULL THEN
              v_object_value_concat := v_object_value_concat                   ||
                                       ' '                                     ||
                                       tbl_cus_obj(cnt_cus_obj).object_value3;
           END IF;
           IF tbl_cus_obj(cnt_cus_obj).object_value4 IS NOT NULL THEN
              v_object_value_concat := v_object_value_concat                   ||
                                       ' '                                     ||
                                       tbl_cus_obj(cnt_cus_obj).object_value4;
           END IF;
           IF tbl_cus_obj(cnt_cus_obj).object_value5 IS NOT NULL THEN
              v_object_value_concat := v_object_value_concat                   ||
                                       ' '                                     ||
                                       tbl_cus_obj(cnt_cus_obj).object_value5;
           END IF;
           IF tbl_cus_obj(cnt_cus_obj).object_value6 IS NOT NULL THEN
              v_object_value_concat := v_object_value_concat                   ||
                                       ' '                                     ||
                                       tbl_cus_obj(cnt_cus_obj).object_value6;
           END IF;
           IF tbl_cus_obj(cnt_cus_obj).object_value7 IS NOT NULL THEN
              v_object_value_concat := v_object_value_concat                   ||
                                       ' '                                     ||
                                       tbl_cus_obj(cnt_cus_obj).object_value7;
           END IF;
           IF tbl_cus_obj(cnt_cus_obj).object_value8 IS NOT NULL THEN
              v_object_value_concat := v_object_value_concat                   ||
                                       ' '                                     ||
                                       tbl_cus_obj(cnt_cus_obj).object_value8;
           END IF;
           dbms_output.put_line('---------------------------------------------------------------------');
           dbms_output.put_line('Customizacion: '||tbl_cus_obj(cnt_cus_obj).custom_code          ||
                                ' - Seq.: '      ||TO_CHAR(tbl_cus_obj(cnt_cus_obj).sequence_num)||
                                ' - Tipo: '      ||v_object_type_level_concat                    ||
                                ' - Objeto: '    ||v_object_value_concat
                               );
           v_cus_object_id := NULL;
           v_return_status := NULL;
           v_mesg_error    := NULL;
           v_cnt           := NVL(v_cnt,0)+1;
           BEGIN
             xx_customs_pkg.object_create_update
               (p_custom_code         => tbl_cus_obj(cnt_cus_obj).custom_code
               ,p_sequence_num        => tbl_cus_obj(cnt_cus_obj).sequence_num
               ,p_object_type_level1  => tbl_cus_obj(cnt_cus_obj).object_type_level1
               ,p_object_type_level2  => tbl_cus_obj(cnt_cus_obj).object_type_level2
               ,p_object_type_level3  => tbl_cus_obj(cnt_cus_obj).object_type_level3
               ,p_object_type_level4  => tbl_cus_obj(cnt_cus_obj).object_type_level4
               ,p_object_type_level5  => tbl_cus_obj(cnt_cus_obj).object_type_level5
               ,p_object_type_level6  => tbl_cus_obj(cnt_cus_obj).object_type_level6
               ,p_object_value1       => tbl_cus_obj(cnt_cus_obj).object_value1
               ,p_object_value2       => tbl_cus_obj(cnt_cus_obj).object_value2
               ,p_object_value3       => tbl_cus_obj(cnt_cus_obj).object_value3
               ,p_object_value4       => tbl_cus_obj(cnt_cus_obj).object_value4
               ,p_object_value5       => tbl_cus_obj(cnt_cus_obj).object_value5
               ,p_object_value6       => tbl_cus_obj(cnt_cus_obj).object_value6
               ,p_object_value7       => tbl_cus_obj(cnt_cus_obj).object_value7
               ,p_object_value8       => tbl_cus_obj(cnt_cus_obj).object_value8
               ,p_inactive_date       => tbl_cus_obj(cnt_cus_obj).inactive_date
               ,p_service_reference   => tbl_cus_obj(cnt_cus_obj).service_reference
               ,p_extra_information1  => tbl_cus_obj(cnt_cus_obj).extra_information1
               ,p_extra_information2  => tbl_cus_obj(cnt_cus_obj).extra_information2
               ,p_extra_information3  => tbl_cus_obj(cnt_cus_obj).extra_information3
               ,p_extra_information4  => tbl_cus_obj(cnt_cus_obj).extra_information4
               ,p_extra_information5  => tbl_cus_obj(cnt_cus_obj).extra_information5
               ,p_extra_information6  => tbl_cus_obj(cnt_cus_obj).extra_information6
               ,p_extra_information7  => tbl_cus_obj(cnt_cus_obj).extra_information7
               ,p_extra_information8  => tbl_cus_obj(cnt_cus_obj).extra_information8
               ,p_extra_information9  => tbl_cus_obj(cnt_cus_obj).extra_information9
               ,p_extra_information10 => tbl_cus_obj(cnt_cus_obj).extra_information10
               ,p_language            => v_language
               ,p_user_name           => v_user_name
               ,x_cus_object_id       => v_cus_object_id
               ,x_return_status       => v_return_status
               ,x_msg_error           => v_mesg_error
               );
           EXCEPTION
             WHEN others THEN
               v_mesg_error := 'Error llamando al procedimiento '      ||
                               'XX_CUSTOMS_PKG.OBJECT_CREATE_UPDATE. ' ||
                                SQLERRM                                ||
                                '.';
           END;
           IF v_return_status = 'S' THEN
              v_cnt_success := NVL(v_cnt_success,0)+1;
           ELSE
              v_cnt_error := NVL(v_cnt_error,0)+1;
              dbms_output.put_line(SUBSTR('Mensaje: '||v_mesg_error,1,250));
           END IF;
       END LOOP;
    END IF;
    dbms_output.put_line('---------------------------------------------------------------------');
    dbms_output.put_line('Cant. de objetos procesados..............: '||TO_CHAR(NVL(v_cnt,0)));
    dbms_output.put_line('Cant. de objetos procesados con exito....: '||TO_CHAR(NVL(v_cnt_success,0)));
    dbms_output.put_line('Cant. de objetos procesados con error....: '||TO_CHAR(NVL(v_cnt_error,0)));
    v_cnt         := 0;
    v_cnt_success := 0;
    v_cnt_error   := 0;
    IF NVL(tbl_cus_prm.count,0) > 0 THEN
       FOR cnt_cus_prm IN tbl_cus_prm.first..tbl_cus_prm.last LOOP
           dbms_output.put_line('---------------------------------------------------------------------');
           dbms_output.put_line('Customizacion: '       ||tbl_cus_prm(cnt_cus_prm).custom_code||
                                ' - Tipo parametro: '   ||tbl_cus_prm(cnt_cus_prm).param_type ||
                                ' - Codigo parametro: ' ||tbl_cus_prm(cnt_cus_prm).param_code
                               );
           v_cus_param_id  := NULL;
           v_return_status := NULL;
           v_mesg_error    := NULL;
           v_cnt           := NVL(v_cnt,0)+1;
           BEGIN
             xx_customs_pkg.param_create_update
               (p_custom_code      => tbl_cus_prm(cnt_cus_prm).custom_code
               ,p_param_type       => tbl_cus_prm(cnt_cus_prm).param_type
               ,p_param_code       => tbl_cus_prm(cnt_cus_prm).param_code
               ,p_param_name       => tbl_cus_prm(cnt_cus_prm).param_name
               ,p_enabled_flag     => tbl_cus_prm(cnt_cus_prm).enabled_flag
               ,p_environment_name => tbl_cus_prm(cnt_cus_prm).environment_name
               ,p_value_char       => tbl_cus_prm(cnt_cus_prm).value_char
               ,p_value_num        => tbl_cus_prm(cnt_cus_prm).value_num
               ,p_value_date       => tbl_cus_prm(cnt_cus_prm).value_date
               ,p_language         => v_language
               ,p_user_name        => v_user_name
               ,x_cus_param_id     => v_cus_param_id
               ,x_return_status    => v_return_status
               ,x_msg_error        => v_mesg_error
               );
           EXCEPTION
             WHEN others THEN
               v_mesg_error := 'Error llamando al procedimiento '     ||
                               'XX_CUSTOMS_PKG.PARAM_CREATE_UPDATE. ' ||
                                SQLERRM                               ||
                                '.';
           END;
           IF v_return_status = 'S' THEN
              v_cnt_success := NVL(v_cnt_success,0)+1;
           ELSE
              v_cnt_error := NVL(v_cnt_error,0)+1;
              dbms_output.put_line(SUBSTR('Mensaje: '||v_mesg_error,1,250));
           END IF;
       END LOOP;
    END IF;
    dbms_output.put_line('---------------------------------------------------------------------');
    dbms_output.put_line('Cant. de parametros procesados..............: '||TO_CHAR(NVL(v_cnt,0)));
    dbms_output.put_line('Cant. de parametros procesados con exito....: '||TO_CHAR(NVL(v_cnt_success,0)));
    dbms_output.put_line('Cant. de parametros procesados con error....: '||TO_CHAR(NVL(v_cnt_error,0)));
  END process;
BEGIN
	null;
  process;
END;
/

COMMIT;


PROMPT =====================================================================
SELECT TO_CHAR(SYSDATE,'DD-MON-YYYY HH24:MI:SS') AS "End_Date"
  FROM dual;


SPOOL OFF


-- EXIT



