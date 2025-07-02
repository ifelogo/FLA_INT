CREATE OR REPLACE PACKAGE xx_fla_property_int_pkg AS

-- -----------------------------------------------------------------------------
-- Variables Globales.
-- -----------------------------------------------------------------------------
  g_module     VARCHAR2(30)   := 'FLA_PROPERTY_INT';
  g_debug_flag VARCHAR2(1)    := 'N';
  g_indent     VARCHAR2(2000) := '';
  g_msg_del    VARCHAR2(1)    := '#';
  TYPE g_messages IS TABLE OF VARCHAR2(4000) INDEX BY VARCHAR2(300);


/*=========================================================================+
|                                                                          |
| Public Procedure                                                         |
|    GET_ITEMS_GROUPS                                                      |
|                                                                          |
| Description                                                              |
|    (descripcion del procedimiento)                                       |
|                                                                          |
| Parameters                                                               |
|    p_request_id        IN     NUMBER   Nro. del requerimiento.           |
|    p_request_phase_id  IN     NUMBER   Nro. de requerimiento de la etapa.|
|    p_draft_flag        IN     VARCHAR2 Modo borrador.                    |
|    p_debug_flag        IN     VARCHAR2 Flag de debug.                    |
|    p_language          IN     VARCHAR2 Codigo de lenguaje.               |
|    p_user_name         IN     VARCHAR2 Usuario.                          |
|    p_previous_months   IN     NUMBER   Cantidad de meses previos.        |
|    p_country_code      IN     VARCHAR2 Codigo de pais.                   |
|    p_org_id            IN     NUMBER   Id de unidad operativa.           |
|    p_grp_item_id       IN     NUMBER   Id de grupo de item.              |
|    p_store_acronym     IN     VARCHAR2 Acronimo de local.                |
|    p_store_cost_center IN     VARCHAR2 Centro de costo de local.         |
|    p_item_id           IN     NUMBER   Id de item.                       |
|    x_items             OUT    XX_FLA_ITEMS_GROUPS_T Listado de           | 
|                                           grupo items.                   |
|    x_return_status     OUT    VARCHAR2 Estado de ejecucion.              |
|    x_msg_error         OUT    VARCHAR2 Mensaje de error.                 |
|                                                                          |
+=========================================================================*/
PROCEDURE get_items_groups(p_request_id        IN     NUMBER
                          ,p_request_phase_id  IN     NUMBER
                          ,p_draft_flag        IN     VARCHAR2
                          ,p_debug_flag        IN     VARCHAR2
                          ,p_language          IN     VARCHAR2
                          ,p_user_name         IN     VARCHAR2
                          ,p_previous_months   IN     NUMBER
                          ,p_country_code      IN     VARCHAR2
                          ,p_org_id            IN     NUMBER
                          ,p_grp_item_id       IN     NUMBER
                          ,p_store_acronym     IN     VARCHAR2
                          ,p_store_cost_center IN     VARCHAR2
                          ,p_item_id           IN     NUMBER
                          ,x_items             OUT    XX_FLA_ITEMS_GROUPS_T 
                          ,x_return_status     OUT    VARCHAR2
                          ,x_msg_error         OUT    VARCHAR2
                          );


