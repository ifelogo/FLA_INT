CREATE OR REPLACE PACKAGE BODY xx_fla_common_pro_int_pkg AS
/* $Header: XX_FLA_PROPERTY_INT_PKG.plb 11.1.1111.0 2021/01/01 12:00:00 iloaiza noship $ */
/*=========================================================================+
|                                                                          |
| Private Procedure                                                        |
|    indent                                                                |
|                                                                          |
| Description                                                              |
|    Procedimiento privado que indenta.                                    |
|                                                                          |
| Parameters                                                               |
|    p_type IN     VARCHAR2 Tipo de indentacion (+: agrega indentacion)    |
|                                               (-: elimina indentacion)   |
|                                                                          |
+=========================================================================*/
PROCEDURE indent(p_type IN     VARCHAR2
                )
IS
  v_calling_sequence VARCHAR2(2000);
  v_indent_length    NUMBER(18);
BEGIN
  v_calling_sequence := 'XX_FLA_PROPERTY_INT_PKG.INDENT';
  v_indent_length := 3;
  IF p_type = '+' THEN
     g_indent := REPLACE(RPAD(' '
                             ,NVL(LENGTH(g_indent)
                                 ,0
                                 ) +
                              v_indent_length
                             )
                        ,' '
                        ,' '
                        );
  ELSIF p_type = '-' THEN
     g_indent := REPLACE(RPAD(' '
                             ,NVL(LENGTH(g_indent)
                                 ,0
                                 ) -
                              v_indent_length
                             )
                        ,' '
                        ,' '
                        );
  END IF;
EXCEPTION
  WHEN others THEN
    NULL;
END indent;
/*=========================================================================+
|                                                                          |
| Private Procedure                                                        |
|    debug                                                                 |
|                                                                          |
| Description                                                              |
|    Procedimiento privado que genera el debug.                            |
|                                                                          |
| Parameters                                                               |
|    p_message IN      VARCHAR2 Mensaje de Debug.                          |
|    p_type    IN      VARCHAR2 Tipo de Mensaje de Debug.                  |
|                                                                          |
+=========================================================================*/
PROCEDURE debug(p_message IN      VARCHAR2
               ,p_type    IN      VARCHAR2 DEFAULT NULL
               )
IS
  -- ---------------------------------------------------------------------------
  -- Declaracion de Variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence VARCHAR2(2000);
BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence := 'XX_FLA_PROPERTY_INT_PKG.DEBUG';
  -- ---------------------------------------------------------------------------
  -- Ejecuta el debug.
  -- ---------------------------------------------------------------------------
  IF g_debug_flag = 'Y' THEN
     xx_debug_pkg.debug(p_module  => g_module
                       ,p_message => p_message
                       ,p_type    => p_type
                       );
  END IF;
EXCEPTION
  WHEN others THEN
    NULL;
END debug;


/*=========================================================================+
|                                                                          |
| Private Function                                                         |
|    message                                                               |
|                                                                          |
| Description                                                              |
|    Procedimiento privado que obtiene el mensaje.                         |
|                                                                          |
| Parameters                                                               |
|    p_message_code   IN      VARCHAR2 Codigo de mensaje.                  |
|    p_message_values IN      VARCHAR2 Valores del mensaje.                |
|                                                                          |
+=========================================================================*/
FUNCTION message(p_message_code   IN      VARCHAR2
                ,p_message_values IN      VARCHAR2 DEFAULT NULL
                ) RETURN VARCHAR2
IS
  -- ---------------------------------------------------------------------------
  -- Declaracion de Variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence VARCHAR2(2000);
  v_message          VARCHAR2(32767);
BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence := 'XX_PO_CDP_INT_PKG.MESSAGE';
  -- ---------------------------------------------------------------------------
  -- Obtiene el mensaje.
  -- ---------------------------------------------------------------------------
  v_message := xx_messages_pkg.get_message
  --v_message := get_message
                 (p_module         => g_module
                 ,p_message_code   => p_message_code
                 ,p_message_values => p_message_values
                 );
  RETURN (v_message);
EXCEPTION
  WHEN others THEN
    RETURN (v_message);
END message;

/*=============================================================================+
|                                                                              |
| Public Procedure                                                             |
|    GET_INT_STEPS                                                             |
|                                                                              |
| Description                                                                  |
|    (descripcion del procedimiento)                                           |
|                                                                              |
| Parameters                                                                   |
|    p_request_id           IN      VARCHAR2 Nro. del requerimiento.           |
|    p_draft_flag           IN      VARCHAR2 Modo borrador.                    |
|    p_debug_flag           IN      VARCHAR2 Flag de debug.                    |
|    p_language             IN      VARCHAR2 Codigo de lenguaje.               |
|    p_user_name            IN      VARCHAR2 Usuario.                          |
|    p_integration_code     IN      VARCHAR2 Codigo del pais.                  |
|    x_integration_steps    OUT     XX_FLA_COMMON_INT_STEPS_T Listado de pasos |
|                                             por integración                  |
|    x_return_status        OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error            OUT     VARCHAR2 Mensaje de error.                 |
|                                                                              |
+=============================================================================*/
/*PROCEDURE get_next_step(p_request_id            IN      NUMBER
                       ,p_draft_flag            IN      VARCHAR2
                       ,p_debug_flag            IN      VARCHAR2
                       ,p_language              IN      VARCHAR2
                       ,p_user_name             IN      VARCHAR2
                       ,p_integration_code      IN      VARCHAR2
                       ,p_step                  IN      NUMBER
                       ,x_next_step             OUT     VARCHAR
                       ,x_return_status         OUT     VARCHAR2
                       ,x_msg_error             OUT     VARCHAR2
                       )
IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4);  
  
  v_integration_step                    XX_FLA_COMMON_INT_STEP_O;
  v_integration_steps                   XX_FLA_COMMON_INT_STEPS_T;

  -- ---------------------------------------------------------------------------
  -- Declaracion de Cursores.
  -- ---------------------------------------------------------------------------
  -- ---------------------------------------------------------------------------
  -- Cursor de pasos.
  -- ---------------------------------------------------------------------------
   --ORIGINAL
    CURSOR c_steps(p_integration_code VARCHAR2) IS
    SELECT xfcis.integration_code
          ,xfcis.step
          ,xfcis.step_object
          ,xfcis.step_type
      FROM dual
          ,xx_fla_common_int_steps xfcis
     WHERE 1 = 1
       AND xfcis.integration_code       =   p_integration_code
       AND NVL(xfcis.enabled_flag,'N')  =   'Y'
     ORDER BY
           xfcis.step;
BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence      := 'XX_FLA_COMMON_PRO_INT_PKG.GET_INT_STEPS';
  x_return_status         := 'S';
  v_integration_steps     := XX_FLA_COMMON_INT_STEPS_T();
  -- ---------------------------------------------------------------------------
  -- Inicializa datos globales.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error IS NULL THEN
     BEGIN
       xx_global_pkg.initialize
         (p_user_name        => p_user_name
         ,p_language         => p_language
         ,p_request_id       => p_request_id
         ,p_request_phase_id => p_request_phase_id
         );
       g_debug_flag := xx_debug_pkg.g_enabled;
     EXCEPTION
       WHEN others THEN
         v_mesg_error := message('XX_FLA_PROPERTY_INIT',SQLERRM);
     END;
  END IF;
  -- ---------------------------------------------------------------------------
  -- Despliega parametros.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (+)'
       ,'1'
       );
  debug(g_indent                     ||
        v_calling_sequence           ||
        '. Nro. del requerimiento: ' ||
        TO_CHAR(p_request_id)
       ,'1'
       );
  debug(g_indent                                ||
        v_calling_sequence                      ||
        '. Nro. de requerimiento de la etapa: ' ||
        TO_CHAR(p_request_phase_id)
       ,'1'
       );
  debug(g_indent            ||
        v_calling_sequence  ||
        '. Modo borrador: ' ||
        p_draft_flag
       ,'1'
       );
  debug(g_indent            ||
        v_calling_sequence  ||
        '. Flag de debug: ' ||
        p_debug_flag
       ,'1'
       );
  debug(g_indent                 ||
        v_calling_sequence       ||
        '. Codigo de lenguaje: ' ||
        p_language
       ,'1'
       );
  debug(g_indent           ||
        v_calling_sequence ||
        '. Usuario: '      ||
        p_user_name
       ,'1'
       );
       
  -- ---------------------------------------------------------------------------
  -- Obtiene codigo de lenguaje.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error  IS NULL THEN
     v_language := xx_global_pkg.language;
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. Codigo de lenguaje seteado: ' ||
           v_language
          ,'1'
          );
  END IF;
         
         
         
  -- ---------------------------------------------------------------------------
  -- Logica del proceso.
  -- ---------------------------------------------------------------------------

  FOR r_step IN c_steps(p_integration_code) LOOP
  
      IF v_mesg_error  IS NULL 
      THEN
         debug(g_indent                         ||
               v_calling_sequence               ||
               '. step_object: ' ||
               r_step.step_object
              ,'1'
              );
      END IF;
      
      
        v_integration_step    := NULL;
        v_integration_step    := xx_fla_common_int_step_o(
                                                          r_step.integration_code
                                                         ,r_step.step
                                                         ,r_step.step_type
                                                         ,r_step.step_object                                                   
                                                         ); 

        v_integration_steps.EXTEND;
        v_integration_steps(v_integration_steps.COUNT)  :=  v_integration_step;      
  
  END LOOP;

  -- ---------------------------------------------------------------------------
  -- Verifica si se produjo un error.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error IS NOT NULL THEN
     x_return_status := 'E';
     x_msg_error     := v_mesg_error;
     debug(g_indent           ||
           v_calling_sequence ||
           '. '               ||
           v_mesg_error
          ,'1'
          );
    ELSE
      
        x_integration_steps := v_integration_steps;  
        
  END IF;
  -- ---------------------------------------------------------------------------
  -- Fin del proceso.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (-)'
       ,'1'
       );
EXCEPTION
  WHEN others THEN
    v_mesg_error := v_calling_sequence  ||
                    message('XX_FLA_PROPERTY_GEN',SQLERRM);
    debug(g_indent           ||
          v_calling_sequence ||
          '. '               ||
          v_mesg_error
         ,'1'
         );
    debug(g_indent           ||
          v_calling_sequence ||
          ' (-)'
         ,'1'
         );
    x_return_status := 'E';
    x_msg_error     := v_mesg_error;

END get_next_step;*/

/*=============================================================================+
|                                                                              |
| Public Procedure                                                             |
|    GET_INT_STEPS                                                             |
|                                                                              |
| Description                                                                  |
|    (descripcion del procedimiento)                                           |
|                                                                              |
| Parameters                                                                   |
|    p_request_id           IN      VARCHAR2 Nro. del requerimiento.           |
|    p_draft_flag           IN      VARCHAR2 Modo borrador.                    |
|    p_debug_flag           IN      VARCHAR2 Flag de debug.                    |
|    p_language             IN      VARCHAR2 Codigo de lenguaje.               |
|    p_user_name            IN      VARCHAR2 Usuario.                          |
|    p_integration_code     IN      VARCHAR2 Codigo del pais.                  |
|    x_integration_steps    OUT     XX_FLA_COMMON_INT_STEPS_T Listado de pasos |
|                                             por integración                  |
|    x_return_status        OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error            OUT     VARCHAR2 Mensaje de error.                 |
|                                                                              |
+=============================================================================*/
PROCEDURE get_int_steps(p_request_id            IN      VARCHAR2
                       ,p_draft_flag            IN      VARCHAR2
                       ,p_debug_flag            IN      VARCHAR2
                       ,p_language              IN      VARCHAR2
                       ,p_user_name             IN      VARCHAR2
                       ,p_integration_code      IN      VARCHAR2
                       ,x_integration_steps     OUT     XX_FLA_COMMON_INT_STEPS_T 
                       ,x_return_status         OUT     VARCHAR2
                       ,x_msg_error             OUT     VARCHAR2
                       )
IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4);  
  
  v_integration_step                    XX_FLA_COMMON_INT_STEP_O;
  v_integration_steps                   XX_FLA_COMMON_INT_STEPS_T;

  -- ---------------------------------------------------------------------------
  -- Declaracion de Cursores.
  -- ---------------------------------------------------------------------------
  -- ---------------------------------------------------------------------------
  -- Cursor de pasos.
  -- ---------------------------------------------------------------------------
   --ORIGINAL
    CURSOR c_steps(p_integration_code VARCHAR2) IS
    SELECT xfcis.integration_code
          ,xfcis.step
          ,xfcis.step_object
          ,xfcis.step_type
          ,xfcis.msg_type
          ,xfcis.root_item
      FROM dual
          ,xx_fla_common_int_steps xfcis
     WHERE 1 = 1
       AND xfcis.integration_code       =   p_integration_code
       AND NVL(xfcis.enabled_flag,'N')  =   'Y'
     ORDER BY
           xfcis.step;
BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence      := 'XX_FLA_COMMON_PRO_INT_PKG.GET_INT_STEPS';
  x_return_status         := 'S';
  v_integration_steps     := XX_FLA_COMMON_INT_STEPS_T();
  -- ---------------------------------------------------------------------------
  -- Inicializa datos globales.
  -- ---------------------------------------------------------------------------
 /* IF v_mesg_error IS NULL THEN
     BEGIN
       xx_global_pkg.initialize
         (p_user_name        => p_user_name
         ,p_language         => p_language
         ,p_request_id       => p_request_id
         ,p_request_phase_id => p_request_id
         );
       g_debug_flag := xx_debug_pkg.g_enabled;
     EXCEPTION
       WHEN others THEN
         v_mesg_error := message('XX_FLA_PROPERTY_INIT',SQLERRM);
     END;
  END IF;*/
  -- ---------------------------------------------------------------------------
  -- Despliega parametros.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (+)'
       ,'1'
       );
  debug(g_indent                     ||
        v_calling_sequence           ||
        '. Nro. del requerimiento: ' ||
        TO_CHAR(p_request_id)
       ,'1'
       );
  /*debug(g_indent                                ||
        v_calling_sequence                      ||
        '. Nro. de requerimiento de la etapa: ' ||
        TO_CHAR(p_request_phase_id)
       ,'1'
       );*/
  debug(g_indent            ||
        v_calling_sequence  ||
        '. Modo borrador: ' ||
        p_draft_flag
       ,'1'
       );
  debug(g_indent            ||
        v_calling_sequence  ||
        '. Flag de debug: ' ||
        p_debug_flag
       ,'1'
       );
  debug(g_indent                 ||
        v_calling_sequence       ||
        '. Codigo de lenguaje: ' ||
        p_language
       ,'1'
       );
  debug(g_indent           ||
        v_calling_sequence ||
        '. Usuario: '      ||
        p_user_name
       ,'1'
       );
       
  -- ---------------------------------------------------------------------------
  -- Obtiene codigo de lenguaje.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error  IS NULL THEN
     v_language := xx_global_pkg.language;
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. Codigo de lenguaje seteado: ' ||
           v_language
          ,'1'
          );
  END IF;
         
         
         
  -- ---------------------------------------------------------------------------
  -- Logica del proceso.
  -- ---------------------------------------------------------------------------

  FOR r_step IN c_steps(p_integration_code) LOOP
  
      IF v_mesg_error  IS NULL 
      THEN
         debug(g_indent                         ||
               v_calling_sequence               ||
               '. step_object: ' ||
               r_step.step_object
              ,'1'
              );
      END IF;
      
      
        v_integration_step    := NULL;
        v_integration_step    := xx_fla_common_int_step_o(
                                                          r_step.integration_code
                                                         ,r_step.step
                                                         ,r_step.step_type
                                                         ,r_step.step_object                                                   
                                                         ,r_step.msg_type
                                                         ,r_step.root_item
                                                         ); 

        v_integration_steps.EXTEND;
        v_integration_steps(v_integration_steps.COUNT)  :=  v_integration_step;      
  
  END LOOP;

  -- ---------------------------------------------------------------------------
  -- Verifica si se produjo un error.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error IS NOT NULL THEN
     x_return_status := 'E';
     x_msg_error     := v_mesg_error;
     debug(g_indent           ||
           v_calling_sequence ||
           '. '               ||
           v_mesg_error
          ,'1'
          );
    ELSE
      
        x_integration_steps := v_integration_steps;  
        
  END IF;
  -- ---------------------------------------------------------------------------
  -- Fin del proceso.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (-)'
       ,'1'
       );
EXCEPTION
  WHEN others THEN
    v_mesg_error := v_calling_sequence  ||
                    message('XX_FLA_PROPERTY_GEN',SQLERRM);
    debug(g_indent           ||
          v_calling_sequence ||
          '. '               ||
          v_mesg_error
         ,'1'
         );
    debug(g_indent           ||
          v_calling_sequence ||
          ' (-)'
         ,'1'
         );
    x_return_status := 'E';
    x_msg_error     := v_mesg_error;

END get_int_steps;


/*==========================================================================+
|                                                                           |
| Public Procedure                                                          |
|    fla_common_int_req_trx                                                 |
|                                                                           |
| Description                                                               |
|    Crea un registro en las lineas de requests.                            |
|                                                                           |
| Parameters                                                                |
|    p_user_name                IN      VARCHAR2 Usuario.                   |
|    p_req_trx_id               IN      NUMBER   Id de transacción          |
|                                                   del requerimiento       |
|    p_request_id               IN      VARCHAR2 Id del requerimiento       |   
|    p_integration_code         IN      VARCHAR2 Codigo de la integración   |
|    p_integration_step         IN      VARCHAR2 Paso de la integración     |
|    p_param_key                IN      VARCHAR2 Nombre del parametro       |       
|    p_param_value              IN      VARCHAR2 Valor del parametro        |   
|    x_return_status            OUT     VARCHAR2 Estado de ejecucion.       |
|    x_msg_error                OUT     VARCHAR2 Mensaje de error.          |
|                                                                           |
+==========================================================================*/
PROCEDURE insert_fla_common_int_req_trx( p_user_name               	IN      	VARCHAR2
                                        ,p_req_trx_id               IN          NUMBER
                                        ,p_request_id               IN          VARCHAR2
                                        ,p_integration_code         IN          VARCHAR2
                                        ,p_step                     IN          NUMBER
                                        ,p_iteration                IN          NUMBER
                                        ,p_param_key                IN          VARCHAR2        
                                        ,p_param_value              IN          VARCHAR2
                                        ,x_return_status            OUT     	VARCHAR2
                                        ,x_msg_error                OUT     	VARCHAR2
                                         
                                ) IS

  
  v_mesg_error           	    VARCHAR2(32767);


BEGIN
     BEGIN
       INSERT INTO xx_fla_common_int_req_trx
         (req_trx_id
         ,request_id
         ,integration_code
         ,step
         ,iteration
         ,param_key
         ,param_value
         ,creation_date
         ,created_by
         ,last_update_date
         ,last_updated_by                
         )
         VALUES
         (	p_req_trx_id
           ,p_request_id
           ,p_integration_code
           ,p_step
           ,p_iteration
           ,p_param_key
           ,p_param_value
           ,SYSDATE                         -- creation_date
           ,p_user_name                     -- created_by
           ,SYSDATE                         -- last_update_date
           ,p_user_name                     -- last_updated_by
         );
        

        
     EXCEPTION
       WHEN others THEN
         --v_mesg_error := message('POS_INVOICE_LINE_INSERT',SQLERRM);
         v_mesg_error := SQLERRM;
     END;


    IF v_mesg_error IS NULL THEN

        x_return_status     := 'S';
        
    ELSE			
        
        v_mesg_error := message('INSERT_LINE_ERROR',v_mesg_error);
                        
                       
    END IF;

    x_return_status := 'E';
    x_msg_error     := v_mesg_error;

EXCEPTION

  WHEN others THEN
  
    x_return_status := 'E';
    x_msg_error     := v_mesg_error;


END insert_fla_common_int_req_trx;


/*=============================================================================+
|                                                                              |
| Public Procedure                                                             |
|    GET_INT_PARAMS                                                            |
|                                                                              |
| Description                                                                  |
|    (descripcion del procedimiento)                                           |
|                                                                              |
| Parameters                                                                   |
|    p_request_id           IN      VARCHAR2 Nro. del requerimiento.           |
|    p_draft_flag           IN      VARCHAR2 Modo borrador.                    |
|    p_debug_flag           IN      VARCHAR2 Flag de debug.                    |
|    p_language             IN      VARCHAR2 Codigo de lenguaje.               |
|    p_user_name            IN      VARCHAR2 Usuario.                          |
|    p_integration_code     IN      VARCHAR2 Codigo de la integración.         |
|    x_integration_steps    OUT     XX_FLA_COMMON_INT_STEPS_T Listado de pasos |
|                                             por integración                  |
|    x_return_status        OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error            OUT     VARCHAR2 Mensaje de error.                 |
|                                                                              |
+=============================================================================*/
PROCEDURE get_int_params(p_request_id            IN      VARCHAR2
                        ,p_draft_flag            IN      VARCHAR2
                        ,p_debug_flag            IN      VARCHAR2
                        ,p_language              IN      VARCHAR2
                        ,p_user_name             IN      VARCHAR2
                        ,p_integration_code      IN      VARCHAR2
                        ,p_params                IN      VARCHAR2
                        --,x_params_list           OUT     XX_FLA_INT_PARAMS_T 
                        ,x_return_status         OUT     VARCHAR2
                        ,x_msg_error             OUT     VARCHAR2
                        )
IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4);  
  
  v_jo                      JSON_OBJECT_T;
  v_keys                    JSON_KEY_LIST;
  v_req_trx_id              xx_fla_common_int_req_trx.req_trx_id%TYPE;
  --v_values

  -- ---------------------------------------------------------------------------
  -- Declaracion de Cursores.
  -- ---------------------------------------------------------------------------
  -- ---------------------------------------------------------------------------
  -- Cursor de .
  -- ---------------------------------------------------------------------------
   --ORIGINAL
    
BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence      := 'XX_FLA_COMMON_PRO_INT_PKG.GET_INT_PARAMS';
  x_return_status         := 'S';  
  DBMS_OUTPUT.put_line('Init1');
  -- ---------------------------------------------------------------------------
  -- Inicializa datos globales.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (+)'
       ,'1'
       );  
  DBMS_OUTPUT.put_line('Init2');  
 /* IF v_mesg_error IS NULL THEN
     BEGIN
       xx_global_pkg.initialize
         (p_user_name        => p_user_name
         ,p_language         => p_language
         ,p_request_id       => p_request_id
         ,p_request_phase_id => p_request_id
         );
       g_debug_flag := xx_debug_pkg.g_enabled;
     EXCEPTION
       WHEN others THEN
         v_mesg_error := message('XX_FLA_PROPERTY_INIT',SQLERRM);
     END;
  END IF;
  DBMS_OUTPUT.put_line('Init3'); 
  */
  -- ---------------------------------------------------------------------------
  -- Despliega parametros.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (+)'
       ,'1'
       );
  debug(g_indent                     ||
        v_calling_sequence           ||
        '. Nro. del requerimiento: ' ||
        TO_CHAR(p_request_id)
       ,'1'
       );
  /*debug(g_indent                                ||
        v_calling_sequence                      ||
        '. Nro. de requerimiento de la etapa: ' ||
        TO_CHAR(p_request_phase_id)
       ,'1'
       );*/
  debug(g_indent            ||
        v_calling_sequence  ||
        '. Modo borrador: ' ||
        p_draft_flag
       ,'1'
       );
  debug(g_indent            ||
        v_calling_sequence  ||
        '. Flag de debug: ' ||
        p_debug_flag
       ,'1'
       );
  debug(g_indent                 ||
        v_calling_sequence       ||
        '. Codigo de lenguaje: ' ||
        p_language
       ,'1'
       );
  debug(g_indent           ||
        v_calling_sequence ||
        '. Usuario: '      ||
        p_user_name
       ,'1'
       );
       
  -- ---------------------------------------------------------------------------
  -- Obtiene codigo de lenguaje.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error  IS NULL THEN
     v_language := xx_global_pkg.language;
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. Codigo de lenguaje seteado: ' ||
           v_language
          ,'1'
          );
  END IF;
         
         
         
  -- ---------------------------------------------------------------------------
  -- Logica del proceso.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error  IS NULL 
    AND p_params IS NOT NULL
  THEN

      v_jo      := JSON_OBJECT_T.parse(p_params);
      v_keys    := v_jo.get_keys;
      --v_values  := v_jo.get_values;
      FOR i IN 1..v_keys.COUNT LOOP
         DBMS_OUTPUT.put_line('Name->' ||v_keys(i));
         --v_acronyms := v_json_obj.get_string(v_keys(i));
         DBMS_OUTPUT.put_line('Value->' || v_jo.get_string(v_keys(i)));
         IF v_keys(i) IS NOT NULL
         THEN


         
    
            BEGIN
                v_req_trx_id :=  xx_fla_common_pro_int_req_trx_s.NEXTVAL; 
            EXCEPTION
                WHEN OTHERS THEN
                    v_req_trx_id := NULL;
                    v_mesg_error := message('FLA_COMMON_REQ_TRX_SEQ',SQLERRM);
            END;
                           
            IF v_mesg_error IS NULL THEN

                 insert_fla_common_int_req_trx(
                                                p_user_name
                                               ,v_req_trx_id
                                               ,p_request_id
                                               ,p_integration_code
                                               ,0 --Parametros Iniciales
                                               ,-1 --Iteración unica
                                               ,TRIM(REPLACE(v_keys(i),'"',''))
                                               ,TRIM(REPLACE(v_jo.get_string(v_keys(i)),'"',''))
                                               ,x_return_status
                                               ,v_mesg_error
                                               );


            END IF;


         END IF;

      END LOOP;

    
  END IF;
  
  
 

  -- ---------------------------------------------------------------------------
  -- Verifica si se produjo un error.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error IS NOT NULL THEN
     x_return_status := 'E';
     x_msg_error     := v_mesg_error;
     debug(g_indent           ||
           v_calling_sequence ||
           '. '               ||
           v_mesg_error
          ,'1'
          );
    ELSE
      
        --x_integration_steps := v_integration_steps;  
        NULL;
        
  END IF;
  -- ---------------------------------------------------------------------------
  -- Fin del proceso.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (-)'
       ,'1'
       );
