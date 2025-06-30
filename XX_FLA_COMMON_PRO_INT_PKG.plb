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
                                               ,1 --Iteración unica
                                               ,TRIM(v_keys(i))
                                               ,TRIM(v_jo.get_string(v_keys(i)))
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
                                  ,x_request               OUT     XX_FLA_COMMON_EXEC_REQS_T
                                  ,x_return_status         OUT     VARCHAR2
                                  ,x_msg_error             OUT     VARCHAR2
                                  )
IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4);  
  
  v_request                 VARCHAR2(32767);
  v_statement               VARCHAR2(32767);
  v_request_value           VARCHAR2(2000);
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
  v_calling_sequence      := 'XX_FLA_COMMON_PRO_INT_PKG.NEXT_STEP';
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

      FOR r_next_step IN c_next_step LOOP
      
        IF r_next_step.to_field_type = 'VALUE' THEN

                 v_statement := 'SELECT XX_FLA_COMMON_EXEC_REQ_O(xfcirt.param_value)              ' ||
                                  '  FROM dual                          ' ||   
                                  '  ,xx_fla_common_int_req_trx xfcirt  ' ||
                                  '  WHERE 1 = 1                        ' ||
                                  '  AND xfcirt.integration_code =      ''' || p_integration_code || '''' ||
                                  '  AND xfcirt.param_key        =      ''' || r_next_step.from_field || ''''  ||
                                  '  AND xfcirt.request_id       =      ''' || p_request_id || ''''  ||
                                  '  ORDER BY xfcirt.iteration ';
                 BEGIN
                   EXECUTE IMMEDIATE v_statement
                      INTO v_request_obj;
                 EXCEPTION
                   WHEN others THEN
                     DBMS_OUTPUT.put_line('EXCEPTION1');
            
                 END;

                    DBMS_OUTPUT.put_line('VALUE');
                    DBMS_OUTPUT.put_line('VALUE->'||v_request_obj.request);
                    v_request_list_select.EXTEND;
                    v_request_list_select(v_request_list_select.COUNT)  :=  v_request_obj;

            
            ELSIF r_next_step.to_field_type = 'TYPE' THEN
                
                    DBMS_OUTPUT.put_line('TYPE');
                    DBMS_OUTPUT.put_line('TYPE-z'||r_next_step.to_field);
                    v_request_list_select.EXTEND;
                    v_request_list_select(v_request_list_select.COUNT)  :=  XX_FLA_COMMON_EXEC_REQ_O(r_next_step.to_field);

            
        END IF;
         
         
         
         
      END LOOP;


     IF v_request_list_select IS NOT NULL
     THEN

        IF p_step_type = 'REST'
        THEN
        
            --v_request := r_next_step.to_field || v_request_value || ',' || v_request;
            null;
            
        ELSIF p_step_type = 'PL/SQL' THEN
        
        
        
            FOR i IN v_request_list_select.FIRST..v_request_list_select.LAST LOOP
            
                IF v_request IS NULL THEN
                    
                        v_request := v_request_list_select(i).request  ;  

                        
                    ELSE
                
                        v_request := v_request || ',' || v_request_list_select(i).request  ;  

                        
                END IF;
                
                
            END LOOP;
            
        
        END IF;

    END IF;


    IF v_mesg_error IS NULL
    THEN
        --v_request := SUBSTR (v_request,1,LENGTH (v_request) -1);
        
        
        IF p_step_type = 'REST'
            THEN
            
                v_request := '{' || v_request || '};';
                null;
                
            ELSIF p_step_type = 'PL/SQL' THEN
            
                v_request := '(' || v_request || ');';
            
            END IF;
        
    END IF;
  END IF;
  
    
    v_request_obj := NULL;
    v_request_obj := XX_FLA_COMMON_EXEC_REQ_O(v_request);


    v_request_list.EXTEND;
    v_request_list(v_request_list.COUNT)  :=  v_request_obj;


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

END create_next_step_request;


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
  
  v_request                 VARCHAR2(32767);
  v_statement               VARCHAR2(32767);
  v_request_value           VARCHAR2(2000);
  v_request_list            XX_FLA_COMMON_EXEC_REQS_T;
  v_request_list_select     XX_FLA_COMMON_EXEC_REQS_T;
  v_request_obj             XX_FLA_COMMON_EXEC_REQ_O;
  v_json_result  CLOB;
  v_stmt         VARCHAR2(1000);
  --v_values

  -- ---------------------------------------------------------------------------
  -- Declaracion de Cursores.
  -- ---------------------------------------------------------------------------
  -- ---------------------------------------------------------------------------
  -- Cursor de c_next_step.
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
    
        v_stmt := 'BEGIN ' || p_step_object || p_request(i).request || ' END;';
        EXECUTE IMMEDIATE v_stmt USING OUT v_json_result;
        -- Supón que ya tienes estos valores obtenidos:
-- v_wrapper_name: nombre completo del wrapper, ej: 'XX_FLA_PROPERTY_INT_PKG.wrap_get_countries_json'
-- v_param1 ... v_paramN: parámetros de entrada, según tu integración
-- v_json_result: CLOB resultado

/*DECLARE

  v_req_trx_id   xx_fla_common_int_req_trx.req_trx_id%TYPE;
BEGIN
  -- Construcción dinámica del statement para llamar al wrapper
  v_stmt := 'BEGIN ' || v_wrapper_name || '(:1, :2, :3, :4, :5, :6, :7, :8); END;';

  EXECUTE IMMEDIATE v_stmt
    USING IN v_param1, IN v_param2, IN v_param3, IN v_param4,
          IN v_param5, IN v_param6, IN v_param7, OUT v_json_result;

  -- Insertar el resultado en la tabla de tracking
  v_req_trx_id := xx_fla_common_pro_int_req_trx_s.NEXTVAL;
  INSERT INTO xx_fla_common_int_req_trx (
      req_trx_id, request_id, integration_code, trx_date, called_proc, json_result
  ) VALUES (
      v_req_trx_id, p_request_id, p_integration_code, SYSDATE, v_wrapper_name, v_json_result
  );

  x_return_status := 'S';
  x_msg_error := NULL;

EXCEPTION
  WHEN OTHERS THEN
    x_return_status := 'E';
    x_msg_error := SQLERRM;
END;*/
        
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
      
        --x_request := v_request_list;  
       null; 
        
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

END execute_pl_request;


END xx_fla_common_pro_int_pkg;
/