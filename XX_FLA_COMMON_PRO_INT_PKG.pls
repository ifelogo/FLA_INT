CREATE OR REPLACE PACKAGE xx_fla_common_pro_int_pkg AS

-- -----------------------------------------------------------------------------
-- Variables Globales.
-- -----------------------------------------------------------------------------
  g_module     VARCHAR2(30)   := 'FLA_COMMON_PROPERTY_INT';
  g_debug_flag VARCHAR2(1)    := 'N';
  g_indent     VARCHAR2(2000) := '';
  g_msg_del    VARCHAR2(1)    := '#';
  TYPE g_messages IS TABLE OF VARCHAR2(4000) INDEX BY VARCHAR2(300);


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
                       );

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
|    p_integration_code     IN      VARCHAR2 Codigo del pais.                  |
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
                        );

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
                                  );
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
                             );
END xx_fla_common_pro_int_pkg;
/                                   