EXCEPTION
  WHEN others THEN
    v_mesg_error := v_calling_sequence  ||
                    message('XX_FLA_PROPERTY_GEN',SQLERRM);
    debug(g_indent           ||
          v_calling_sequence ||
          '. '               ||
          v_mesg_error
         ,'1'
         );
    debug(g_indent           ||
          v_calling_sequence ||
          ' (-)'
         ,'1'
         );
    x_return_status := 'E';
    x_msg_error     := v_mesg_error;

END get_int_params;

/*=============================================================================+
|                                                                              |
| Public Procedure                                                             |
|    CREATE_NEXT_STEP_QUERY_REQUEST                                                  |
|                                                                              |
| Description                                                                  |
|    (descripcion del procedimiento)                                           |
|                                                                              |
| Parameters                                                                   |
|    p_request_id           IN      VARCHAR2 Nro. del requerimiento.           |
|    p_draft_flag           IN      VARCHAR2 Modo borrador.                    |
|    p_debug_flag           IN      VARCHAR2 Flag de debug.                    |
|    p_language             IN      VARCHAR2 Codigo de lenguaje.               |
|    p_user_name            IN      VARCHAR2 Usuario.                          |
|    p_integration_code     IN      VARCHAR2 Codigo de la integración.         |
|    p_step                 IN      NUMBER   Id del Paso.                      |
|    p_step_type            IN      VARCHAR2 Tipo de paso REST o PL/SQL.       |
|    p_msg_type             IN      VARCHAR2 Tipo mensaje Query para los       |
|                                               llamados REST.                 |
|    x_integration_steps    OUT     XX_FLA_COMMON_INT_STEPS_T Listado de pasos |
|                                             por integración                  |
|    x_return_status        OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error            OUT     VARCHAR2 Mensaje de error.                 |
|                                                                              |
+=============================================================================*/
PROCEDURE create_next_step_query_request(p_request_id            IN      VARCHAR2
                                        ,p_draft_flag            IN      VARCHAR2
                                        ,p_debug_flag            IN      VARCHAR2
                                        ,p_language              IN      VARCHAR2
                                        ,p_user_name             IN      VARCHAR2
                                        ,p_integration_code      IN      VARCHAR2
                                        ,p_step                  IN      NUMBER
                                        ,p_step_type             IN      VARCHAR2
                                        ,p_msg_type              IN      VARCHAR2 
                                        ,x_request               OUT     XX_FLA_COMMON_EXEC_REQS_T
                                        ,x_return_status         OUT     VARCHAR2
                                        ,x_msg_error             OUT     VARCHAR2
                                        )
IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4);  
  
  v_request                 VARCHAR2(32767);
  v_request_sql             VARCHAR2(32767);
  v_statement               VARCHAR2(32767);

  v_request_list_select     XX_FLA_COMMON_EXEC_REQS_T;
  v_request_obj             XX_FLA_COMMON_EXEC_REQ_O;
  --v_values

  -- ---------------------------------------------------------------------------
  -- Declaracion de Cursores.
  -- ---------------------------------------------------------------------------
  -- ---------------------------------------------------------------------------
  -- Cursor de c_next_step.
  -- ---------------------------------------------------------------------------
  CURSOR c_next_step IS
  SELECT xfcins.from_field
        ,xfcins.to_field_type
        ,xfcins.to_field
        ,xfcins.to_value
        ,xfcins.transformation
  FROM dual
      ,xx_fla_common_int_next_steps xfcins
  WHERE 1 = 1 
  AND xfcins.to_step            = p_step
  AND xfcins.integration_code   = p_integration_code
  ORDER BY xfcins.request_order;
  

    
BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence      := 'XX_FLA_COMMON_PRO_INT_PKG.CREATE_NEXT_STEP_QUERY_REQUEST';
  x_return_status         := 'S';  
  v_request_list_select   := XX_FLA_COMMON_EXEC_REQS_T();
  -- ---------------------------------------------------------------------------
  -- Inicializa datos globales.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (+)'
       ,'1'
       );  
  /*DBMS_OUTPUT.put_line('Init2');  
  IF v_mesg_error IS NULL THEN
     BEGIN
       xx_global_pkg.initialize
         (p_user_name        => p_user_name
         ,p_language         => p_language
         ,p_request_id       => p_request_id
         ,p_request_phase_id => NULL
         );
       g_debug_flag := xx_debug_pkg.g_enabled;
     EXCEPTION
       WHEN others THEN
         v_mesg_error := message('XX_FLA_PROPERTY_INIT',SQLERRM);
     END;
  END IF;
  DBMS_OUTPUT.put_line('Init3'); */
  
  -- ---------------------------------------------------------------------------
  -- Despliega parametros.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (+)'
       ,'1'
       );
  debug(g_indent                     ||
        v_calling_sequence           ||
        '. Nro. del requerimiento: ' ||
        TO_CHAR(p_request_id)
       ,'1'
       );
  /*debug(g_indent                                ||
        v_calling_sequence                      ||
        '. Nro. de requerimiento de la etapa: ' ||
        TO_CHAR(p_request_phase_id)
       ,'1'
       );*/
  debug(g_indent            ||
        v_calling_sequence  ||
        '. Modo borrador: ' ||
        p_draft_flag
       ,'1'
       );
  debug(g_indent            ||
        v_calling_sequence  ||
        '. Flag de debug: ' ||
        p_debug_flag
       ,'1'
       );
  debug(g_indent                 ||
        v_calling_sequence       ||
        '. Codigo de lenguaje: ' ||
        p_language
       ,'1'
       );
  debug(g_indent           ||
        v_calling_sequence ||
        '. Usuario: '      ||
        p_user_name
       ,'1'
       );
       
  -- ---------------------------------------------------------------------------
  -- Obtiene codigo de lenguaje.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error  IS NULL THEN
     v_language := xx_global_pkg.language;
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. Codigo de lenguaje seteado: ' ||
           v_language
          ,'1'
          );
  END IF;
         
         
  DBMS_OUTPUT.put_line('Init');       
  -- ---------------------------------------------------------------------------
  -- Logica del proceso.
  -- ---------------------------------------------------------------------------

 DBMS_OUTPUT.put_line('Init2');  
  
      FOR r_next_step IN c_next_step LOOP
      
            v_request:= NULL;
                      
        IF p_msg_type = 'QUERY' 
            AND p_step_type = 'REST'
        THEN            
            IF r_next_step.to_field_type = 'VALUE' THEN
    
                     v_statement := 'SELECT xfcirt.param_value              ' ||
                                      '  FROM dual                          ' ||   
                                      '  ,xx_fla_common_int_req_trx xfcirt  ' ||
                                      '  WHERE 1 = 1                        ' ||
                                      '  AND xfcirt.integration_code =      ''' || p_integration_code || '''' ||
                                      '  AND xfcirt.param_key        =      ''' || r_next_step.from_field || ''''  ||
                                      '  AND xfcirt.request_id       =      ''' || p_request_id || ''''  ||
                                      '  ORDER BY xfcirt.iteration ';
                     BEGIN
                       EXECUTE IMMEDIATE v_statement
                          INTO v_request_sql;
                     EXCEPTION
                       WHEN others THEN
                         DBMS_OUTPUT.put_line('EXCEPTION1');
                
                     END;

                            --'"'||r_next_step.to_field ||'":"'||v_request_sql||'"'
                    v_request := REPLACE(r_next_step.to_field ||'='||v_request_sql,'"','');

                        
                    --v_request := CASE p_step_type WHEN 'REST' THEN '"'||r_next_step.to_field ||'":"'||v_request_sql||'"' ELSE v_request_sql END;
                    DBMS_OUTPUT.put_line('v_request1->'||v_request);
                    
                ELSIF r_next_step.to_field_type = 'TYPE' THEN
                    
                    --No aplica el caso
                    NULL;              
                    
                ELSIF r_next_step.to_field_type = 'CONST' THEN

                    v_request := r_next_step.to_field ||'='||r_next_step.to_value;
                            
                        
                        --v_request  :=  r_next_step.to_value;
                    --v_request := CASE p_step_type WHEN 'REST' THEN '"'||r_next_step.to_field ||'":"'||r_next_step.to_value||'"'ELSE r_next_step.to_value END;
                    DBMS_OUTPUT.put_line('v_request3->'||v_request);
                
                END IF;
             
             
                        v_request_list_select.EXTEND;
                        v_request_list_select(v_request_list_select.COUNT)  :=  XX_FLA_COMMON_EXEC_REQ_O(v_request);
             
             
            END IF;

          END LOOP;
     
    
        

    

    DBMS_OUTPUT.put_line('Request->'||v_request);
  -- ---------------------------------------------------------------------------
  -- Verifica si se produjo un error.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error IS NOT NULL THEN
     x_return_status := 'E';
     x_msg_error     := v_mesg_error;
     debug(g_indent           ||
           v_calling_sequence ||
           '. '               ||
           v_mesg_error
          ,'1'
          );
    ELSE
      
        x_request := v_request_list_select;  
        
        
  END IF;
  -- ---------------------------------------------------------------------------
  -- Fin del proceso.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (-)'
       ,'1'
       );
EXCEPTION
  WHEN others THEN
    v_mesg_error := v_calling_sequence  ||
                    message('XX_FLA_PROPERTY_GEN',SQLERRM);
    debug(g_indent           ||
          v_calling_sequence ||
          '. '               ||
          v_mesg_error
         ,'1'
         );
    debug(g_indent           ||
          v_calling_sequence ||
          ' (-)'
         ,'1'
         );
    x_return_status := 'E';
    x_msg_error     := v_mesg_error;

END create_next_step_query_request;


/*=============================================================================+
|                                                                              |
| Public Procedure                                                             |
|    CREATE_NEXT_STEP_REQUEST                                                  |
|                                                                              |
| Description                                                                  |
|    (descripcion del procedimiento)                                           |
|                                                                              |
| Parameters                                                                   |
|    p_request_id           IN      VARCHAR2 Nro. del requerimiento.           |
|    p_draft_flag           IN      VARCHAR2 Modo borrador.                    |
|    p_debug_flag           IN      VARCHAR2 Flag de debug.                    |
|    p_language             IN      VARCHAR2 Codigo de lenguaje.               |
|    p_user_name            IN      VARCHAR2 Usuario.                          |
|    p_integration_code     IN      VARCHAR2 Codigo de la integración.         |
|    p_step                 IN      NUMBER   Id del Paso.                      |
|    p_step_type            IN      VARCHAR2 Tipo de paso REST o PL/SQL.       |
|    p_msg_type             IN      VARCHAR2 Tipo mensaje Query para los       |
|                                               llamados REST.                 |
|    x_integration_steps    OUT     XX_FLA_COMMON_INT_STEPS_T Listado de pasos |
|                                             por integración                  |
|    x_return_status        OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error            OUT     VARCHAR2 Mensaje de error.                 |
|                                                                              |
+=============================================================================*/
PROCEDURE create_next_step_request(p_request_id            IN      VARCHAR2
                                  ,p_draft_flag            IN      VARCHAR2
                                  ,p_debug_flag            IN      VARCHAR2
                                  ,p_language              IN      VARCHAR2
                                  ,p_user_name             IN      VARCHAR2
                                  ,p_integration_code      IN      VARCHAR2
                                  ,p_step                  IN      NUMBER
                                  ,p_step_type             IN      VARCHAR2
                                  ,p_msg_type              IN      VARCHAR2 
                                  ,x_request               OUT     XX_FLA_COMMON_EXEC_REQS_T
                                  ,x_return_status         OUT     VARCHAR2
                                  ,x_msg_error             OUT     VARCHAR2
                                  )
IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4);  
  
  v_request                 VARCHAR2(32767);
  v_request_sql             VARCHAR2(32767);
  v_statement               VARCHAR2(32767);

  v_request_list            XX_FLA_COMMON_EXEC_REQS_T;
  v_request_list_select     XX_FLA_COMMON_EXEC_REQS_T;
  v_request_obj             XX_FLA_COMMON_EXEC_REQ_O;

  /*TYPE t_field IS RECORD (to_step NUMBER, field VARCHAR2(100), request_order NUMBER);
  TYPE t_fields IS TABLE OF t_field INDEX BY PLS_INTEGER;
TYPE t_val IS TABLE OF VARCHAR2(4000) INDEX BY VARCHAR2(100); -- key=field
TYPE t_vals IS TABLE OF t_val INDEX BY PLS_INTEGER;            -- por iteración


TYPE t_step_iter_count IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER; -- step -> cantidad de iteraciones

--TYPE t_indices IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;         -- recursión/cartesiano



v_step_iter_data   t_step_iter_data;
v_step_iter_count  t_step_iter_count;
v_indices          t_indices;
v_globals          t_glob;
i INTEGER := 0;
  v_fields t_fields;
  v_steps_with_iter  SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST();
  v_steps_only_global SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST();*/
  
  v_fields                SYS.ODCIVARCHAR2LIST;
  TYPE t_field IS RECORD (
    to_field VARCHAR2(100),
    from_field VARCHAR2(100)
  );
  TYPE t_fields IS TABLE OF t_field INDEX BY PLS_INTEGER;
  v_fields_list           t_fields;
  TYPE t_glob IS TABLE OF VARCHAR2(4000) INDEX BY VARCHAR2(100); -- valores globales (step|field)
  v_globals               t_glob;
TYPE t_val IS TABLE OF VARCHAR2(4000) INDEX BY VARCHAR2(100); -- key=campo
TYPE t_vals IS TABLE OF t_val INDEX BY PLS_INTEGER; -- iteración
v_step_iter_data        t_vals;
TYPE t_indices IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
  v_indices               t_indices;
  v_steps_with_iter       SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST();
  v_steps_only_global SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST();
  i                       INTEGER := 0;
  
  --TYPE t_step_iter_data IS TABLE OF t_val INDEX BY PLS_INTEGER; -- iteración -> mapa de campo

  
  -- ---------------------------------------------------------------------------
  -- Declaracion de Cursores.
  -- ---------------------------------------------------------------------------
  -- ---------------------------------------------------------------------------
  -- Cursor de c_next_step.
  -- ---------------------------------------------------------------------------
  CURSOR c_next_step IS
    SELECT xfcins.to_field
          ,xfcins.from_field
      FROM dual
           ,xx_fla_common_int_next_steps xfcins
     WHERE xfcins.to_step = p_step
       AND xfcins.integration_code = p_integration_code
       AND xfcins.to_field_type IN ('VALUE','CONST')
     ORDER BY xfcins.request_order;
  
  CURSOR c_next_step_type IS
    SELECT xfcins.to_field
      FROM dual
           ,xx_fla_common_int_next_steps xfcins
     WHERE xfcins.to_step = p_step
       AND xfcins.integration_code = p_integration_code
       AND xfcins.to_field_type IN ('TYPE')
     ORDER BY xfcins.request_order;

  -- Procedimiento rec_cart
  PROCEDURE rec_cart(idx IN PLS_INTEGER, indices IN OUT t_indices) IS

  BEGIN
    DBMS_OUTPUT.put_line('idx->'||idx);
    DBMS_OUTPUT.put_line('v_steps_with_iter.COUNT->'||v_steps_with_iter.COUNT);
    IF idx > v_steps_with_iter.COUNT THEN
      DECLARE
        v_line VARCHAR2(4000) := '';
      BEGIN
        FOR f IN 1 .. v_fields_list.COUNT LOOP
          IF f > 1 THEN v_line := v_line || '",'; END IF;
        
          IF v_globals.EXISTS(v_fields_list(f).from_field) THEN
            DBMS_OUTPUT.put_line('Global->' ||v_fields_list(f).from_field);
            v_line := v_line || '"param' ||f||'":"' || v_globals(v_fields_list(f).from_field);
          ELSE
          BEGIN
            DBMS_OUTPUT.put_line('Detail->'||v_step_iter_data(indices(1))(v_fields_list(f).from_field));
            IF v_step_iter_data.EXISTS(indices(1)) THEN
              IF v_step_iter_data(indices(1)).EXISTS(v_fields_list(f).from_field) THEN
                v_line := v_line ||'"param' ||f||'":"'|| v_step_iter_data(indices(1))(v_fields_list(f).from_field);
--                v_line := v_line ||'"param'||f||'":"'|| NVL(v_globals(v_fields_list(f).from_field), '"');

              ELSE
                --v_line := v_line || '';
                v_line := NULL;
              END IF;
            ELSE
              --v_line := v_line || '';
              v_line := NULL;
            END IF;
            EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    DBMS_OUTPUT.PUT_LINE('NO DATA FOUND en indices(1)='||indices(1)||', campo='||v_fields_list(f).from_field);
                    v_line := null;
          END;
          END IF;
          
        END LOOP;
        DBMS_OUTPUT.put_line('v_line->'||v_line);
        IF INSTR(v_line,'param')  != 0 
            AND v_line IS NOT NULL 
        THEN
        
            v_request_list_select.EXTEND;
            v_request_list_select(v_request_list_select.COUNT)  :=  XX_FLA_COMMON_EXEC_REQ_O(v_line);
        END IF;
                     
      END;
    ELSE
      -- Recursividad por iteración
      DECLARE
        cnt INTEGER := v_step_iter_data.COUNT;
      BEGIN
        FOR i IN 1 .. cnt LOOP
          indices(idx) := i;
          rec_cart(idx + 1, indices);
        END LOOP;
      END;
    END IF;
  END rec_cart;
    
BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence      := 'XX_FLA_COMMON_PRO_INT_PKG.CREATE_NEXT_STEP_QUERY_REQUEST';
  x_return_status         := 'S';  
  --v_request_list          := XX_FLA_COMMON_EXEC_REQS_T();
  v_request_list_select   := XX_FLA_COMMON_EXEC_REQS_T();
  -- ---------------------------------------------------------------------------
  -- Inicializa datos globales.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (+)'
       ,'1'
       );  
  /*DBMS_OUTPUT.put_line('Init2');  
  IF v_mesg_error IS NULL THEN
     BEGIN
       xx_global_pkg.initialize
         (p_user_name        => p_user_name
         ,p_language         => p_language
         ,p_request_id       => p_request_id
         ,p_request_phase_id => NULL
         );
       g_debug_flag := xx_debug_pkg.g_enabled;
     EXCEPTION
       WHEN others THEN
         v_mesg_error := message('XX_FLA_PROPERTY_INIT',SQLERRM);
     END;
  END IF;
  DBMS_OUTPUT.put_line('Init3'); */
  
  -- ---------------------------------------------------------------------------
  -- Despliega parametros.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (+)'
       ,'1'
       );
  debug(g_indent                     ||
        v_calling_sequence           ||
        '. Nro. del requerimiento: ' ||
        TO_CHAR(p_request_id)
       ,'1'
       );
  /*debug(g_indent                                ||
        v_calling_sequence                      ||
        '. Nro. de requerimiento de la etapa: ' ||
        TO_CHAR(p_request_phase_id)
       ,'1'
       );*/
  debug(g_indent            ||
        v_calling_sequence  ||
        '. Modo borrador: ' ||
        p_draft_flag
       ,'1'
       );
  debug(g_indent            ||
        v_calling_sequence  ||
        '. Flag de debug: ' ||
        p_debug_flag
       ,'1'
       );
  debug(g_indent                 ||
        v_calling_sequence       ||
        '. Codigo de lenguaje: ' ||
        p_language
       ,'1'
       );
  debug(g_indent           ||
        v_calling_sequence ||
        '. Usuario: '      ||
        p_user_name
       ,'1'
       );
       
  -- ---------------------------------------------------------------------------
  -- Obtiene codigo de lenguaje.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error  IS NULL THEN
     v_language := xx_global_pkg.language;
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. Codigo de lenguaje seteado: ' ||
           v_language
          ,'1'
          );
  END IF;
         
         
  DBMS_OUTPUT.put_line('Init');       
  -- ---------------------------------------------------------------------------
  -- Logica del proceso.
  -- ---------------------------------------------------------------------------
 


 DBMS_OUTPUT.put_line('Init2');  
    IF p_msg_type = 'QUERY' 
        AND NVL(p_step_type,'X') = 'REST'
    THEN            

        create_next_step_query_request( p_request_id
                                       ,p_draft_flag
                                       ,p_debug_flag
                                       ,p_language  
                                       ,p_user_name 
                                       ,p_integration_code
                                       ,p_step            
                                       ,p_step_type       
                                       ,p_msg_type        
                                       ,v_request_list_select         
                                       ,x_return_status   
                                       ,v_mesg_error       
                                       );

    ELSE      

 DBMS_OUTPUT.put_line('Init3');  
  -- 1. Obtener todos los campos presentes, en orden global
    i := 0;
    FOR r IN c_next_step LOOP
        DBMS_OUTPUT.put_line('r.to_field->' || r.to_field); 
        IF r.to_field IS NOT NULL THEN
            i := i + 1;
            v_fields_list(i).to_field := r.to_field;
            v_fields_list(i).from_field := r.from_field;            
            DBMS_OUTPUT.put_line('i->' || i);
            DBMS_OUTPUT.put_line('v_fields_list(i).to_field->' || v_fields_list(i).to_field);  
            DBMS_OUTPUT.put_line('v_fields_list(i).from_field->' || v_fields_list(i).from_field);  
             
        END IF;
    END LOOP;
 DBMS_OUTPUT.put_line('Init4');  
  -- 2. Separar steps solo globales vs steps con iteraciones
  FOR r IN (
      SELECT xfcirt.step,
           MAX(CASE WHEN xfcirt.iteration >= 1 THEN 1 ELSE 0 END) has_iter
      FROM dual
          ,xx_fla_common_int_req_trx xfcirt
      WHERE 1 = 1     
       AND xfcirt.request_id = p_request_id
       AND xfcirt.step <= p_step
       GROUP BY xfcirt.step
       ORDER BY xfcirt.step
  ) LOOP
    IF r.has_iter = 1 THEN
      v_steps_with_iter.EXTEND;
      v_steps_with_iter(v_steps_with_iter.COUNT) := r.step;
      DBMS_OUTPUT.put_line('v_steps_with_iter' || r.step); 
    ELSE
      v_steps_only_global.EXTEND;
      v_steps_only_global(v_steps_only_global.COUNT) := r.step;
      DBMS_OUTPUT.put_line('v_steps_only_global' || r.step); 
    END IF;
  END LOOP;
 DBMS_OUTPUT.put_line('Init5');  
  -- 3. Cargar valores globales
/*FOR i IN 1 .. v_steps_only_global.COUNT LOOP
  FOR r IN (
    SELECT step, param_key, param_value
      FROM xx_fla_common_int_req_trx
     WHERE request_id = p_request_id
       AND step = v_steps_only_global(i)
       AND iteration = -1
  ) LOOP
    v_globals(key(r.step, r.param_key)) := r.param_value;
    DBMS_OUTPUT.put_line('key(r.step, r.param_key)' || key(r.step, r.param_key)); 
    DBMS_OUTPUT.put_line('r.param_value' || r.param_value); 
  END LOOP;
END LOOP;*/
  -- 2. Cargar globals (iteration = -1)
  FOR r IN (
    SELECT param_key, param_value
      FROM xx_fla_common_int_req_trx
     WHERE request_id = p_request_id
       AND step <= p_step
       AND iteration = -1
  ) LOOP
    v_globals(r.param_key) := r.param_value;
  END LOOP;

  -- 3. Cargar iteraciones (iteration >= 0)
  FOR iter IN (
    SELECT DISTINCT iteration
      FROM xx_fla_common_int_req_trx
     WHERE request_id = p_request_id
       AND step <= p_step
       AND iteration >= 0
     ORDER BY iteration
  ) LOOP
    --v_step_iter_data(iter.iteration) := TABLE OF VARCHAR2(4000)();
    FOR r IN (
      SELECT param_key, param_value
        FROM xx_fla_common_int_req_trx
       WHERE request_id = p_request_id
         AND step <= p_step
         AND iteration = iter.iteration
    ) LOOP
      v_step_iter_data(iter.iteration)(r.param_key) := r.param_value;
    END LOOP;
  END LOOP;

/* DBMS_OUTPUT.put_line('Init6');  
-- 4. Cargar valores de steps con iteraciones (solo usando la tabla de transacciones)
FOR i IN 1 .. v_steps_with_iter.COUNT LOOP
    DECLARE
        step_n NUMBER := v_steps_with_iter(i);
        v_vals t_vals;
        cnt INTEGER := 0;
    BEGIN
        -- Obtén todas las iteraciones para ese step
        FOR iter IN (
            SELECT DISTINCT iteration
              FROM xx_fla_common_int_req_trx
             WHERE request_id = p_request_id
               AND step = step_n
               AND iteration >= 0
             ORDER BY iteration
        ) LOOP
            cnt := cnt + 1;
            v_vals(cnt) := t_val();
            -- Carga todos los campos de esa iteración para ese step
            FOR r IN (
                SELECT param_key, param_value
                  FROM xx_fla_common_int_req_trx
                 WHERE request_id = p_request_id
                   AND step = step_n
                   AND iteration = iter.iteration
                 ORDER BY param_key
            ) LOOP
                v_vals(cnt)(r.param_key) := r.param_value;
    --DBMS_OUTPUT.put_line('cnt->' || cnt); 
    --DBMS_OUTPUT.put_line('r.param_key->' || r.param_key); 
    --DBMS_OUTPUT.put_line('v_vals(cnt)(r.param_key)->' || v_vals(cnt)(r.param_key)); 
    --DBMS_OUTPUT.put_line('r.param_value->' || r.param_value); 
                
            END LOOP;
        END LOOP;
        v_step_iter_data(step_n) := v_vals;
        v_step_iter_count(step_n) := cnt;
    END;
END LOOP;

 DBMS_OUTPUT.put_line('Init7');  
  -- 6. Ejecutar producto cartesiano
  BEGIN
    IF v_steps_with_iter.COUNT = 0 THEN
      -- Solo globals
      DECLARE
        v_line VARCHAR2(4000) := '';
      BEGIN
      dbms_output.put_line('v_fields.COUNT->'||v_fields.COUNT);
        FOR f IN 1 .. v_fields.COUNT LOOP
          IF f > 1 THEN v_line := v_line || '|'; END IF;
          v_line := v_line || NVL(v_globals(key(v_fields(f).to_step, v_fields(f).field)), '');
          dbms_output.put_line('f->'||f);
          dbms_output.put_line('v_fields(f).to_step->'||v_fields(f).to_step);
          dbms_output.put_line('v_fields(f).field->'||v_fields(f).field);
          dbms_output.put_line('key(v_fields(f).to_step, v_fields(f).field)->'||key(v_fields(f).to_step, v_fields(f).field));
          dbms_output.put_line('v_globals(key(v_fields(f).to_step, v_fields(f).field))->'||v_globals(key(v_fields(f).to_step, v_fields(f).field)));
        END LOOP;
        dbms_output.put_line(v_line);
      END;
    ELSE
      rec_cart(1, v_indices);
    END IF;
  END;*/
  
  -- 4. Ejecutar producto cartesiano (solo un nivel aquí, adapta según tus iteraciones)
  IF v_step_iter_data.COUNT = 0 THEN
    -- Solo globals
    DECLARE
      v_line VARCHAR2(4000) := '';
    BEGIN
      FOR f IN 1 .. v_fields_list.COUNT LOOP
        IF f > 1 THEN v_line := v_line || '",'; END IF;
        v_line := v_line ||'"param'||f||'":"'|| NVL(v_globals(v_fields_list(f).from_field), '"');

      END LOOP;
      DBMS_OUTPUT.put_line('Init5');
      DBMS_OUTPUT.put_line(v_line);
      v_request_list_select.EXTEND;
      v_request_list_select(v_request_list_select.COUNT)  :=  XX_FLA_COMMON_EXEC_REQ_O(v_line);
      
    END;
  ELSE
    v_indices(1) := 1;
    rec_cart(1, v_indices);
  END IF;  
 DBMS_OUTPUT.put_line('Init9');    
    /*
              FOR r_next_step IN c_next_step LOOP
              
                    v_request:= NULL;
                    
                    IF r_next_step.to_field_type = 'VALUE' THEN
            
                             v_statement := 'SELECT xfcirt.param_value              ' ||
                                              '  FROM dual                          ' ||   
                                              '  ,xx_fla_common_int_req_trx xfcirt  ' ||
                                              '  WHERE 1 = 1                        ' ||
                                              '  AND xfcirt.integration_code =      ''' || p_integration_code || '''' ||
                                              '  AND xfcirt.param_key        =      ''' || r_next_step.from_field || ''''  ||
                                              '  AND xfcirt.request_id       =      ''' || p_request_id || ''''  ||
                                              '  ORDER BY xfcirt.iteration ';
                             BEGIN
                               EXECUTE IMMEDIATE v_statement
                                  INTO v_request_sql;
                             EXCEPTION
                               WHEN others THEN
                                 DBMS_OUTPUT.put_line('EXCEPTION1');
                        
                             END;
                            IF p_step_type = 'REST' THEN
                                
                                IF p_msg_type = 'JSON' THEN
                                
                                    v_request := '"'||r_next_step.to_field ||'":"'||v_request_sql||'"';
        
                                END IF;
                                
                            ELSIF p_step_type = 'PL/SQL' THEN
                            
                                v_request:= v_request_sql;
                                
                            END IF;
                            --v_request := CASE p_step_type WHEN 'REST' THEN '"'||r_next_step.to_field ||'":"'||v_request_sql||'"' ELSE v_request_sql END;
                            DBMS_OUTPUT.put_line('v_request1->'||v_request);
                            
                        ELSIF r_next_step.to_field_type = 'TYPE' THEN
                            
             
                            v_request := r_next_step.to_field;
                                --v_request := CASE p_step_type WHEN 'REST' THEN '"'||r_next_step.to_field ||'":"'||v_request||'"'ELSE v_request END;
                            DBMS_OUTPUT.put_line('v_request2->'||v_request);
                            
                        ELSIF r_next_step.to_field_type = 'CONST' THEN
        
                            IF p_step_type = 'REST' THEN
                                
                                IF p_msg_type = 'JSON'  THEN
                                
                                    v_request := '"'||r_next_step.to_field ||'":"'||r_next_step.to_value||'"';
                                    
                                END IF;
                                
                            ELSIF p_step_type = 'PL/SQL' THEN
                            
                                v_request := r_next_step.to_value;
                                
                            END IF;                
                                --v_request  :=  r_next_step.to_value;
                            --v_request := CASE p_step_type WHEN 'REST' THEN '"'||r_next_step.to_field ||'":"'||r_next_step.to_value||'"'ELSE r_next_step.to_value END;
                            DBMS_OUTPUT.put_line('v_request3->'||v_request);
                        
                    END IF;
                     
                     
                                v_request_list_select.EXTEND;
                                v_request_list_select(v_request_list_select.COUNT)  :=  XX_FLA_COMMON_EXEC_REQ_O(v_request);
                     
                     
                  END LOOP;
             
            */
             v_request := NULL;
        
             IF v_request_list_select IS NOT NULL
             THEN
        
                /*FOR i IN v_request_list_select.FIRST..v_request_list_select.LAST LOOP
                
                    IF p_step_type = 'REST'
                    THEN
                           
                            IF p_msg_type = 'JSON'  THEN
                                
                                    v_request := v_request || v_request_list_select(i).request || ','; 
                                    
                            END IF;
                           
                    ELSIF p_step_type = 'PL/SQL' THEN
                    
                            v_request := v_request || '"param' || TO_CHAR(i) || '":"' || v_request_list_select(i).request || '",';  
        
                    END IF;        
                    
                    
                END LOOP;*/
                DBMS_OUTPUT.put_line('Init 10'); 
                    FOR r IN c_next_step_type LOOP
                        DBMS_OUTPUT.put_line('r.to_field->' || r.to_field); 
                        IF r.to_field IS NOT NULL THEN
                            i := i + 1;
                            v_request := v_request || '"param' || i ||'":"'||r.to_field ||'",';
                        END IF;
                    END LOOP;
                    v_request := SUBSTR (v_request,1,LENGTH (v_request) -1);
                    FOR v IN v_request_list_select.FIRST..v_request_list_select.LAST LOOP                        
                        v_request_list_select(v).request :=  '{'||v_request_list_select(v).request ||'",' ||v_request||'}';
                        DBMS_OUTPUT.put_line(v_request_list_select(v).request); 
                        
                    END LOOP;
                    
                    
            END IF;
        
            
            
           /* IF v_mesg_error IS NULL
            THEN
                --v_request := SUBSTR (v_request,1,LENGTH (v_request) -1);
                
                
                IF p_step_type = 'REST' THEN
                    
                            IF p_msg_type = 'JSON'  THEN
                                
                                    v_request := '{' || v_request || '}';
                                    
                            END IF;
                                       
                    
                    ELSE
                    
                    v_request := '{' || v_request || '}';
            END IF;
          END IF;*/
          
            
           /* v_request_obj := NULL;
            v_request_obj := XX_FLA_COMMON_EXEC_REQ_O(v_request);
            
        
            v_request_list.EXTEND;
            v_request_list(v_request_list.COUNT)  :=  v_request_obj;*/
            
    END IF;
    --DBMS_OUTPUT.put_line('Request->'||v_request);
  -- ---------------------------------------------------------------------------
  -- Verifica si se produjo un error.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error IS NOT NULL THEN
     x_return_status := 'E';
     x_msg_error     := v_mesg_error;
     debug(g_indent           ||
           v_calling_sequence ||
           '. '               ||
           v_mesg_error
          ,'1'
          );
    ELSE
      
        x_request := v_request_list_select;  
        
        
  END IF;
  -- ---------------------------------------------------------------------------
  -- Fin del proceso.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (-)'
       ,'1'
       );
EXCEPTION
  WHEN others THEN
    v_mesg_error := SQLERRM ; --v_calling_sequence  ||
                    --message('XX_FLA_PROPERTY_GEN',SQLERRM);
    debug(g_indent           ||
          v_calling_sequence ||
          '. '               ||
          v_mesg_error
         ,'1'
         );
    debug(g_indent           ||
          v_calling_sequence ||
          ' (-)'
         ,'1'
         );
    x_return_status := 'E';
    x_msg_error     := v_mesg_error;

END create_next_step_request;


/*=============================================================================+
|                                                                              |
| Public Procedure                                                             |
|    CREATE_NEXT_STEP_REQUEST1                                                 |
|                                                                              |
| Description                                                                  |
|    (descripcion del procedimiento)                                           |
|                                                                              |
| Parameters                                                                   |
|    p_request_id           IN      VARCHAR2 Nro. del requerimiento.           |
|    p_draft_flag           IN      VARCHAR2 Modo borrador.                    |
|    p_debug_flag           IN      VARCHAR2 Flag de debug.                    |
|    p_language             IN      VARCHAR2 Codigo de lenguaje.               |
|    p_user_name            IN      VARCHAR2 Usuario.                          |
|    p_integration_code     IN      VARCHAR2 Codigo de la integración.         |
|    p_step                 IN      NUMBER   Id del Paso.                      |
|    p_step_type            IN      VARCHAR2 Tipo de paso REST o PL/SQL.       |
|    p_msg_type             IN      VARCHAR2 Tipo mensaje Query para los       |
|                                               llamados REST.                 |
|    x_integration_steps    OUT     XX_FLA_COMMON_INT_STEPS_T Listado de pasos |
|                                             por integración                  |
|    x_return_status        OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error            OUT     VARCHAR2 Mensaje de error.                 |
|                                                                              |
+=============================================================================*/
PROCEDURE create_next_step_request1(p_request_id            IN      VARCHAR2
                                  ,p_draft_flag            IN      VARCHAR2
                                  ,p_debug_flag            IN      VARCHAR2
                                  ,p_language              IN      VARCHAR2
                                  ,p_user_name             IN      VARCHAR2
                                  ,p_integration_code      IN      VARCHAR2
                                  ,p_step                  IN      NUMBER
                                  ,p_step_type             IN      VARCHAR2
                                  ,p_msg_type              IN      VARCHAR2 
                                  ,x_request               OUT     XX_FLA_COMMON_EXEC_REQS_T
                                  ,x_return_status         OUT     VARCHAR2
                                  ,x_msg_error             OUT     VARCHAR2
                                  )
IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4);  
  
  v_request                 VARCHAR2(32767);
  v_request_sql             VARCHAR2(32767);
  v_statement               VARCHAR2(32767);

  v_request_list            XX_FLA_COMMON_EXEC_REQS_T;
  v_request_list_select     XX_FLA_COMMON_EXEC_REQS_T;
  v_request_obj             XX_FLA_COMMON_EXEC_REQ_O;
  --v_values

  -- ---------------------------------------------------------------------------
  -- Declaracion de Cursores.
  -- ---------------------------------------------------------------------------
  -- ---------------------------------------------------------------------------
  -- Cursor de c_next_step.
  -- ---------------------------------------------------------------------------
  CURSOR c_next_step IS
  SELECT xfcins.from_field
        ,xfcins.to_field_type
        ,xfcins.to_field
        ,xfcins.to_value
        ,xfcins.transformation
  FROM dual
      ,xx_fla_common_int_next_steps xfcins
  WHERE 1 = 1 
  AND xfcins.to_step            = p_step
  AND xfcins.integration_code   = p_integration_code
  ORDER BY xfcins.request_order;
  

    
BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence      := 'XX_FLA_COMMON_PRO_INT_PKG.CREATE_NEXT_STEP_QUERY_REQUEST';
  x_return_status         := 'S';  
  v_request_list          := XX_FLA_COMMON_EXEC_REQS_T();
  v_request_list_select   := XX_FLA_COMMON_EXEC_REQS_T();
  -- ---------------------------------------------------------------------------
  -- Inicializa datos globales.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (+)'
       ,'1'
       );  
  /*DBMS_OUTPUT.put_line('Init2');  
  IF v_mesg_error IS NULL THEN
     BEGIN
       xx_global_pkg.initialize
         (p_user_name        => p_user_name
         ,p_language         => p_language
         ,p_request_id       => p_request_id
         ,p_request_phase_id => NULL
         );
       g_debug_flag := xx_debug_pkg.g_enabled;
     EXCEPTION
       WHEN others THEN
         v_mesg_error := message('XX_FLA_PROPERTY_INIT',SQLERRM);
     END;
  END IF;
  DBMS_OUTPUT.put_line('Init3'); */
  
  -- ---------------------------------------------------------------------------
  -- Despliega parametros.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (+)'
       ,'1'
       );
  debug(g_indent                     ||
        v_calling_sequence           ||
        '. Nro. del requerimiento: ' ||
        TO_CHAR(p_request_id)
       ,'1'
       );
  /*debug(g_indent                                ||
        v_calling_sequence                      ||
        '. Nro. de requerimiento de la etapa: ' ||
        TO_CHAR(p_request_phase_id)
       ,'1'
       );*/
  debug(g_indent            ||
        v_calling_sequence  ||
        '. Modo borrador: ' ||
        p_draft_flag
       ,'1'
       );
  debug(g_indent            ||
        v_calling_sequence  ||
        '. Flag de debug: ' ||
        p_debug_flag
       ,'1'
       );
  debug(g_indent                 ||
        v_calling_sequence       ||
        '. Codigo de lenguaje: ' ||
        p_language
       ,'1'
       );
  debug(g_indent           ||
        v_calling_sequence ||
        '. Usuario: '      ||
        p_user_name
       ,'1'
       );
       
  -- ---------------------------------------------------------------------------
  -- Obtiene codigo de lenguaje.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error  IS NULL THEN
     v_language := xx_global_pkg.language;
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. Codigo de lenguaje seteado: ' ||
           v_language
          ,'1'
          );
  END IF;
         
         
  DBMS_OUTPUT.put_line('Init');       
  -- ---------------------------------------------------------------------------
  -- Logica del proceso.
  -- ---------------------------------------------------------------------------

 DBMS_OUTPUT.put_line('Init2');  
    IF p_msg_type = 'QUERY' 
        AND p_step_type = 'REST'
    THEN            

        create_next_step_query_request( p_request_id
                                       ,p_draft_flag
                                       ,p_debug_flag
                                       ,p_language  
                                       ,p_user_name 
                                       ,p_integration_code
                                       ,p_step            
                                       ,p_step_type       
                                       ,p_msg_type        
                                       ,v_request_list         
                                       ,x_return_status   
                                       ,v_mesg_error       
                                       );

    ELSE      
              FOR r_next_step IN c_next_step LOOP
              
                    v_request:= NULL;
                    
                    IF r_next_step.to_field_type = 'VALUE' THEN
            
                             v_statement := 'SELECT xfcirt.param_value              ' ||
                                              '  FROM dual                          ' ||   
                                              '  ,xx_fla_common_int_req_trx xfcirt  ' ||
                                              '  WHERE 1 = 1                        ' ||
                                              '  AND xfcirt.integration_code =      ''' || p_integration_code || '''' ||
                                              '  AND xfcirt.param_key        =      ''' || r_next_step.from_field || ''''  ||
                                              '  AND xfcirt.request_id       =      ''' || p_request_id || ''''  ||
                                              '  ORDER BY xfcirt.iteration ';
                             BEGIN
                               EXECUTE IMMEDIATE v_statement
                                  INTO v_request_sql;
                             EXCEPTION
                               WHEN others THEN
                                 DBMS_OUTPUT.put_line('EXCEPTION1');
                        
                             END;
                            IF p_step_type = 'REST' THEN
                                
                                IF p_msg_type = 'JSON' THEN
                                
                                    v_request := '"'||r_next_step.to_field ||'":"'||v_request_sql||'"';
        
                                END IF;
                                
                            ELSIF p_step_type = 'PL/SQL' THEN
                            
                                v_request:= v_request_sql;
                                
                            END IF;
                            --v_request := CASE p_step_type WHEN 'REST' THEN '"'||r_next_step.to_field ||'":"'||v_request_sql||'"' ELSE v_request_sql END;
                            DBMS_OUTPUT.put_line('v_request1->'||v_request);
                            
                        ELSIF r_next_step.to_field_type = 'TYPE' THEN
                            
             
                            v_request := r_next_step.to_field;
                                --v_request := CASE p_step_type WHEN 'REST' THEN '"'||r_next_step.to_field ||'":"'||v_request||'"'ELSE v_request END;
                            DBMS_OUTPUT.put_line('v_request2->'||v_request);
                            
                        ELSIF r_next_step.to_field_type = 'CONST' THEN
        
                            IF p_step_type = 'REST' THEN
                                
                                IF p_msg_type = 'JSON'  THEN
                                
                                    v_request := '"'||r_next_step.to_field ||'":"'||r_next_step.to_value||'"';
                                    
                                END IF;
                                
                            ELSIF p_step_type = 'PL/SQL' THEN
                            
                                v_request := r_next_step.to_value;
                                
                            END IF;                
                                --v_request  :=  r_next_step.to_value;
                            --v_request := CASE p_step_type WHEN 'REST' THEN '"'||r_next_step.to_field ||'":"'||r_next_step.to_value||'"'ELSE r_next_step.to_value END;
                            DBMS_OUTPUT.put_line('v_request3->'||v_request);
                        
                    END IF;
                     
                     
                                v_request_list_select.EXTEND;
                                v_request_list_select(v_request_list_select.COUNT)  :=  XX_FLA_COMMON_EXEC_REQ_O(v_request);
                     
                     
                  END LOOP;
             
            
             v_request := NULL;
        
             IF v_request_list_select IS NOT NULL
             THEN
        
                FOR i IN v_request_list_select.FIRST..v_request_list_select.LAST LOOP
                
                    IF p_step_type = 'REST'
                    THEN
                           
                            IF p_msg_type = 'JSON'  THEN
                                
                                    v_request := v_request || v_request_list_select(i).request || ','; 
                                    
                            END IF;
                           
                    ELSIF p_step_type = 'PL/SQL' THEN
                    
                            v_request := v_request || '"param' || TO_CHAR(i) || '":"' || v_request_list_select(i).request || '",';  
        
                    END IF;        
                    
                    
                END LOOP;
                
            END IF;
        
            
            
            IF v_mesg_error IS NULL
            THEN
                v_request := SUBSTR (v_request,1,LENGTH (v_request) -1);
                
                
                IF p_step_type = 'REST' THEN
                    
                            IF p_msg_type = 'JSON'  THEN
                                
                                    v_request := '{' || v_request || '}';
                                    
                            END IF;
                                       
                    
                    ELSE
                    
                    v_request := '{' || v_request || '}';
            END IF;
          END IF;
          
            
            v_request_obj := NULL;
            v_request_obj := XX_FLA_COMMON_EXEC_REQ_O(v_request);
            
        
            v_request_list.EXTEND;
            v_request_list(v_request_list.COUNT)  :=  v_request_obj;
            
    END IF;
    DBMS_OUTPUT.put_line('Request->'||v_request);
  -- ---------------------------------------------------------------------------
  -- Verifica si se produjo un error.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error IS NOT NULL THEN
     x_return_status := 'E';
     x_msg_error     := v_mesg_error;
     debug(g_indent           ||
           v_calling_sequence ||
           '. '               ||
           v_mesg_error
          ,'1'
          );
    ELSE
      
        x_request := v_request_list;  
        
        
  END IF;
  -- ---------------------------------------------------------------------------
  -- Fin del proceso.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (-)'
       ,'1'
       );
EXCEPTION
  WHEN others THEN
    v_mesg_error := v_calling_sequence  ||
                    message('XX_FLA_PROPERTY_GEN',SQLERRM);
    debug(g_indent           ||
          v_calling_sequence ||
          '. '               ||
          v_mesg_error
         ,'1'
         );
    debug(g_indent           ||
          v_calling_sequence ||
          ' (-)'
         ,'1'
         );
    x_return_status := 'E';
    x_msg_error     := v_mesg_error;

END create_next_step_request1;


/*=============================================================================+
|                                                                              |
| Public Procedure                                                             |
|    EXECUTE_PL_REQUEST                                                        |
|                                                                              |
| Description                                                                  |
|    (descripcion del procedimiento)                                           |
|                                                                              |
| Parameters                                                                   |
|    p_request_id           IN      VARCHAR2 Nro. del requerimiento.           |
|    p_draft_flag           IN      VARCHAR2 Modo borrador.                    |
|    p_debug_flag           IN      VARCHAR2 Flag de debug.                    |
|    p_language             IN      VARCHAR2 Codigo de lenguaje.               |
|    p_user_name            IN      VARCHAR2 Usuario.                          |
|    p_integration_code     IN      VARCHAR2 Codigo de la integración.         |
|    p_step                 IN      NUMBER   Id del Paso.                      |
|    p_step_object          IN      VARCHAR2 Nombre del objecto a ejecutar.    |
|    p_request              IN      XX_FLA_COMMON_EXEC_REQS_T Listado del      |
|                                             request                          |
|    x_return_status        OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error            OUT     VARCHAR2 Mensaje de error.                 |
|                                                                              |
+=============================================================================*/
PROCEDURE execute_pl_request(p_request_id            IN      VARCHAR2
                            ,p_draft_flag            IN      VARCHAR2
                            ,p_debug_flag            IN      VARCHAR2
                            ,p_language              IN      VARCHAR2
                            ,p_user_name             IN      VARCHAR2
                            ,p_integration_code      IN      VARCHAR2
                            ,p_step                  IN      NUMBER
                            ,p_step_object           IN      VARCHAR2
                            ,p_request               IN      XX_FLA_COMMON_EXEC_REQS_T
                            ,x_return_status         OUT     VARCHAR2
                            ,x_msg_error             OUT     VARCHAR2
                             )
IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4);  
  --v_in_json_string          VARCHAR2(32767);
  v_request_list            XX_FLA_COMMON_EXEC_REQS_T;
  v_request_list_select     XX_FLA_COMMON_EXEC_REQS_T;
  v_request_obj             XX_FLA_COMMON_EXEC_REQ_O;
  v_stmt                    VARCHAR2(1000);
  v_return_status           VARCHAR2(1);
  v_json                    JSON_OBJECT_T;
  v_keys                    JSON_KEY_LIST;
  v_in_json                 JSON_OBJECT_T := JSON_OBJECT_T();
  v_sql                     VARCHAR2(4000);
  v_json_result             CLOB;
  v_msg_error               VARCHAR2(32767);
  v_req_trx_id              xx_fla_common_int_req_trx.req_trx_id%TYPE;
  v_json_requests  JSON_ARRAY_T := JSON_ARRAY_T();


  v_in_json_string CLOB;
  -- ---------------------------------------------------------------------------
  -- Variables de respuesta de la API.
  -- ---------------------------------------------------------------------------  
  v_li_arr_response         JSON_ARRAY_T;
  v_li_obj_response         JSON_OBJECT_T;
  v_keys_response           json_key_list;

  -- ---------------------------------------------------------------------------
  -- Declaracion de Cursores.
  -- ---------------------------------------------------------------------------


    
BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence      := 'XX_FLA_COMMON_PRO_INT_PKG.EXECUTE_PL_REQUEST';
  x_return_status         := 'S';  
  v_request_list          := XX_FLA_COMMON_EXEC_REQS_T();
  v_request_list_select   := XX_FLA_COMMON_EXEC_REQS_T();
  -- ---------------------------------------------------------------------------
  -- Inicializa datos globales.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (+)'
       ,'1'
       );  
  /*DBMS_OUTPUT.put_line('Init2');  
  IF v_mesg_error IS NULL THEN
     BEGIN
       xx_global_pkg.initialize
         (p_user_name        => p_user_name
         ,p_language         => p_language
         ,p_request_id       => p_request_id
         ,p_request_phase_id => NULL
         );
       g_debug_flag := xx_debug_pkg.g_enabled;
     EXCEPTION
       WHEN others THEN
         v_mesg_error := message('XX_FLA_PROPERTY_INIT',SQLERRM);
     END;
  END IF;
  DBMS_OUTPUT.put_line('Init3'); */
  
  -- ---------------------------------------------------------------------------
  -- Despliega parametros.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (+)'
       ,'1'
       );
  debug(g_indent                     ||
        v_calling_sequence           ||
        '. Nro. del requerimiento: ' ||
        TO_CHAR(p_request_id)
       ,'1'
       );
  /*debug(g_indent                                ||
        v_calling_sequence                      ||
        '. Nro. de requerimiento de la etapa: ' ||
        TO_CHAR(p_request_phase_id)
       ,'1'
       );*/
  debug(g_indent            ||
        v_calling_sequence  ||
        '. Modo borrador: ' ||
        p_draft_flag
       ,'1'
       );
  debug(g_indent            ||
        v_calling_sequence  ||
        '. Flag de debug: ' ||
        p_debug_flag
       ,'1'
       );
  debug(g_indent                 ||
        v_calling_sequence       ||
        '. Codigo de lenguaje: ' ||
        p_language
       ,'1'
       );
  debug(g_indent           ||
        v_calling_sequence ||
        '. Usuario: '      ||
        p_user_name
       ,'1'
       );
       
  -- ---------------------------------------------------------------------------
  -- Obtiene codigo de lenguaje.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error  IS NULL THEN
     v_language := xx_global_pkg.language;
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. Codigo de lenguaje seteado: ' ||
           v_language
          ,'1'
          );
  END IF;
         
         
  DBMS_OUTPUT.put_line('Init1');       
  -- ---------------------------------------------------------------------------
  -- Logica del proceso.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error  IS NULL 
  THEN

    FOR i IN p_request.FIRST .. p_request.LAST LOOP
          DBMS_OUTPUT.put_line('Init2'); 
        v_json := JSON_OBJECT_T.parse(p_request(i).request);
        v_in_json := JSON_OBJECT_T(); -- Reiniciar el objeto para cada request
         DBMS_OUTPUT.put_line('Init3'); 
        v_keys := v_json.get_keys; -- Esto es correcto
        FOR j IN 1 .. v_keys.COUNT LOOP
           
          IF v_keys(j) NOT IN ('x_json_result', 'x_return_status', 'x_msg_error') THEN
            v_in_json.put(v_keys(j), v_json.get(v_keys(j)));
          END IF;
        END LOOP;
    
        v_json_requests.append(v_in_json);
      END LOOP;
    
      -- Convertir el JSON array a CLOB
      DBMS_OUTPUT.put_line('Init4->'||v_json_requests.to_string);
      v_in_json_string := TO_CLOB(v_json_requests.to_string);
    
      -- Realizar la llamada dinámica
       v_sql := 'BEGIN ' || p_step_object || '(:1, :2, :3, :4, :5, :6, :7, :8, :9); END;';


        DBMS_OUTPUT.put_line('p_request_id->'||p_request_id);
        DBMS_OUTPUT.put_line('p_draft_flag->'||p_draft_flag);
        DBMS_OUTPUT.put_line('p_debug_flag->'||p_debug_flag);
        DBMS_OUTPUT.put_line('p_language->'||p_language);
        DBMS_OUTPUT.put_line('p_user_name->'||p_user_name);
        DBMS_OUTPUT.put_line('v_in_json_string->'||v_in_json_string);
        DBMS_OUTPUT.put_line('v_json_result->'||v_json_result);
        DBMS_OUTPUT.put_line('v_return_status->'||v_return_status);
        DBMS_OUTPUT.put_line('v_mesg_error->'||v_mesg_error);

      EXECUTE IMMEDIATE v_sql
        USING IN p_request_id, IN p_draft_flag, IN NVL(p_debug_flag,'N'),
              IN p_language, IN p_user_name, IN v_in_json_string, OUT v_json_result, OUT v_return_status, OUT v_mesg_error;


    /*FOR i IN p_request.FIRST .. p_request.LAST  LOOP

  DBMS_OUTPUT.put_line('Init2');  
      v_json := JSON_OBJECT_T.parse(p_request(i).request); 
  DBMS_OUTPUT.put_line('Init3');  
      v_keys := v_json.get_keys;
  DBMS_OUTPUT.put_line('Init4'); 
      FOR j IN 1 .. v_keys.COUNT LOOP
  DBMS_OUTPUT.put_line('Init5');         
        IF v_json.get_string(v_keys(j)) NOT IN ('x_json_result', 'x_return_status', 'x_msg_error') THEN

          v_in_json.put(v_keys(j), v_json.get(v_keys(j)));

        END IF;
        
      END LOOP;
        
      v_in_json_string := v_in_json.to_string;
  DBMS_OUTPUT.put_line('Init6'); 
      -- ---------------------------------------------------------------------------
      -- Construye llamada dinamica
      -- ---------------------------------------------------------------------------
 
      BEGIN
      v_sql := 'BEGIN ' || p_step_object || '(:1, :2, :3, :4, :5, :6, :7, :8, :9); END;';


        DBMS_OUTPUT.put_line('p_request_id->'||p_request_id);
        DBMS_OUTPUT.put_line('p_draft_flag->'||p_draft_flag);
        DBMS_OUTPUT.put_line('p_debug_flag->'||p_debug_flag);
        DBMS_OUTPUT.put_line('p_language->'||p_language);
        DBMS_OUTPUT.put_line('p_user_name->'||p_user_name);
        DBMS_OUTPUT.put_line('v_in_json_string->'||v_in_json_string);
        DBMS_OUTPUT.put_line('v_json_result->'||v_json_result);
        DBMS_OUTPUT.put_line('v_return_status->'||v_return_status);
        DBMS_OUTPUT.put_line('v_mesg_error->'||v_mesg_error);
        
        EXECUTE IMMEDIATE v_sql
          USING IN p_request_id, IN p_draft_flag, IN NVL(p_debug_flag,'N'), IN p_language, IN p_user_name, IN v_in_json_string, OUT v_json_result, OUT v_return_status, OUT v_mesg_error;

      EXCEPTION 
        WHEN OTHERS THEN
          DBMS_OUTPUT.put_line('Error->'||SQLERRM);  
          v_mesg_error := message('FLA_COMMON_EXEC',p_step_object||g_msg_del||SQLERRM);
      END;

*/

      IF v_mesg_error IS NULL 
        AND v_json_result IS NOT NULL 
      THEN

          -- ---------------------------------------------------------------------------
          -- Procesa respuesta.
          -- ---------------------------------------------------------------------------    
          v_json := JSON_OBJECT_T.parse(v_json_result);
          
          v_keys := v_json.get_keys;
            DBMS_OUTPUT.put_line('InitJsonCompleto->'||v_json.to_string);
          FOR j IN 1 .. v_keys.COUNT LOOP
            DBMS_OUTPUT.put_line('Init5->'||v_keys(j));
            DBMS_OUTPUT.put_line('Init5->'||v_json.get_string(v_keys(j)));
            
            v_li_arr_response := v_json.get_Array('x_items');
            
            FOR k IN 0 .. v_li_arr_response.get_size - 1 LOOP
            
                v_li_obj_response := JSON_OBJECT_T(v_li_arr_response.get(k));
                
                v_keys_response := v_li_obj_response.get_keys;
                
                FOR i IN 1 .. v_keys_response.COUNT LOOP
                    dbms_output.put_line('InitInLoop.keys->'||v_keys_response(i));
                    dbms_output.put_line('InitInLoop.values->'||v_li_obj_response.get(v_keys_response(i)).to_string);
                    
                    BEGIN
                        v_req_trx_id :=  xx_fla_common_pro_int_req_trx_s.NEXTVAL; 
                        EXCEPTION
                            WHEN OTHERS THEN
                                v_req_trx_id := NULL;
                                v_mesg_error := message('FLA_COMMON_REQ_TRX_SEQ',SQLERRM);
                                RETURN;
                    END;
              
                    
                    IF v_mesg_error IS NULL
                    THEN
dbms_output.put_line('INSERT->'||v_keys_response(i));
                               insert_fla_common_int_req_trx(
                                                               p_user_name
                                                              ,v_req_trx_id
                                                              ,p_request_id
                                                              ,p_integration_code
                                                              ,p_step
                                                              ,CASE v_keys.COUNT WHEN 1 THEN -1 ELSE k END
                                                              ,TRIM(v_keys_response(i))
                                                              ,TRIM(REPLACE(v_li_obj_response.get(v_keys_response(i)).to_string,'"',''))
                                                              ,x_return_status
                                                              ,v_mesg_error
                                                              );

                    END IF;
                END LOOP;
    
                DBMS_OUTPUT.put_line('InitInLoop->'||v_li_obj_response.to_string);    
    
              END LOOP;
    
          END LOOP;
      
      
      END IF;

   -- END LOOP;



  END IF;

  -- ---------------------------------------------------------------------------
  -- Verifica si se produjo un error.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error IS NOT NULL THEN
     x_return_status := 'E';
     x_msg_error     := v_mesg_error;
     debug(g_indent           ||
           v_calling_sequence ||
           '. '               ||
           v_mesg_error
          ,'1'
          );
    ELSE
      
        x_return_status := 'S';
        x_msg_error     := v_mesg_error;
        
  END IF;
  -- ---------------------------------------------------------------------------
  -- Fin del proceso.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (-)'
       ,'1'
       );
EXCEPTION
  WHEN others THEN
    v_mesg_error := v_calling_sequence  ||
                    message('XX_FLA_PROPERTY_GEN1',SQLERRM);
    debug(g_indent           ||
          v_calling_sequence ||
          '. '               ||
          v_mesg_error
         ,'1'
         );
    debug(g_indent           ||
          v_calling_sequence ||
          ' (-)'
         ,'1'
         );
    x_return_status := 'E';
    x_msg_error     := SQLERRM; --v_mesg_error;

END execute_pl_request;


/*=============================================================================+
|                                                                              |
| Public Procedure                                                             |
|    WRITE_JSON_RESPONSE                                                       |
|                                                                              |
| Description                                                                  |
|    (descripcion del procedimiento)                                           |
|                                                                              |
| Parameters                                                                   |
|    p_request_id           IN      VARCHAR2 Nro. del requerimiento.           |
|    p_draft_flag           IN      VARCHAR2 Modo borrador.                    |
|    p_debug_flag           IN      VARCHAR2 Flag de debug.                    |
|    p_language             IN      VARCHAR2 Codigo de lenguaje.               |
|    p_user_name            IN      VARCHAR2 Usuario.                          |
|    p_integration_code     IN      VARCHAR2 Codigo de la integración.         |
|    p_step                 IN      NUMBER   Id del Paso.                      |
|    p_step_object          IN      VARCHAR2 Nombre del objecto a ejecutar.    |
|    p_json_response        IN      CLOB     json de respuesta                 |
|    x_return_status        OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error            OUT     VARCHAR2 Mensaje de error.                 |
|                                                                              |
+=============================================================================*/
PROCEDURE write_json_response(p_request_id            IN      VARCHAR2
                             ,p_draft_flag            IN      VARCHAR2
                             ,p_debug_flag            IN      VARCHAR2
                             ,p_language              IN      VARCHAR2
                             ,p_user_name             IN      VARCHAR2
                             ,p_integration_code      IN      VARCHAR2
                             ,p_step                  IN      NUMBER
                             ,p_step_object           IN      VARCHAR2
                             ,p_root_item             IN      VARCHAR2
                             ,p_json_response         IN      CLOB
                             ,x_return_status         OUT     VARCHAR2
                             ,x_msg_error             OUT     VARCHAR2
                              )
IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4); 
  
  v_columns_select          VARCHAR2(32767);
  v_columns                 VARCHAR2(32767);
  TYPE t_array IS TABLE OF  VARCHAR2(100);
  v_columns_name            t_array := t_array();
  
  v_sql                     VARCHAR2(32767);
  v_cursor                  SYS_REFCURSOR;
  v_row                     VARCHAR2(4000);
  v_num_campos              NUMBER := 1;
  v_iteration               NUMBER := 0;

  
  --v_result                  VARCHAR2(32767);
  

  --v_request_list            XX_FLA_COMMON_EXEC_REQS_T;
  --v_request_list_select     XX_FLA_COMMON_EXEC_REQS_T;
  --v_request_obj             XX_FLA_COMMON_EXEC_REQ_O;

  v_return_status           VARCHAR2(1);
  --v_json                    JSON_OBJECT_T;
  --v_keys                    JSON_KEY_LIST;
  --v_in_json                 JSON_OBJECT_T := JSON_OBJECT_T();

  --v_json_result             CLOB;
  v_msg_error               VARCHAR2(32767);
  v_req_trx_id              xx_fla_common_int_req_trx.req_trx_id%TYPE;
  
  -- ---------------------------------------------------------------------------
  -- Variables de respuesta de la API.
  -- ---------------------------------------------------------------------------  
  --v_li_arr_response         JSON_ARRAY_T;
  --v_li_obj_response         JSON_OBJECT_T;
  --v_keys_response           json_key_list;

  -- ---------------------------------------------------------------------------
  -- Declaracion de Cursores.
  -- ---------------------------------------------------------------------------
  CURSOR c_columns( p_integration_code  VARCHAR2
                   ,p_step              NUMBER 
                   ,p_root_item         VARCHAR2
                   ,p_step_object       VARCHAR2) IS
  SELECT xfcirc.column_name
  FROM xx_fla_common_int_rest_columns xfcirc
  WHERE 1 = 1
  AND xfcirc.integration_code   = p_integration_code
  AND xfcirc.step               = p_step
  AND xfcirc.root_item          = p_root_item
  AND xfcirc.step_object        = p_step_object
  AND xfcirc.enabled_flag       = 'Y';

    
BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence      := 'XX_FLA_COMMON_PRO_INT_PKG.WRITE_JSON_RESPONSE';
  x_return_status         := 'S';  
  --v_request_list          := XX_FLA_COMMON_EXEC_REQS_T();
  --v_request_list_select   := XX_FLA_COMMON_EXEC_REQS_T();
  -- ---------------------------------------------------------------------------
  -- Inicializa datos globales.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (+)'
       ,'1'
       );  
  /*DBMS_OUTPUT.put_line('Init2');  
  IF v_mesg_error IS NULL THEN
     BEGIN
       xx_global_pkg.initialize
         (p_user_name        => p_user_name
         ,p_language         => p_language
         ,p_request_id       => p_request_id
         ,p_request_phase_id => NULL
         );
       g_debug_flag := xx_debug_pkg.g_enabled;
     EXCEPTION
       WHEN others THEN
         v_mesg_error := message('XX_FLA_PROPERTY_INIT',SQLERRM);
     END;
  END IF;
  DBMS_OUTPUT.put_line('Init3'); */
  
  -- ---------------------------------------------------------------------------
  -- Despliega parametros.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (+)'
       ,'1'
       );
  debug(g_indent                     ||
        v_calling_sequence           ||
        '. Nro. del requerimiento: ' ||
        TO_CHAR(p_request_id)
       ,'1'
       );
  /*debug(g_indent                                ||
        v_calling_sequence                      ||
        '. Nro. de requerimiento de la etapa: ' ||
        TO_CHAR(p_request_phase_id)
       ,'1'
       );*/
  debug(g_indent            ||
        v_calling_sequence  ||
        '. Modo borrador: ' ||
        p_draft_flag
       ,'1'
       );
  debug(g_indent            ||
        v_calling_sequence  ||
        '. Flag de debug: ' ||
        p_debug_flag
       ,'1'
       );
  debug(g_indent                 ||
        v_calling_sequence       ||
        '. Codigo de lenguaje: ' ||
        p_language
       ,'1'
       );
  debug(g_indent           ||
        v_calling_sequence ||
        '. Usuario: '      ||
        p_user_name
       ,'1'
       );
       
  -- ---------------------------------------------------------------------------
  -- Obtiene codigo de lenguaje.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error  IS NULL THEN
     v_language := xx_global_pkg.language;
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. Codigo de lenguaje seteado: ' ||
           v_language
          ,'1'
          );
  END IF;
         
         
  DBMS_OUTPUT.put_line('Init1');       
  -- ---------------------------------------------------------------------------
  -- Logica del proceso.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error  IS NULL 
    AND p_json_response IS NOT NULL
  THEN
  
    FOR r_columns IN c_columns(p_integration_code, p_step, p_root_item, p_step_object) LOOP
        
        v_columns_select                := v_columns_select || 'jt.'|| r_columns.column_name || '||''|''||' ;
        v_columns                       := v_columns || r_columns.column_name || ' VARCHAR2(4000) PATH ''$.' || r_columns.column_name ||''',';
        v_columns_name.EXTEND;
        v_columns_name(v_num_campos)    := r_columns.column_name;   
        v_num_campos                    := v_num_campos + 1;
        
    END LOOP;
  
        v_columns_select := SUBSTR (v_columns_select,1,LENGTH (v_columns_select) -2);
        v_columns        := SUBSTR (v_columns,1,LENGTH (v_columns) -1);
        DBMS_OUTPUT.put_line('v_columns_select->'||v_columns_select); 
        DBMS_OUTPUT.put_line('v_columns->'||v_columns); 
  END IF;
  
  IF v_mesg_error           IS NULL 
    AND v_columns_select    IS NOT NULL 
    AND v_columns           IS NOT NULL 
  THEN
  
    v_sql := 
        'SELECT '   || v_columns_select || 
        ' FROM json_table('||
        '    :1,'||
        '    ''$.'|| p_root_item ||'[*]'''||
        '    COLUMNS ( ' || v_columns ||
        '    )'||
        ') jt';
  END IF;
  
  /*IF v_mesg_error   IS NULL 
    AND v_sql       IS NOT NULL 
  THEN
  
    BEGIN
        EXECUTE IMMEDIATE v_sql USING IN p_json_response INTO v_result;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
    END;
  END IF;*/
  
  --v_mesg_error:=v_sql;
  IF v_mesg_error   IS NULL 
    AND v_sql       IS NOT NULL 
  THEN
  
    BEGIN
        OPEN v_cursor FOR v_sql USING p_json_response;
    
        LOOP
            FETCH v_cursor INTO v_row;
            EXIT WHEN v_cursor%NOTFOUND;
    
            
                FOR i IN 1 .. (v_num_campos -1) LOOP

                    BEGIN
                        v_req_trx_id :=  xx_fla_common_pro_int_req_trx_s.NEXTVAL; 
                        EXCEPTION
                            WHEN OTHERS THEN
                                v_req_trx_id := NULL;
                                v_mesg_error := message('FLA_COMMON_REQ_TRX_SEQ',SQLERRM);
                                RETURN;
                    END;
              
                    
                    IF v_mesg_error IS NULL
                    THEN
                
                       insert_fla_common_int_req_trx(
                                                      p_user_name
                                                     ,v_req_trx_id
                                                     ,p_request_id
                                                     ,p_integration_code
                                                     ,p_step
                                                     ,v_iteration
                                                     ,v_columns_name(i)
                                                     ,TRIM(REGEXP_SUBSTR(v_row, '[^|]+', 1, i))
                                                     ,x_return_status
                                                     ,v_mesg_error
                                                     );

                    END IF;
                    
                    --v_mesg_error  := v_row || '-' ||  REGEXP_SUBSTR(v_row, '[^|]+', 1, i ) ||'-'||i;-- || ' - ' ||v_columns_name(i);
                END LOOP;
            -- 4. Separar los valores por campo usando REGEXP_SUBSTR
            -- Por ejemplo, para 3 campos:
            -- campo1 := REGEXP_SUBSTR(v_row, '[^|]+', 1, 1);
            -- campo2 := REGEXP_SUBSTR(v_row, '[^|]+', 1, 2);
            -- campo3 := REGEXP_SUBSTR(v_row, '[^|]+', 1, 3);
    
            -- Puedes usar un bucle para N campos si lo necesitas
    
            -- 5. Insertar en la tabla destino
            -- INSERT INTO xx_fla_common_int_req_trx (campo1, campo2, campo3)
            -- VALUES (campo1, campo2, campo3);
            
            v_iteration := v_iteration + 1;    
            
            
        END LOOP;
        CLOSE v_cursor;
        EXCEPTION
            WHEN OTHERS THEN
                v_mesg_error := SQLERRM;
    END;
  END IF;  
  
  --v_mesg_error := v_result;
  