/*=========================================================================+
|                                                                          |
| Public Procedure                                                         |
|    CREATE_UPDATE_ITEM_PRICES                                             |
|                                                                          |
| Description                                                              |
|    (descripcion del procedimiento)                                       |
|                                                                          |
| Parameters                                                               |
|    p_request_id       IN      NUMBER   Nro. del requerimiento.           |
|    p_request_phase_id IN      NUMBER   Nro. de requerimiento de la etapa.|
|    p_draft_flag       IN      VARCHAR2 Modo borrador.                    |
|    p_debug_flag       IN      VARCHAR2 Flag de debug.                    |
|    p_language         IN      VARCHAR2 Codigo de lenguaje.               |
|    p_user_name        IN      VARCHAR2 Usuario.                          |
|    p_country_code     IN      VARCHAR2 Código del pais.                  |
|    p_items            IN      XX_FLA_ITEM_PRICES_T Listado de precios.   |
|    x_items            OUT     XX_FLA_ITEM_PRICES_T Listado de precios.   |
|    x_return_status    OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error        OUT     VARCHAR2 Mensaje de error.                 |
|                                                                          |
+=========================================================================*/
PROCEDURE create_update_item_prices(p_request_id       IN      NUMBER
                                   ,p_request_phase_id IN      NUMBER
                                   ,p_draft_flag       IN      VARCHAR2
                                   ,p_debug_flag       IN      VARCHAR2
                                   ,p_language         IN      VARCHAR2
                                   ,p_user_name        IN      VARCHAR2
                                   ,p_country_code     IN      VARCHAR2
                                   ,p_items            IN      XX_FLA_ITEM_PRICES_T 
                                   ,x_items            OUT     XX_FLA_ITEM_PRICES_T 
                                   ,x_return_status    OUT     VARCHAR2
                                   ,x_msg_error        OUT     VARCHAR2
                                   );

/*=========================================================================+
|                                                                          |
| Public Procedure                                                         |
|    CREATE_UPDATE_ITEMS                                                   |
|                                                                          |
| Description                                                              |
|    (descripcion del procedimiento)                                       |
|                                                                          |
| Parameters                                                               |
|    p_request_id       IN      NUMBER   Nro. del requerimiento.           |
|    p_request_phase_id IN      NUMBER   Nro. de requerimiento de la etapa.|
|    p_draft_flag       IN      VARCHAR2 Modo borrador.                    |
|    p_debug_flag       IN      VARCHAR2 Flag de debug.                    |
|    p_language         IN      VARCHAR2 Codigo de lenguaje.               |
|    p_user_name        IN      VARCHAR2 Usuario.                          |
|    p_items            IN      XX_FLA_ITEMS_T Listado de items.           |
|    x_items            OUT     XX_FLA_ITEMS_T Listado de items.           |
|    x_return_status    OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error        OUT     VARCHAR2 Mensaje de error.                 |
|                                                                          |
+=========================================================================*/
PROCEDURE create_update_items(p_request_id       IN      NUMBER
                             ,p_request_phase_id IN      NUMBER
                             ,p_draft_flag       IN      VARCHAR2
                             ,p_debug_flag       IN      VARCHAR2
                             ,p_language         IN      VARCHAR2
                             ,p_user_name        IN      VARCHAR2
                             ,p_items            IN      XX_FLA_ITEMS_T 
                             ,x_items            OUT     XX_FLA_ITEMS_T 
                             ,x_return_status    OUT     VARCHAR2
                             ,x_msg_error        OUT     VARCHAR2
                             );


/*=========================================================================+
|                                                                          |
| Public Procedure                                                         |
|    CREATE_UPDATE_ITEMS                                                   |
|                                                                          |
| Description                                                              |
|    (descripcion del procedimiento)                                       |
|                                                                          |
| Parameters                                                               |
|    p_request_id       IN      NUMBER   Nro. del requerimiento.           |
|    p_request_phase_id IN      NUMBER   Nro. de requerimiento de la etapa.|
|    p_draft_flag       IN      VARCHAR2 Modo borrador.                    |
|    p_debug_flag       IN      VARCHAR2 Flag de debug.                    |
|    p_language         IN      VARCHAR2 Codigo de lenguaje.               |
|    p_user_name        IN      VARCHAR2 Usuario.                          |
|    p_items            IN      XX_FLA_ITEMS_T Listado de items.           |
|    x_items            OUT     XX_FLA_ITEMS_T Listado de items.           |
|    x_return_status    OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error        OUT     VARCHAR2 Mensaje de error.                 |
|                                                                          |
+=========================================================================*/
PROCEDURE wrap_create_update_items_json(p_request_id       IN      VARCHAR2
                             ,p_draft_flag       IN      VARCHAR2
                             ,p_debug_flag       IN      VARCHAR2
                             ,p_language         IN      VARCHAR2
                             ,p_user_name        IN      VARCHAR2
                             ,p_json_in           IN  VARCHAR2
                             ,x_json_result       OUT CLOB
                             ,x_return_status     OUT     VARCHAR2
                             ,x_msg_error         OUT     VARCHAR2
                             );