/* Logica menor a json de 32 kb  
  IF v_mesg_error  IS NULL 
    AND p_json_response IS NOT NULL
  THEN


      -- ---------------------------------------------------------------------------
      -- Procesa respuesta.
      -- ---------------------------------------------------------------------------    
      v_json := JSON_OBJECT_T.parse(p_json_response);
      
      v_keys := v_json.get_keys;
        DBMS_OUTPUT.put_line('InitJsonCompleto->'||v_json.to_string);
      FOR j IN 1 .. v_keys.COUNT LOOP
        DBMS_OUTPUT.put_line('Init5->'||v_keys(j));
        DBMS_OUTPUT.put_line('Init5->'||v_json.get_string(v_keys(j)));
        
        v_li_arr_response := v_json.get_Array(p_root_item);
        
        FOR k IN 0 .. v_li_arr_response.get_size - 1 LOOP
        
            v_li_obj_response := JSON_OBJECT_T(v_li_arr_response.get(k));
            
            v_keys_response := v_li_obj_response.get_keys;
            
            FOR i IN 1 .. v_keys_response.COUNT LOOP
                dbms_output.put_line('InitInLoop.keys->'||v_keys_response(i));
                dbms_output.put_line('InitInLoop.values->'||v_li_obj_response.get(v_keys_response(i)).to_string);
                
                BEGIN
                    v_req_trx_id :=  xx_fla_common_pro_int_req_trx_s.NEXTVAL; 
                    EXCEPTION
                        WHEN OTHERS THEN
                            v_req_trx_id := NULL;
                            v_mesg_error := message('FLA_COMMON_REQ_TRX_SEQ',SQLERRM);
                            RETURN;
                END;
          
                
                IF v_mesg_error IS NULL
                THEN
dbms_output.put_line('INSERT->'||v_keys_response(i));
                           insert_fla_common_int_req_trx(
                                                           p_user_name
                                                          ,v_req_trx_id
                                                          ,p_request_id
                                                          ,p_integration_code
                                                          ,p_step
                                                          ,k --Iteración unica
                                                          ,TRIM(v_keys_response(i))
                                                          ,TRIM(v_li_obj_response.get(v_keys_response(i)).to_string)
                                                          ,x_return_status
                                                          ,v_mesg_error
                                                          );

                END IF;
            END LOOP;

            DBMS_OUTPUT.put_line('InitInLoop->'||v_li_obj_response.to_string);    

          END LOOP;

      END LOOP;
      




  END IF;
*/
  -- ---------------------------------------------------------------------------
  -- Verifica si se produjo un error.
  -- ---------------------------------------------------------------------------
  IF v_mesg_error IS NOT NULL THEN
     x_return_status := 'E';
     x_msg_error     := v_mesg_error;
     debug(g_indent           ||
           v_calling_sequence ||
           '. '               ||
           v_mesg_error
          ,'1'
          );
    ELSE
      
        x_return_status := 'S';
        x_msg_error     := v_mesg_error;
        
  END IF;
  -- ---------------------------------------------------------------------------
  -- Fin del proceso.
  -- ---------------------------------------------------------------------------
  debug(g_indent           ||
        v_calling_sequence ||
        ' (-)'
       ,'1'
       );
EXCEPTION
  WHEN others THEN
    v_mesg_error := v_calling_sequence  ||
                    message('XX_FLA_PROPERTY_GEN1',SQLERRM);
    debug(g_indent           ||
          v_calling_sequence ||
          '. '               ||
          v_mesg_error
         ,'1'
         );
    debug(g_indent           ||
          v_calling_sequence ||
          ' (-)'
         ,'1'
         );
    x_return_status := 'E';
    x_msg_error     := SQLERRM; --v_mesg_error;

END write_json_response;



END xx_fla_common_pro_int_pkg;
/