/*=========================================================================+
|                                                                          |
| Public Procedure                                                         |
|    GET_INDEXES                                                           |
|                                                                          |
| Description                                                              |
|    (descripcion del procedimiento)                                       |
|                                                                          |
| Parameters                                                               |
|    p_request_id       IN      NUMBER   Nro. del requerimiento.           |
|    p_request_phase_id IN      NUMBER   Nro. de requerimiento de la etapa.|
|    p_draft_flag       IN      VARCHAR2 Modo borrador.                    |
|    p_debug_flag       IN      VARCHAR2 Flag de debug.                    |
|    p_language         IN      VARCHAR2 Codigo de lenguaje.               |
|    p_user_name        IN      VARCHAR2 Usuario.                          |
|    p_year             IN      VARCHAR2 Año del indice.                   |
|    p_index_type       IN      VARCHAR2 Tipo de indice.                   |
|    x_items            OUT     XX_FLA_INDEXES_T Listado de paises.        |
|    x_return_status    OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error        OUT     VARCHAR2 Mensaje de error.                 |
|                                                                          |
+=========================================================================*/
PROCEDURE get_indexes (p_request_id       IN      NUMBER
                      ,p_request_phase_id IN      NUMBER
                      ,p_draft_flag       IN      VARCHAR2
                      ,p_debug_flag       IN      VARCHAR2
                      ,p_language         IN      VARCHAR2
                      ,p_user_name        IN      VARCHAR2
                      ,p_year             IN      VARCHAR2
                      ,p_index_type       IN      VARCHAR2
                      ,x_items            OUT     XX_FLA_INDEXES_T 
                      ,x_return_status    OUT     VARCHAR2
                      ,x_msg_error        OUT     VARCHAR2
                      );


PROCEDURE wrap_get_countries_json ( p_request_id        IN      VARCHAR2
                                   ,p_draft_flag        IN      VARCHAR2
                                   ,p_debug_flag        IN      VARCHAR2
                                   ,p_language          IN      VARCHAR2
                                   ,p_user_name         IN      VARCHAR2
                                   ,p_json_in           IN  VARCHAR2
                                   ,x_json_result       OUT CLOB
                                   ,x_return_status     OUT     VARCHAR2
                                   ,x_msg_error         OUT     VARCHAR2
                                    );


/*=========================================================================+
|                                                                          |
| Public Procedure                                                         |
|    GET_COUNTRIES                                                         |
|                                                                          |
| Description                                                              |
|    (descripcion del procedimiento)                                       |
|                                                                          |
| Parameters                                                               |
|    p_request_id       IN      VARCHAR2   Nro. del requerimiento.           |
|    p_request_phase_id IN      VARCHAR2   Nro. de requerimiento de la etapa.|
|    p_draft_flag       IN      VARCHAR2 Modo borrador.                    |
|    p_debug_flag       IN      VARCHAR2 Flag de debug.                    |
|    p_language         IN      VARCHAR2 Codigo de lenguaje.               |
|    p_user_name        IN      VARCHAR2 Usuario.                          |
|    p_country_code     IN      VARCHAR2 Codigo del pais.                  |
|    x_items            OUT     XX_FLA_COUNTRIES_T Listado de paises.      |
|    x_return_status    OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error        OUT     VARCHAR2 Mensaje de error.                 |
|                                                                          |
+=========================================================================*/
PROCEDURE get_countries(p_request_id       IN      VARCHAR2
                       ,p_request_phase_id IN      VARCHAR2
                       ,p_draft_flag       IN      VARCHAR2
                       ,p_debug_flag       IN      VARCHAR2
                       ,p_language         IN      VARCHAR2
                       ,p_user_name        IN      VARCHAR2
                       ,p_country_code     IN      VARCHAR2
                       ,x_items            OUT     XX_FLA_COUNTRIES_T 
                       ,x_return_status    OUT     VARCHAR2
                       ,x_msg_error        OUT     VARCHAR2
                       );

/*=========================================================================+
|                                                                          |
| Public Procedure                                                         |
|    GET_SALES_COUNTRIES                                                   |
|                                                                          |
| Description                                                              |
|    (descripcion del procedimiento)                                       |
|                                                                          |
| Parameters                                                               |
|    p_request_id       IN      NUMBER   Nro. del requerimiento.           |
|    p_request_phase_id IN      NUMBER   Nro. de requerimiento de la etapa.|
|    p_draft_flag       IN      VARCHAR2 Modo borrador.                    |
|    p_debug_flag       IN      VARCHAR2 Flag de debug.                    |
|    p_language         IN      VARCHAR2 Codigo de lenguaje.               |
|    p_user_name        IN      VARCHAR2 Usuario.                          |
|    p_country_code     IN      VARCHAR2 Codigo del pais.                  |
|    p_init_date        IN      DATE Fecha inicio.                         |
|    p_end_date         IN      DATE Fecha Fin.                            |
|    x_items            OUT     XX_FLA_SALES_COUNTRIES_T Listado de paises.|
|    x_sales_str        OUT     XX_FLA_SALES_UNIQUE_REPORT_T               | 
|                                           Listado de registros resultado.|
|    x_sales_taxes_str  OUT     XX_FLA_SALES_TAXES_UNIQUE_REPORT_T         | 
|                                           Listado de registros resultado.|
|    x_return_status    OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error        OUT     VARCHAR2 Mensaje de error.                 |
|                                                                          |
+=========================================================================*/
PROCEDURE get_sales_countries(p_request_id       IN      NUMBER
                             ,p_request_phase_id IN      NUMBER
                             ,p_draft_flag       IN      VARCHAR2
                             ,p_debug_flag       IN      VARCHAR2
                             ,p_language         IN      VARCHAR2
                             ,p_user_name        IN      VARCHAR2
                             ,p_country_code     IN      VARCHAR2
                             ,p_init_date        IN      DATE
                             ,p_end_date         IN      DATE
                             ,x_items            OUT     XX_FLA_SALES_COUNTRIES_T
                             ,x_sales_str        OUT     XX_FLA_SALES_UNIQUE_REPORT_T
                             ,x_sales_taxes_str  OUT     XX_FLA_SALES_TAXES_UNIQUE_REPORT_T
                             ,x_return_status    OUT     VARCHAR2
                             ,x_msg_error        OUT     VARCHAR2
                             );
/*=========================================================================+
|                                                                          |
| Public Procedure                                                         |
|    CREATE_UPDATE_SALES                                                   |
|                                                                          |
| Description                                                              |
|    (descripcion del procedimiento)                                       |
|                                                                          |
| Parameters                                                               |
|    p_request_id       IN      NUMBER   Nro. del requerimiento.           |
|    p_request_phase_id IN      NUMBER   Nro. de requerimiento de la etapa.|
|    p_draft_flag       IN      VARCHAR2 Modo borrador.                    |
|    p_debug_flag       IN      VARCHAR2 Flag de debug.                    |
|    p_language         IN      VARCHAR2 Codigo de lenguaje.               |
|    p_user_name        IN      VARCHAR2 Usuario.                          |
|    p_items            IN      XX_FLA_SALES_T Listado de precios.         |
|    x_items            OUT     XX_FLA_SALES_T Listado de precios.         |
|    x_return_status    OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error        OUT     VARCHAR2 Mensaje de error.                 |
|                                                                          |
+=========================================================================*/
PROCEDURE create_update_sales(p_request_id       IN      NUMBER
                             ,p_request_phase_id IN      NUMBER
                             ,p_draft_flag       IN      VARCHAR2
                             ,p_debug_flag       IN      VARCHAR2
                             ,p_language         IN      VARCHAR2
                             ,p_user_name        IN      VARCHAR2
                             ,p_items            IN      XX_FLA_SALES_T 
                             ,x_items            OUT     XX_FLA_SALES_T 
                             ,x_return_status    OUT     VARCHAR2
                             ,x_msg_error        OUT     VARCHAR2
                             );


/*=========================================================================+
|                                                                          |
| Public Procedure                                                         |
|    CREATE_UPDATE_SALES_TAXES                                             |
|                                                                          |
| Description                                                              |
|    (descripcion del procedimiento)                                       |
|                                                                          |
| Parameters                                                               |
|    p_request_id       IN      NUMBER   Nro. del requerimiento.           |
|    p_request_phase_id IN      NUMBER   Nro. de requerimiento de la etapa.|
|    p_draft_flag       IN      VARCHAR2 Modo borrador.                    |
|    p_debug_flag       IN      VARCHAR2 Flag de debug.                    |
|    p_language         IN      VARCHAR2 Codigo de lenguaje.               |
|    p_user_name        IN      VARCHAR2 Usuario.                          |
|    p_items            IN      XX_FLA_SALES_TAXES_T Listado de impúestos  |
|                                           ventas.                        |
|    x_items            OUT     XX_FLA_SALES_TAXES_T Listado de impuestos  |
|                                           ventas.                        |
|    x_return_status    OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error        OUT     VARCHAR2 Mensaje de error.                 |
|                                                                          |
+=========================================================================*/
PROCEDURE create_update_sales_taxes ( p_request_id       IN      NUMBER
                                     ,p_request_phase_id IN      NUMBER
                                     ,p_draft_flag       IN      VARCHAR2
                                     ,p_debug_flag       IN      VARCHAR2
                                     ,p_language         IN      VARCHAR2
                                     ,p_user_name        IN      VARCHAR2
                                     ,p_sales_taxes      IN      XX_FLA_SALES_TAXES_T 
                                     ,x_items            OUT     XX_FLA_SALES_TAXES_T 
                                     ,x_return_status    OUT     VARCHAR2
                                     ,x_msg_error        OUT     VARCHAR2
                                     );



/*=========================================================================+
|                                                                          |
| Public Procedure                                                         |
|    CREATE_UPDATE_INDEX_HISTORY_LINES                                     |
|                                                                          |
| Description                                                              |
|    (descripcion del procedimiento)                                       |
|                                                                          |
| Parameters                                                               |
|    p_request_id       IN      NUMBER   Nro. del requerimiento.           |
|    p_request_phase_id IN      NUMBER   Nro. de requerimiento de la etapa.|
|    p_draft_flag       IN      VARCHAR2 Modo borrador.                    |
|    p_debug_flag       IN      VARCHAR2 Flag de debug.                    |
|    p_language         IN      VARCHAR2 Codigo de lenguaje.               |
|    p_user_name        IN      VARCHAR2 Usuario.                          |
|    p_year             IN      VARCHAR2 Año del indice.                   |
|    p_items            IN      XX_FLA_INDEX_HISTORY_LINES_T               |
|                                   Listado de actualización de indices.   |
|    x_items            OUT     XX_FLA_INDEX_HISTORY_LINES_T               | 
|                                   Listado de actualización de indices.   |
|    x_return_status    OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error        OUT     VARCHAR2 Mensaje de error.                 |
|                                                                          |
+=========================================================================*/
PROCEDURE create_update_index_history_lines(p_request_id       IN      NUMBER
                                           ,p_request_phase_id IN      NUMBER
                                           ,p_draft_flag       IN      VARCHAR2
                                           ,p_debug_flag       IN      VARCHAR2
                                           ,p_language         IN      VARCHAR2
                                           ,p_user_name        IN      VARCHAR2
                                           ,p_year             IN      VARCHAR2
                                           ,p_items            IN      XX_FLA_INDEX_HISTORY_LINES_T 
                                           ,x_items            OUT     XX_FLA_INDEX_HISTORY_LINES_T 
                                           ,x_return_status    OUT     VARCHAR2
                                           ,x_msg_error        OUT     VARCHAR2
                                           );



END xx_fla_property_int_pkg;
/                                   