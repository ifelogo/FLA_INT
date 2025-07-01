CREATE OR REPLACE PACKAGE BODY xx_fla_property_int_pkg AS
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
                          )
IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4);  
  
  v_item                    XX_FLA_ITEM_GROUP_O;
  v_items                   XX_FLA_ITEMS_GROUPS_T; 
  v_item_code_list          VARCHAR2(4000);

  -- ---------------------------------------------------------------------------
  -- Declaracion de Cursores.
  -- ---------------------------------------------------------------------------
  -- ---------------------------------------------------------------------------
  -- Cursor de paises.
  -- ---------------------------------------------------------------------------
    CURSOR c_grp_items ( p_country_code         VARCHAR2 
                        ,p_org_id               NUMBER
                        ,p_grp_item_id          NUMBER
                        ,p_store_acronym        VARCHAR2
                        ,p_store_cost_center    VARCHAR2
                        ,p_item_id              NUMBER) IS
    SELECT DISTINCT 
           ft.territory_code
          ,ft.territory_short_name
          ,xpcn.country_num        territory_num
          ,xpgi.org_id
          ,hou.org_u_tl_name                org_name
          ,xpgi.grp_item_id
          ,xpgi.grp_item_code
          ,xpgi.description        grp_item_desc
          ,xpgi.store_acronym
          ,xpgi.store_cost_center
          ,xpgi.day_reference
      FROM dual
          ,fnd_territories    ft
          ,xx_pn_countries       xpcn
          ,hr_organization_units hou
          ,xx_pn_grp_items_all   xpgi
     WHERE 1 = 1
       AND xpgi.grp_item_id       = NVL(p_grp_item_id,xpgi.grp_item_id)
       AND xpgi.store_acronym     = NVL(p_store_acronym,xpgi.store_acronym)
       AND xpgi.store_cost_center = NVL(p_store_cost_center,xpgi.store_cost_center)
       AND xpgi.org_id            = NVL(p_org_id,xpgi.org_id)
       AND xpcn.country_code     IN
           (
            SELECT xpcm.country_code
              FROM xx_pn_companies xpcm
             WHERE 1 = 1
               AND xpgi.org_id = xpcm.org_id
           )
       AND xpgi.org_id            = hou.org_id(+)
       AND xpcn.country_code      = NVL(p_country_code
                                       ,xpcn.country_code
                                       )
       AND xpcn.country_code      = ft.territory_code
       AND EXISTS
           (
            SELECT 1
              FROM xx_fla_items              xfi
                  ,xx_pn_grp_item_lines_all xpgil
             WHERE 1 = 1
               AND xpgi.grp_item_id = xpgil.grp_item_id
               AND xpgil.item_id    = NVL(p_item_id
                                         ,xpgil.item_id
                                         )
               AND xpgil.item_id    = xfi.item_id
               AND xfi.enabled_flag = 'Y'
               --AND ROWNUM < 1
           )
     ORDER BY
           ft.territory_code
          ,hou.org_u_tl_name
          ,xpgi.grp_item_code;

  -- ---------------------------------------------------------------------------
  -- Cursor de fechas de referencia.
  -- ---------------------------------------------------------------------------
  CURSOR c_reference_dates (
                            p_day_reference IN NUMBER
                           ) IS
    SELECT b.reference_date
      FROM (
            SELECT ADD_MONTHS(TO_DATE(DECODE(p_day_reference
                                            ,29,TO_CHAR(LAST_DAY(SYSDATE)
                                                       ,'DD'
                                                       )
                                            ,30,TO_CHAR(LAST_DAY(SYSDATE)
                                                       ,'DD'
                                                       )
                                            ,31,TO_CHAR(LAST_DAY(SYSDATE)
                                                       ,'DD'
                                                       )
                                            ,TO_CHAR(p_day_reference)
                                            )          ||
                                      '-'              ||
                                      TO_CHAR(SYSDATE
                                             ,'MM-YYYY'
                                             )
                                     ,'DD-MM-YYYY'
                                     )
                             ,a.month_num
                             )            reference_date
               FROM (
                     SELECT (ROWNUM*-1)+1 month_num
                       FROM fnd_lookup_values
                      WHERE 1 = 1
                        AND ROWNUM <= p_previous_months
                    ) a
              WHERE 1 = 1
           ) b
     WHERE 1 = 1
       AND b.reference_date <= SYSDATE
       --AND ROWNUM < 10
     ORDER BY
           b.reference_date;

BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence := 'XX_FLA_PROPERTY_INT_PKG.GET_ITEMS_GROUPS';
  x_return_status    := 'S';
  v_items            :=  XX_FLA_ITEMS_GROUPS_T(); 
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

         v_mesg_error :=  message('XX_FLA_PROPERTY_INIT',SQLERRM);  
                         
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
  IF v_mesg_error  IS NULL 
  THEN
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. Código de pais: ' ||
           p_country_code
          ,'1'
          );
  END IF;
         

  FOR r_grp_item IN c_grp_items ( p_country_code
                                 ,p_org_id      
                                 ,p_grp_item_id 
                                 ,p_store_acronym
                                 ,p_store_cost_center
                                 ,p_item_id) LOOP
  
      IF v_mesg_error  IS NULL 
      THEN
         debug(g_indent                         ||
               v_calling_sequence               ||
               '. Código de territorio: ' ||
               r_grp_item.territory_num
              ,'1'
              );
      END IF;

         debug(g_indent                         ||
               v_calling_sequence               ||
               '. Código de grp_item_id: ' ||
               r_grp_item.grp_item_id
              ,'1'
              );      
      
      
             -- ----------------------------------------------------------------
             -- Obtiene los items.
             -- ----------------------------------------------------------------}
             v_item_code_list   := NULL;
             BEGIN
               SELECT LISTAGG(xfi.item_code
                             ,','
                             )
                      WITHIN GROUP (ORDER BY xfi.item_code
                                   ) item_code_list
                 INTO v_item_code_list
                 FROM xx_fla_items             xfi
                     ,xx_pn_grp_item_lines_all xpgil
                WHERE 1 = 1
                  AND xpgil.grp_item_id = r_grp_item.grp_item_id
                  AND xpgil.item_id     = xfi.item_id
                  AND xfi.enabled_flag  = 'Y';
             EXCEPTION
               WHEN others THEN
                 v_mesg_error := message('ITEMS_GROUP_FOUND',r_grp_item.grp_item_id||g_msg_del||SQLERRM);
                 EXIT;
             END;
             IF v_item_code_list IS NULL THEN
                v_mesg_error := message('ITEMS_GROUP_NOT_FOUND',r_grp_item.grp_item_id);
                EXIT;
             END IF;

      
        debug(g_indent           ||
        v_calling_sequence ||
        '. Before Loop: '
       ,'1'
       );
      FOR r_reference_date IN c_reference_dates(r_grp_item.day_reference) LOOP

        debug(g_indent           ||
        v_calling_sequence ||
        '. Inside Loop: '   ||
        r_grp_item.day_reference
       ,'1'
       );
      
                v_item    := NULL;
                v_item    := xx_fla_item_group_o(
                                                 r_grp_item.territory_code
                                                ,r_grp_item.territory_num
                                                ,r_grp_item.org_name --
                                                ,r_grp_item.grp_item_id
                                                ,r_grp_item.grp_item_desc --
                                                ,r_grp_item.store_acronym--
                                                ,r_grp_item.store_cost_center
                                                ,r_grp_item.day_reference
                                                ,v_item_code_list
                                                ,r_reference_date.reference_date	
                                                ); 
        
                v_items.EXTEND;
                v_items(v_items.COUNT)  :=  v_item;      
        
        
      END LOOP;
      
  
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
        
        x_items := v_items;  
                  
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

END get_items_groups;
/*=========================================================================+
|                                                                          |
| Public Procedure                                                         |
|    GET_ITEM                                                              |
|                                                                          |
| Description                                                              |
|    (descripcion del procedimiento)                                       |
|                                                                          |
| Parameters                                                               |
|    p_country_code         IN     VARCHAR2   Código de país.              |
|    p_item_code            IN     NUMBER     Código de producto.          |
|    x_item_id              IN     NUMBER     Identificador de código      | 
|                                               de producto.               |
|    x_found                OUT    BOOLEAN    Flag que indica si           |
|                                               encontro el registro.      |
|    x_msg_error            OUT    VARCHAR2   Mensaje de error.            |
|                                                                          |
+=========================================================================*/
PROCEDURE get_item( 
                    p_country_code      IN      VARCHAR2
                   ,p_item_code         IN      NUMBER
                   ,x_item_id           OUT     NUMBER
                   ,x_found             OUT     BOOLEAN
                   ,x_mesg_error        OUT     VARCHAR2
                    ) IS 
                    
                    
  v_calling_sequence        VARCHAR2(2000);
  v_item_id                 NUMBER;  
  v_mesg_error              VARCHAR2(32767);
  v_found                   BOOLEAN;
  
  
BEGIN

  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence := 'XX_FLA_PROPERTY_INT_PKG.GET_ITEM';


    BEGIN
        v_found      := TRUE;
        SELECT xfi.item_id
        INTO v_item_id
        FROM dual
            ,xx_fla_items xfi
        WHERE 1 = 1
        AND xfi.country_code =  p_country_code
        AND xfi.item_code    =  p_item_code
        AND ROWNUM           =  1;
        
        
        EXCEPTION
        
            WHEN NO_DATA_FOUND THEN                
               v_item_id    := NULL; 
               v_found      := FALSE;
               
            WHEN OTHERS THEN
               v_item_id    := NULL;
               v_mesg_error := message('ITEMS_FOUND',p_item_code||g_msg_del||SQLERRM);
               --v_mesg_error := SQLERRM;
               v_found      := FALSE;


    END;    

    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida v_item_id: '                  ||
            v_item_id
           ,'1'
           );

    END IF;    
    IF v_mesg_error IS NULL
       AND v_item_id IS NULL
       THEN

        BEGIN
            
                v_item_id   := xx_fla_items_s.NEXTVAL;
                v_found     := FALSE;

            
            EXCEPTION
                
                WHEN OTHERS THEN
                    v_mesg_error := message('XX_FLA_ITEMS_SEQ',SQLERRM);
                    v_found      := FALSE;

                    
        END; 

        
    END IF;

    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. get_item.Ok: '                  
           ,'1'
           );
        
            x_item_id   := v_item_id;
            x_found     := v_found;
            
        ELSE
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. get_item.error: '                  
           ,'1'
           );
        
            x_item_id       := NULL;
            x_found         := FALSE;
            x_mesg_error    := v_mesg_error;
    END IF;

END get_item;

/*=========================================================================+
|                                                                          |
| Public Procedure                                                         |
|    GET_ITEM_PRICE                                                        |
|                                                                          |
| Description                                                              |
|    (descripcion del procedimiento)                                       |
|                                                                          |
| Parameters                                                               |
|    p_item_code            IN     NUMBER   Código del item.               |
|    p_store_acronym        IN     VARCHAR2 Sigla de local.                |
|    p_store_cost_center    IN     VARCHAR2 Centro de Costos del local.    |
|    p_reference_date       IN     DATE     Fecha del precio.              |
|    p_country_code         IN     VARCHAR2 Código del pais.               |
|    x_item_price_id        IN     NUMBER   Identificador del item price.  |
|    x_found                OUT    BOOLEAN  Flag que indica si             |
|                                               encontro el registro.      |
|    x_msg_error        OUT     VARCHAR2 Mensaje de error.                 |
|                                                                          |
+=========================================================================*/
PROCEDURE get_item_price( 
                            p_item_code         IN      VARCHAR2
                           ,p_store_acronym     IN      VARCHAR2
                           ,p_store_cost_center IN      VARCHAR2
                           ,p_reference_date    IN      DATE
                           ,p_country_code      IN      VARCHAR2
                           ,x_item_price_id     OUT     NUMBER
                           ,x_found             OUT     BOOLEAN
                           ,x_mesg_error        OUT     VARCHAR2
                          ) IS 

  v_calling_sequence        VARCHAR2(2000);
  v_item_price_id           VARCHAR2(200);  
  v_mesg_error              VARCHAR2(32767);
  v_found                   BOOLEAN;
  
  
BEGIN

  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence := 'XX_FLA_PROPERTY_INT_PKG.GET_ITEM_PRICE';



    BEGIN
        SELECT xfip.item_price_id              
        INTO v_item_price_id
        FROM dual
            ,xx_fla_item_prices xfip
            ,xx_fla_items        xfi
        WHERE 1 = 1
        AND xfip.store_acronym          =   p_store_acronym
        AND xfip.store_cost_center      =   p_store_cost_center
        AND TRUNC(xfip.reference_date)  =   TRUNC(p_reference_date)
        AND xfip.item_id                =   xfi.item_id
        AND xfi.item_code               =   p_item_code
        AND xfi.country_code            =   p_country_code
        AND ROWNUM                      =   1;
        
        
        v_found      := TRUE;
        
        EXCEPTION
        
            WHEN NO_DATA_FOUND THEN                
               v_item_price_id  := NULL; 
               v_found          := FALSE;
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida No_data_found ' 
           ,'1'
           );

            WHEN OTHERS THEN
               v_item_price_id  := NULL;
               v_mesg_error     := message('ITEM_PRICES_FOUND',p_item_code||g_msg_del||SQLERRM);
               v_found          := FALSE;

      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida Others ' || SQLERRM
           ,'1'
           );
    END;    
 
 
    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida item_prices_id: '             ||
            v_item_price_id
           ,'1'
           );

    END IF; 

    
    IF v_mesg_error IS NULL
       AND v_item_price_id IS NULL THEN

        BEGIN
            
                v_item_price_id := xx_fla_item_prices_s.NEXTVAL + 10000;
                v_found         := FALSE;
            
            EXCEPTION
                
                WHEN OTHERS THEN
                    v_mesg_error := message('XX_FLA_ITEM_PRICES_SEQ',SQLERRM);
                    v_found      := FALSE;
        END; 

        
    END IF;


    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. get_item_price.Ok: '                  
           ,'1'
           );
    END IF;

    IF v_mesg_error IS NULL
    THEN
        
            x_item_price_id := v_item_price_id;
            x_found         := v_found;
            
        ELSE
        
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. get_item_price.error: '                  
           ,'1'
           );
            x_item_price_id := NULL;
            x_found         := FALSE;
            x_mesg_error    := v_mesg_error;
    END IF;

END get_item_price;



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
                                   )
IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4);  
  v_item_price              XX_FLA_ITEM_PRICES_O;
  v_item_prices             XX_FLA_ITEM_PRICES_T;
  
  v_item_price_id           xx_fla_item_prices.item_price_id%TYPE;
  v_item_id                 xx_fla_items.item_id%TYPE;
  v_description             xx_fla_items.description%TYPE;
  v_item_price_found        BOOLEAN;
  
  
BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence := 'XX_FLA_PROPERTY_INT_PKG.CREATE_UPDATE_ITEM_PRICES';
  x_return_status    := 'S';
  v_item_prices      := XX_FLA_ITEM_PRICES_T();
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

  IF v_mesg_error   IS NULL
     AND p_items    IS NULL THEN
    
    v_mesg_error := message('P_ITEM_PRICES_REQ');
    
  END IF;


  IF v_mesg_error       IS NULL
     AND p_items.COUNT  < 0 THEN
    
    v_mesg_error := message('P_ITEM_PRICES_REQ');
    
  END IF;


  IF v_mesg_error       IS NULL     
     AND p_items.COUNT  > 0 THEN
    
    FOR i IN 1 .. p_items.COUNT LOOP
        
      -- ---------------------------------------------------------------------------
      -- Obtiene item_price_id.
      -- ---------------------------------------------------------------------------
      v_item_price_id   := -1;
      IF v_mesg_error IS NULL 
         AND NVL(p_draft_flag,'Y') = 'N'
      THEN




            IF v_mesg_error IS NULL
            THEN
              debug(g_indent                                ||
                    v_calling_sequence                      ||
                    '. Valida item_code: '              ||
                    p_items(i).item_code
                   ,'1'
                   );        
            END IF;              

            IF v_mesg_error IS NULL
            THEN
              debug(g_indent                                ||
                    v_calling_sequence                      ||
                    '. Valida store_acronym: '              ||
                    p_items(i).store_acronym
                   ,'1'
                   );        
            END IF;  

            IF v_mesg_error IS NULL
            THEN
              debug(g_indent                                ||
                    v_calling_sequence                      ||
                    '. Valida store_cost_center: '          ||
                    p_items(i).store_cost_center
                   ,'1'
                   );        
            END IF;
            
            IF v_mesg_error IS NULL
            THEN
              debug(g_indent                                ||
                    v_calling_sequence                      ||
                    '. Valida reference_date: '             ||
                    p_items(i).reference_date
                   ,'1'
                   );        
            END IF;  

            IF v_mesg_error IS NULL
            THEN
              debug(g_indent                                ||
                    v_calling_sequence                      ||
                    '. Valida p_country_code: '             ||
                    p_country_code
                   ,'1'
                   );        
            END IF;   
            
            
            get_item_price( 
                            p_items(i).item_code                            
                           ,p_items(i).store_acronym
                           ,p_items(i).store_cost_center
                           ,p_items(i).reference_date
                           ,p_country_code
                           ,v_item_price_id
                           ,v_item_price_found
                           ,v_mesg_error
                          );
                          
            IF v_mesg_error IS NULL
            THEN
              debug(g_indent                                ||
                    v_calling_sequence                      ||
                    '. Valida item_price_id: '              ||
                    v_item_price_id
                   ,'1'
                   );
        
            END IF;
                          
        
      END IF;




    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                                    ||
            v_calling_sequence                          ||
            '. Valida Item Price: '                     ||
            sys.diutil.bool_to_int(v_item_price_found)
           ,'1'
           );

    END IF;

      -- ---------------------------------------------------------------------------
      -- Obtiene item_id.
      -- ---------------------------------------------------------------------------
      IF v_mesg_error IS NULL 
      THEN

    
        IF v_mesg_error IS NULL
        THEN
          debug(g_indent                    ||
                v_calling_sequence          ||
                '. Valida p_country_code: ' ||
                p_country_code
               ,'1'
               );
    
        END IF;


        IF v_mesg_error IS NULL
        THEN
          debug(g_indent                ||
                v_calling_sequence      ||
                '. Valida item_code: '  ||
                p_items(i).item_code
               ,'1'
               );
    
        END IF;

        BEGIN
        
            SELECT xfi.item_id
                  ,xfi.description 
            INTO v_item_id
                ,v_description
            FROM dual
                ,xx_fla_items xfi
            WHERE 1 = 1
            AND xfi.country_code =  p_country_code
            AND xfi.item_code    =  p_items(i).item_code
            AND ROWNUM           =  1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN 
                    v_mesg_error     := message('ITEM_NOT_FOUND',p_items(i).item_code);                
                    
                WHEN OTHERS THEN
                    v_mesg_error     := message('ITEM_FOUND',p_items(i).item_code||g_msg_del||SQLERRM);

                
                
        
        END;
        
        
      END IF;
                            
    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                ||
            v_calling_sequence      ||
            '. Valida item_id: '    ||
            v_item_id
           ,'1'
           );

    END IF;

    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                    ||
            v_calling_sequence          ||
            '. Valida v_description: '  ||
            v_description
           ,'1'
           );

    END IF;

    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                    ||
            v_calling_sequence          ||
            '. Valida .store_acronym: '  ||
            p_items(i).store_acronym
           ,'1'
           );

    END IF;
    

    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                    ||
            v_calling_sequence          ||
            '. Valida .store_cost_center: '  ||
            p_items(i).store_cost_center
           ,'1'
           );

    END IF;

    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                    ||
            v_calling_sequence          ||
            '. Valida .store_id: '  ||
            p_items(i).store_id
           ,'1'
           );

    END IF;

      IF v_mesg_error IS NULL 
         AND v_item_price_found = FALSE
       THEN
      
          IF NVL(p_draft_flag,'Y') = 'N' THEN
      
            BEGIN
            
                INSERT INTO xx_fla_item_prices (
                            item_price_id
                           ,item_id
                           ,store_acronym
                           ,store_cost_center
                           ,store_id
                           ,reference_date
                           ,price
                           ,price_tax_free
                           ,price_type
                           ,request_id
                           ,creation_date
                           ,created_by
                           ,last_update_date
                           ,last_updated_by
                            )   VALUES (
                                        v_item_price_id
                                       ,v_item_id
                                       ,p_items(i).store_acronym
                                       ,p_items(i).store_cost_center
                                       ,p_items(i).store_id
                                       ,p_items(i).reference_date
                                       ,p_items(i).price
                                       ,p_items(i).price_tax_free
                                       ,p_items(i).price_type
                                       ,NVL(p_items(i).request_id,-1)
                                       ,SYSDATE
                                       ,-1 --p_user_name
                                       ,SYSDATE
                                       ,-1 --p_user_name
                            );
            
            
                EXCEPTION
                
                    WHEN OTHERS THEN
                
                        v_mesg_error := message('XX_FLA_ITEM_PRICES_INSERT',SQLERRM);
            END;

          END IF;

      END IF;

    IF v_mesg_error IS NULL
       AND v_item_price_found = TRUE
    THEN
      debug(g_indent                 ||
            v_calling_sequence       ||
            '. Valida INSERT item_price_id: ' ||
            v_item_price_id
           ,'1'
           );

    END IF;       
    
      IF v_mesg_error IS NULL 
         AND v_item_price_found = TRUE 
      THEN
          IF NVL(p_draft_flag,'Y') = 'N' THEN

                BEGIN
    
                    UPDATE xx_fla_item_prices 
                    SET  item_id            =   v_item_id
                        ,store_acronym      =   p_items(i).store_acronym
                        ,store_cost_center  =   p_items(i).store_cost_center
                        ,store_id           =   p_items(i).store_id
                        ,reference_date     =   p_items(i).reference_date
                        ,price              =   p_items(i).price
                        ,price_tax_free     =   p_items(i).price_tax_free
                        ,price_type         =   p_items(i).price_type
                        ,request_id         =   NVL(p_items(i).request_id,-1)
                        ,last_update_date   =   SYSDATE
                        ,last_updated_by    =   -1 --NVL(p_user_name,-1)
                    WHERE 1 = 1
                    AND item_price_id = v_item_price_id;
                
                    EXCEPTION
                    
                        WHEN OTHERS THEN
                    
                            v_mesg_error := message('XX_FLA_ITEM_PRICES_UPDATE',SQLERRM);
                END;

          END IF;

      END IF;

    IF v_mesg_error IS NULL
       AND v_item_price_found = FALSE
    THEN
      debug(g_indent                 ||
            v_calling_sequence       ||
            '. Valida UPDATE item_price_id: ' ||
            v_item_price_id
           ,'1'
           );

    END IF;       



        v_item_price    := NULL;
        v_item_price    := xx_fla_item_prices_o(
                                                  v_item_price_id
                                                 ,v_item_id
                                                 ,p_items(i).item_code
                                                 ,v_description
                                                 ,p_items(i).store_acronym
                                                 ,p_items(i).store_cost_center
                                                 ,p_items(i).store_id
                                                 ,p_items(i).reference_date
                                                 ,p_items(i).price
                                                 ,p_items(i).price_tax_free
                                                 ,p_items(i).price_type
                                                 ,p_items(i).request_id
                                                );
                                                
        v_item_prices.EXTEND;
        v_item_prices(v_item_prices.COUNT)  :=  v_item_price;
        
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
        
        x_items := v_item_prices;  
        
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
END create_update_item_prices;




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
                      )IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4);  
  
  v_item                    XX_FLA_INDEX_O;
  v_items                   XX_FLA_INDEXES_T; 
  v_index_date_from         DATE;
  v_index_date_to           DATE;
  v_index_date_prv          DATE;

  -- ---------------------------------------------------------------------------
  -- Declaracion de Cursores.
  -- ---------------------------------------------------------------------------
  -- ---------------------------------------------------------------------------
  -- Cursor de indexes.
  -- ---------------------------------------------------------------------------
    CURSOR c_indexes ( p_index_date_prv     DATE
                      ,p_index_type         VARCHAR2) IS
    SELECT DISTINCT  
           xpc.country_code 
          ,ft.territory_short_name
          ,xpc.country_num         country_num --
          ,pihh.index_id                    --
          ,pihh.name               index_name --
          ,pihh.source             index_source 
          ,(
            SELECT pihl.index_var
              FROM xx_fla_index_history_lines pihl
             WHERE 1 = 1
               AND pihh.index_id   = pihl.index_id
               AND pihl.index_date = p_index_date_prv
               AND ROWNUM          = 1
           ) index_figure_prv --
          /*,(
            SELECT pihl.index_unadj_1
              FROM xx_fla_index_history_lines pihl
             WHERE 1 = 1
               AND pihh.index_id   = pihl.index_id
               AND pihl.index_date = p_index_date_prv
               AND ROWNUM          = 1
           ) index_unadj_1_prv --*/
      FROM dual
          ,xx_fla_index_history_headers pihh
          ,fnd_territories        ft
          ,xx_pn_countries          xpc
     WHERE 1 = 1
       --AND xpc.country_code = NVL(p_country_code ,xpc.country_code)
       AND xpc.country_code = ft.territory_code
       AND xpc.country_code = pihh.country
       --AND pihh.attribute1  = 'Y'
       AND pihh.name        = NVL(p_index_type ,pihh.name)
       AND xpc.country_code  = 'AR'
     ORDER BY
           xpc.country_code
          ,pihh.name;
BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence := 'XX_FLA_PROPERTY_INT_PKG.GET_INDEXES';
  x_return_status    := 'S';
  v_items            := XX_FLA_INDEXES_T();
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
  IF v_mesg_error   IS NULL 
     AND p_year     IS NOT NULL
  THEN
     debug(g_indent             ||
           v_calling_sequence   ||
           '. Código año: '     ||
           p_year
          ,'1'
          );
  END IF;

  IF v_mesg_error       IS NULL 
     AND p_index_type   IS NOT NULL
  THEN
     debug(g_indent                 ||
           v_calling_sequence       ||
           '. Código Index Type: '  ||
           p_index_type
          ,'1'
          );
  END IF;         


     v_index_date_from := TO_DATE('01-01-'||TO_CHAR(p_year),'DD-MM-YYYY');
     v_index_date_to   := TO_DATE('31-12-'||TO_CHAR(p_year),'DD-MM-YYYY');
     v_index_date_prv  := TO_DATE('31-12-'||TO_CHAR(p_year-1),'DD-MM-YYYY');

  FOR r_indexes IN c_indexes(v_index_date_prv
                            ,p_index_type     ) LOOP
  
      IF v_mesg_error  IS NULL 
      THEN
         debug(g_indent                         ||
               v_calling_sequence               ||
               '. Código de territorio: ' ||
               r_indexes.territory_short_name
              ,'1'
              );
      END IF;
      
      
        v_item    := NULL;
        v_item    := xx_fla_index_o(
                                     r_indexes.country_code
                                    ,r_indexes.territory_short_name
                                    ,r_indexes.country_num
                                    ,r_indexes.index_id
                                    ,r_indexes.index_name
                                    ,r_indexes.index_source
                                    ,r_indexes.index_figure_prv
                                    ,0--r_indexes.index_unadj_1_prv
                                    ,v_index_date_from
                                    ,v_index_date_to
                                    ); 

        v_items.EXTEND;
        v_items(v_items.COUNT)  :=  v_item;      
  
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
        
        x_items := v_items;
        
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
                    '. Error general. ' ||
                    SQLERRM;
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

END get_indexes;

/*=========================================================================+
|                                                                          |
| Public Procedure                                                         |
|    GET_COUNTRIES                                                         |
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
|    x_items            OUT     XX_FLA_COUNTRIES_T Listado de paises.      |
|    x_return_status    OUT     VARCHAR2 Estado de ejecucion.              |
|    x_msg_error        OUT     VARCHAR2 Mensaje de error.                 |
|                                                                          |
+=========================================================================*/
PROCEDURE get_countries(p_request_id       IN      NUMBER
                       ,p_request_phase_id IN      NUMBER
                       ,p_draft_flag       IN      VARCHAR2
                       ,p_debug_flag       IN      VARCHAR2
                       ,p_language         IN      VARCHAR2
                       ,p_user_name        IN      VARCHAR2
                       ,p_country_code     IN      VARCHAR2
                       ,x_items            OUT     XX_FLA_COUNTRIES_T 
                       ,x_return_status    OUT     VARCHAR2
                       ,x_msg_error        OUT     VARCHAR2
                       )
IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4);  
  
  v_item                    XX_FLA_COUNTRY_O;
  v_items                   XX_FLA_COUNTRIES_T;

  -- ---------------------------------------------------------------------------
  -- Declaracion de Cursores.
  -- ---------------------------------------------------------------------------
  -- ---------------------------------------------------------------------------
  -- Cursor de paises.
  -- ---------------------------------------------------------------------------
   --ORIGINAL
    CURSOR c_countries(p_country_code VARCHAR2
                      ,p_language     VARCHAR2) IS
    SELECT ft.territory_code
          ,ft.territory_short_name
          ,xpc.country_num         territory_num
      FROM dual
          ,fnd_territories    ft
          ,xx_pn_countries    xpc
     WHERE 1 = 1
       AND xpc.country_code = NVL(p_country_code
                                 ,xpc.country_code
                                 )
       AND xpc.country_code  = ft.territory_code
       AND ft.language       = p_language
     ORDER BY
           ft.territory_code;
           
  /*CURSOR c_countries(p_country_code VARCHAR2
                    ,p_language     VARCHAR2) IS
    SELECT ft.territory_short_name
          ,ft.territory_code        territory_num
      FROM dual
          ,fnd_territories ft
     WHERE 1 = 1
       AND ft.territory_code = NVL(p_country_code,ft.territory_code)   
       AND ft.language       = p_language
     ORDER BY
           ft.territory_code;*/
BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence := 'XX_FLA_PROPERTY_INT_PKG.GET_COUNTRIES';
  x_return_status    := 'S';
  v_items            := XX_FLA_COUNTRIES_T();
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
  IF v_mesg_error  IS NULL 
  THEN
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. Código de pais: ' ||
           p_country_code
          ,'1'
          );
  END IF;
         

  FOR r_country IN c_countries(p_country_code, v_language) LOOP
  
      IF v_mesg_error  IS NULL 
      THEN
         debug(g_indent                         ||
               v_calling_sequence               ||
               '. Código de territorio: ' ||
               r_country.territory_num
              ,'1'
              );
      END IF;
      
      
        v_item    := NULL;
        v_item    := xx_fla_country_o(
                                       r_country.territory_short_name
                                      ,r_country.territory_num
                                   ); 

        v_items.EXTEND;
        v_items(v_items.COUNT)  :=  v_item;      
  
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
      
        x_items := v_items;  
        
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

END get_countries;


PROCEDURE wrap_get_countries_json ( p_request_id        IN      VARCHAR2
                                   ,p_draft_flag        IN      VARCHAR2
                                   ,p_debug_flag        IN      VARCHAR2
                                   ,p_language          IN      VARCHAR2
                                   ,p_user_name         IN      VARCHAR2
                                   ,p_json_in           IN  VARCHAR2
                                   ,x_json_result       OUT CLOB
                                   ,x_return_status     OUT     VARCHAR2
                                   ,x_msg_error         OUT     VARCHAR2
                                    ) IS
    v_countries      XX_FLA_COUNTRIES_T;
    v_return_status  VARCHAR2(10);
    v_msg_error      VARCHAR2(4000);
    v_json_obj       JSON_OBJECT_T;
    v_json_arr       JSON_ARRAY_T := JSON_ARRAY_T();
    v_country_obj    JSON_OBJECT_T;
    
      v_json         JSON_OBJECT_T;
      v_keys         JSON_KEY_LIST;
      v_in_json      JSON_OBJECT_T := JSON_OBJECT_T();
  
BEGIN
  

  v_json := JSON_OBJECT_T.parse(p_json_in); 
DBMS_OUTPUT.put_line('wrap_get_countries_json1->');
DBMS_OUTPUT.put_line('wrap_get_countries_json->' ||v_json.get_string('p_draft_mode'));
DBMS_OUTPUT.put_line('wrap_get_countries_json->' ||v_json.get_string('p_country_code'));
  
--v_jo.get_string(v_keys(i))
    get_countries(
        p_request_id       => p_request_id,
        p_request_phase_id => NULL,
        p_draft_flag       => v_json.get_string('p_draft_mode'),
        p_debug_flag       => p_debug_flag,
        p_language         => p_language,
        p_user_name        => p_user_name,
        p_country_code     => v_json.get_string('p_country_code'),
        x_items            => v_countries,
        x_return_status    => v_return_status,
        x_msg_error        => v_msg_error
    );

    IF v_countries IS NOT NULL THEN
        FOR i IN 1 .. v_countries.COUNT LOOP
            v_country_obj := JSON_OBJECT_T();
            v_country_obj.put('territory_short_name', v_countries(i).territory_short_name);
            v_country_obj.put('territory_num',  v_countries(i).territory_num);
            -- Agrega aquí los demás campos de XX_FLA_COUNTRY_O si existen
            v_json_arr.append(v_country_obj);
        END LOOP;
    END IF;

    v_json_obj := JSON_OBJECT_T();
    v_json_obj.put('x_return_status', v_return_status);
    v_json_obj.put('x_msg_error',     v_msg_error);
    v_json_obj.put('x_items',         v_json_arr);

    x_json_result := v_json_obj.to_clob;
    x_return_status:='S';
    x_msg_error:=NULL;
    --x_json_result := '{"x_return_status":"E","x_msg_error":"' ||'falta nivel' ||  '"}';
EXCEPTION
    WHEN OTHERS THEN
        x_json_result := '{"x_return_status":"E","x_msg_error":"' || REPLACE('falta niveles' || SQLERRM, '"', '\"') || '"}';
END;


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
                             )
IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4);  
  
  v_item                    XX_FLA_SALES_COUNTRY_O;
  v_items                   XX_FLA_SALES_COUNTRIES_T;
  v_sale_date               DATE;
  v_sale_date_to            DATE;

  -- ---------------------------------------------------------------------------
  -- Declaracion de Cursores.
  -- ---------------------------------------------------------------------------
  -- ---------------------------------------------------------------------------
  -- Cursor de paises.
  -- ---------------------------------------------------------------------------
   --ORIGINAL
    CURSOR c_countries(p_country_code VARCHAR2,p_init_date DATE,p_end_date DATE) IS
    SELECT xpc.country_code
          ,xpc.country_num
          ,xpc.sales_last_date
      FROM dual
          ,xx_pn_countries    xpc
     WHERE 1 = 1
       AND xpc.country_code = NVL(p_country_code
                                 ,xpc.country_code
                                 )
       AND TRUNC(xpc.sales_last_date) BETWEEN TRUNC(NVL(p_init_date,xpc.sales_last_date)) AND TRUNC(NVL(p_end_date,xpc.sales_last_date))
       AND xpc.enabled_flag = 'Y'
     ORDER BY
           xpc.country_code;
           

BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence := 'XX_FLA_PROPERTY_INT_PKG.GET_SALES_COUNTRIES';
  x_return_status    := 'S';
  v_items            := XX_FLA_SALES_COUNTRIES_T();
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
  IF v_mesg_error  IS NULL 
  THEN
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. Código de pais: ' ||
           p_country_code
          ,'1'
          );
  END IF;
         

  IF v_mesg_error  IS NULL 
  THEN
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. Fecha Inicio: ' ||
           p_init_date
          ,'1'
          );
  END IF;


  IF v_mesg_error  IS NULL 
  THEN
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. Fecha Fin: ' ||
           p_end_date
          ,'1'
          );
  END IF;

  FOR r_country IN c_countries(p_country_code,p_init_date,p_end_date) LOOP
  
      IF v_mesg_error  IS NULL 
      THEN
         debug(g_indent                         ||
               v_calling_sequence               ||
               '. Código de country_code: ' ||
               r_country.country_code
              ,'1'
              );
      END IF;
      
      IF v_mesg_error  IS NULL 
      THEN
         debug(g_indent                         ||
               v_calling_sequence               ||
               '. Código de country_num: ' ||
               r_country.country_num
              ,'1'
              );
      END IF;

      IF v_mesg_error  IS NULL 
      THEN
         debug(g_indent                         ||
               v_calling_sequence               ||
               '. Código de sales_last_date: '  ||
               r_country.sales_last_date
              ,'1'
              );
      END IF;
      
        --Sales         
         --v_sale_date        := TRUNC(r_country.sales_last_date + 485);
         --v_sale_date_to     := TRUNC(SYSDATE - 760);
        --Sales_taxes
         v_sale_date        := TRUNC(r_country.sales_last_date + 1240);
         v_sale_date_to     := TRUNC(SYSDATE);
        --Original
         --v_sale_date        := TRUNC(r_country.sales_last_date);
         --v_sale_date_to     := TRUNC(SYSDATE);


         --v_cnt_day          := 1;
         
        WHILE   v_sale_date <= v_sale_date_to 
            --AND v_cnt_day   <= p_value_num2   
        LOOP
            

            v_item    := NULL;
            v_item    := xx_fla_sales_country_o(
                                                r_country.country_code
                                               ,r_country.country_num
                                               ,v_sale_date
                                               ); 
    
            v_items.EXTEND;
            v_items(v_items.COUNT)  :=  v_item;      

            
            v_sale_date := TRUNC(v_sale_date+1);
            --v_cnt_day   := NVL(v_cnt_day,1)+1;
            
        END LOOP;
      
      
  
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
      
        x_items := v_items;  
        
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

END get_sales_countries;

PROCEDURE wrap_create_update_items_json (
    p_request_id       IN  NUMBER,
    p_request_phase_id IN  NUMBER,
    p_draft_flag       IN  VARCHAR2,
    p_debug_flag       IN  VARCHAR2,
    p_language         IN  VARCHAR2,
    p_user_name        IN  VARCHAR2,
    p_items            IN  XX_FLA_ITEMS_T,
    p_json_result      OUT CLOB
) IS
    l_x_items         XX_FLA_ITEMS_T;
    l_x_return_status VARCHAR2(10);
    l_x_msg_error     VARCHAR2(4000);
    l_json_obj        JSON_OBJECT_T;
    l_json_arr        JSON_ARRAY_T := JSON_ARRAY_T();
    l_item_obj        JSON_OBJECT_T;
BEGIN
    create_update_items(
        p_request_id       => p_request_id,
        p_request_phase_id => p_request_phase_id,
        p_draft_flag       => p_draft_flag,
        p_debug_flag       => p_debug_flag,
        p_language         => p_language,
        p_user_name        => p_user_name,
        p_items            => p_items,
        x_items            => l_x_items,
        x_return_status    => l_x_return_status,
        x_msg_error        => l_x_msg_error
    );

    IF l_x_items IS NOT NULL THEN
        FOR i IN 1 .. l_x_items.COUNT LOOP
            l_item_obj := JSON_OBJECT_T();
            l_item_obj.put('item_id',      l_x_items(i).item_id);
            l_item_obj.put('country_code', l_x_items(i).country_code);
            l_item_obj.put('item_code',    l_x_items(i).item_code);
            l_item_obj.put('description',  l_x_items(i).description);
            l_item_obj.put('enabled_flag', l_x_items(i).enabled_flag);
            l_item_obj.put('request_id',   l_x_items(i).request_id);
            l_json_arr.append(l_item_obj);
        END LOOP;
    END IF;

    l_json_obj := JSON_OBJECT_T();
    l_json_obj.put('x_return_status', l_x_return_status);
    l_json_obj.put('x_msg_error',     l_x_msg_error);
    l_json_obj.put('x_items',         l_json_arr);

    p_json_result := l_json_obj.to_clob;

EXCEPTION
    WHEN OTHERS THEN
        p_json_result := '{"x_return_status":"E","x_msg_error":"' || REPLACE(SQLERRM, '"', '\"') || '"}';
END;
/*=========================================================================+
|                                                                          |
| Public Procedure                                                         |
|    CREATE_UPDATE_ITEMS                                             |
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
                             )
IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4);  
  v_item                    XX_FLA_ITEM_O;
  v_items                   XX_FLA_ITEMS_T;  
    
  v_item_id                 xx_fla_items.item_id%TYPE;
  v_item_found              BOOLEAN;
  
BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence := 'XX_FLA_PROPERTY_INT_PKG.CREATE_UPDATE_ITEMS';
  x_return_status    := 'S';
  v_items            := XX_FLA_ITEMS_T(); 
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

  IF v_mesg_error   IS NULL
     AND p_items    IS NULL THEN
    
    v_mesg_error := message('P_ITEMS_REQ');
    
  END IF;


  IF v_mesg_error       IS NULL
     AND p_items.COUNT  < 0 THEN
    
    v_mesg_error := message('P_ITEMS_REQ');
    
  END IF;


  IF v_mesg_error       IS NULL
     AND p_items.COUNT  > 0 THEN
   
    FOR i IN 1 .. p_items.COUNT LOOP      
 
            IF v_mesg_error IS NULL
            THEN
              debug(g_indent                                ||
                    v_calling_sequence                      ||
                    '. Valida country_code: '               ||
                    p_items(i).country_code
                   ,'1'
                   );
        
            END IF;
            
            IF v_mesg_error IS NULL
            THEN
              debug(g_indent                                ||
                    v_calling_sequence                      ||
                    '. Valida item_code: '                  ||
                    p_items(i).item_code
                   ,'1'
                   );
        
            END IF;    
 
              -- ---------------------------------------------------------------------------
              -- Obtiene item_id.
              -- ---------------------------------------------------------------------------
              v_item_id  :=     -1;
              IF v_mesg_error IS NULL 
                 AND NVL(p_draft_flag,'Y') = 'N'
              THEN

                    get_item( 
                              p_items(i).country_code
                             ,p_items(i).item_code
                             ,v_item_id
                             ,v_item_found
                             ,v_mesg_error
                            );                
                
              END IF;


    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida ItemId: '                     ||
            v_item_id
           ,'1'
           );

    END IF;

    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida Item: '                       ||
            sys.diutil.bool_to_int(v_item_found)
           ,'1'
           );

    END IF;

              IF v_mesg_error IS NULL 
                 AND v_item_found = FALSE 
              THEN
              
                  IF NVL(p_draft_flag,'Y') = 'N' THEN
                  
                        BEGIN
                        
                            INSERT INTO xx_fla_items (
                                        item_id
                                       ,country_code
                                       ,item_code
                                       ,description
                                       ,enabled_flag
                                       ,request_id
                                       ,creation_date
                                       ,created_by
                                       ,last_update_date
                                       ,last_updated_by
                                        )   VALUES (
                                                    v_item_id
                                                   ,p_items(i).country_code
                                                   ,p_items(i).item_code
                                                   ,p_items(i).description
                                                   ,p_items(i).enabled_flag
                                                   ,NVL(p_items(i).request_id,-1)
                                                   ,SYSDATE
                                                   ,NVL(p_user_name,-1)
                                                   ,SYSDATE
                                                   ,NVL(p_user_name,-1)
                                        );
                        
                        
                            EXCEPTION
                            
                                WHEN OTHERS THEN
                                    v_mesg_error := message('XX_FLA_ITEMS_INSERT',SQLERRM);
                                    --v_mesg_error := SQLERRM;
                        END;
    
                  END IF;

              END IF;

    IF v_mesg_error IS NULL
       AND v_item_found = FALSE
    THEN
      debug(g_indent                 ||
            v_calling_sequence       ||
            '. Valida INSERT Item: ' ||
            v_item_id
           ,'1'
           );

    END IF;    
    
    
    
              IF v_mesg_error IS NULL 
                 AND v_item_found = TRUE 
              THEN
              
                  IF NVL(p_draft_flag,'Y') = 'N' THEN
                  
                        BEGIN
    
                            UPDATE xx_fla_items 
                            SET country_code        =   p_items(i).country_code
                                ,item_code          =   p_items(i).item_code
                                ,description        =   p_items(i).description
                                ,enabled_flag       =   p_items(i).enabled_flag
                                ,request_id         =   NVL(p_items(i).request_id,-1)
                                ,last_update_date   =   SYSDATE
                                ,last_updated_by    =   NVL(p_user_name,-1)
                            WHERE 1 = 1
                            AND item_id = v_item_id;
                        
                            EXCEPTION
                            
                                WHEN OTHERS THEN
                            
                                    v_mesg_error := message('XX_FLA_ITEMS_UPDATE',SQLERRM);
                        END;
    
                  END IF;

              END IF;

    IF v_mesg_error IS NULL
       AND v_item_found = TRUE 
    THEN
      debug(g_indent                 ||
            v_calling_sequence       ||
            '. Valida UPDATE Item: ' ||
            v_item_id
           ,'1'
           );

    END IF;    

        v_item    := NULL;
        v_item    := xx_fla_item_o(
                                     v_item_id
                                    ,p_items(i).country_code
                                    ,p_items(i).item_code
                                    ,p_items(i).description
                                    ,p_items(i).enabled_flag
                                    ,p_items(i).request_id
                                   ); 

        v_items.EXTEND;
        v_items(v_items.COUNT)  :=  v_item;
        
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
        
        x_items := v_items;         
          
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
END create_update_items;




/*=========================================================================+
|                                                                          |
| Public Procedure                                                         |
|    GET_SALE                                                              |
|                                                                          |
| Description                                                              |
|    (descripcion del procedimiento)                                       |
|                                                                          |
| Parameters                                                               |
|    p_country_code         IN     VARCHAR2   Código de país.              |
|    p_company_num          IN     VARCHAR2   Número de Compañía en        | 
|                                               sistema origen             |
|    p_store_acronym        IN     VARCHAR2   Acrónimo del local.          |
|    p_store_cost_center    IN     VARCHAR2   Centro de Costos del local.  |
|    p_area_type_code       IN     VARCHAR2   Código de Área del local.    |
|    p_sale_date            IN     VARCHAR2   Fecha de Venta.              |
|    p_source               IN     VARCHAR2   Origen de Registro.          |
|    p_lease_type           IN     VARCHAR2   Tipo de Contrato.            |
|    p_payment_purpose_code IN     VARCHAR2   Propósito de pago.           |
|    p_entity_type          IN     VARCHAR2   Entidad en sistema origen.   |
|    x_sale_id              IN     NUMBER     Identificador de código      | 
|                                               de la venta.               |
|    x_found                OUT    BOOLEAN    Flag que indica si           |
|                                               encontro el registro.      |
|    x_msg_error            OUT    VARCHAR2   Mensaje de error.            |
|                                                                          |
+=========================================================================*/
PROCEDURE get_sale( 
                    p_country_code              IN      VARCHAR2
                   ,p_company_num               IN      NUMBER
                   ,p_store_acronym             IN      VARCHAR2
                   ,p_store_cost_center         IN      VARCHAR2
                   ,p_area_type_code            IN      VARCHAR2
                   ,p_sale_date                 IN      DATE
                   ,p_source                    IN      VARCHAR2
                   ,p_lease_type                IN      VARCHAR2
                   ,p_payment_purpose_code      IN      VARCHAR2
                   ,p_entity_type               IN      VARCHAR2
                   ,x_sale_id                   OUT     NUMBER
                   ,x_found                     OUT     BOOLEAN
                   ,x_mesg_error                OUT     VARCHAR2
                    ) IS 

  v_sale_id             NUMBER;  
  v_mesg_error          VARCHAR2(32767);
  v_calling_sequence    VARCHAR(2000);
  v_found               BOOLEAN;
  
  
BEGIN

  v_calling_sequence := 'XX_FLA_PROPERTY_INT_PKG.GET_SALE';
              debug(g_indent                                ||
                    v_calling_sequence                      ||
                    '. Valida GetSale ' 
                   ,'1');  
    BEGIN
        SELECT xfs.sale_id
        INTO v_sale_id
        FROM dual
            ,xx_fla_sales xfs
        WHERE 1 = 1
        AND xfs.country_code            = p_country_code
        AND xfs.company_num             = p_company_num
        AND xfs.store_acronym           = p_store_acronym
        AND xfs.store_cost_center       = NVL(p_store_cost_center,xfs.store_cost_center)
        AND xfs.area_type_code          = p_area_type_code
        AND xfs.sale_date               = p_sale_date
        AND xfs.source                  = p_source
        AND xfs.lease_type              = p_lease_type
        AND xfs.payment_purpose_code    = p_payment_purpose_code
        AND xfs.entity_type             = p_entity_type
        ;
        
        v_found      := TRUE;
        
        EXCEPTION
        
            WHEN NO_DATA_FOUND THEN                
               v_sale_id    := NULL; 
               v_found      := FALSE;
              debug(g_indent                                ||
                    v_calling_sequence                      ||
                    '. Valida No_data_found ' 
                   ,'1');
               
            WHEN OTHERS THEN
               v_sale_id    := NULL;
               v_mesg_error := message('XX_FLA_SALES_GEN',SQLERRM);
               v_found      := FALSE;
              debug(g_indent                                ||
                    v_calling_sequence                      ||
                    '. Valida Others ' 
                   ,'1');

    END;    
    
    IF v_mesg_error IS NULL
       AND v_sale_id IS NULL THEN

        BEGIN
            
                v_sale_id   := xx_fla_sales_s.NEXTVAL;
                v_found     := FALSE;
            
            EXCEPTION
                
                WHEN OTHERS THEN
                    v_mesg_error := message('XX_FLA_SALES_SEQ',SQLERRM);
                    v_found      := FALSE;
        END; 

        
    END IF;

    IF v_mesg_error IS NULL
    THEN
        
            x_sale_id   := v_sale_id;
            x_found     := v_found;
            
        ELSE
        
            x_sale_id       := NULL;
            x_found         := FALSE;
            x_mesg_error    := v_mesg_error;
    END IF;

END get_sale;
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
                             )
IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4);  
  v_item                    XX_FLA_SALE_O;
  v_items                   XX_FLA_SALES_T;  
    
  v_sale_id                 xx_fla_sales.sale_id%TYPE;
  v_sale_found              BOOLEAN;
  
BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence := 'XX_FLA_PROPERTY_INT_PKG.CREATE_UPDATE_SALES';
  x_return_status    := 'S';
  v_items            := XX_FLA_SALES_T(); 
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

  IF v_mesg_error   IS NULL
     AND p_items    IS NULL THEN
    
    v_mesg_error := message('P_SALES_REQ');
    
  END IF;


  IF v_mesg_error       IS NULL
     AND p_items.COUNT  < 0 THEN
    
    v_mesg_error := message('P_SALES_REQ');
    
  END IF;


  IF v_mesg_error       IS NULL
     AND p_items.COUNT  > 0 THEN
    
    FOR i IN 1 .. p_items.COUNT LOOP      

    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida Loop. Item.1: '               ||
            i
           ,'1'
           );
   END IF;        

    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida Loop. country_code: '         ||
            p_items(i).country_code
           ,'1'
           );
   END IF;     

    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida Loop. company_num: '          ||
            p_items(i).company_num
           ,'1'
           );
   END IF;     

    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida Loop. store_acronym: '          ||
            p_items(i).store_acronym
           ,'1'
           );
   END IF;     


              -- ---------------------------------------------------------------------------
              -- Obtiene sale_id.
              -- ---------------------------------------------------------------------------
              v_sale_id  :=     -1;
              IF v_mesg_error IS  NULL 
              THEN

                    get_sale( 
                              p_items(i).country_code
                             ,p_items(i).company_num
                             ,p_items(i).store_acronym
                             ,NVL(p_items(i).store_cost_center,'N/A')
                             ,p_items(i).area_type_code
                             ,p_items(i).sale_date
                             ,p_items(i).source
                             ,NVL(p_items(i).lease_type,'N/A')
                             ,NVL(p_items(i).payment_purpose_code,'N/A')
                             ,p_items(i).entity_type
                             ,v_sale_id
                             ,v_sale_found
                             ,v_mesg_error
                            );                
                
              END IF;

    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida Loop. Item.2: '                       ||
            i
           ,'1'
           );
   END IF;  

      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida Loop. Item.Error: '                       ||
            v_mesg_error
           ,'1'
           );
    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida Sale: '                       ||
            sys.diutil.bool_to_int(v_sale_found)
           ,'1'
           );

    END IF;
    
    IF v_sale_found   = FALSE  THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida Sale: '                       ||
            'FALSE'
           ,'1'
           );

    END IF;
    
    IF v_sale_found   = TRUE  THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida Sale: '                       ||
            'TRUE'
           ,'1'
           );

    END IF;
              IF v_mesg_error       IS NULL 
                 AND v_sale_found   = FALSE 
              THEN
              
                  IF NVL(p_draft_flag,'Y') = 'N' THEN
                  
                        BEGIN
                        
                            INSERT INTO xx_fla_sales (
                                                      sale_id
                                                     ,country_code
                                                     ,company_num
                                                     ,store_acronym
                                                     ,store_cost_center
                                                     ,area_type_code
                                                     ,sale_date
                                                     ,source
                                                     ,lease_type
                                                     ,payment_purpose_code
                                                     ,entity_type
                                                     ,amt_sale_net_product
                                                     ,amt_sale_net_noproduct
                                                     ,amt_sale_net
                                                     ,amt_sale_gross_product
                                                     ,amt_sale_gross_noproduct
                                                     ,amt_sale_gross
                                                     ,amt_sale_iibb_product
                                                     ,amt_sale_iibb_noproduct
                                                     ,amt_sale_iibb
                                                     ,amt_del_net
                                                     ,amt_del_gross
                                                     ,amt_error
                                                     ,amt_error_no_cancel
                                                     ,amt_null
                                                     ,amt_cancel
                                                     ,amt_soda
                                                     ,amt_free
                                                     ,amt_gift
                                                     ,amt_promotion
                                                     ,amt_loyalty
                                                     ,amt_mc_day
                                                     ,amt_tax_icms
                                                     ,amt_tax_icms_ar
                                                     ,amt_tax_icms_ap
                                                     ,amt_tax_pis
                                                     ,amt_tax_cofins
                                                     ,amt_tax_st
                                                     ,prc_tax
                                                     ,prc_delivery
                                                     ,qty_tc
                                                     ,amt_cash_map_dif
                                                     ,adj_status
                                                     ,adj_reason_code
                                                     ,adj_comments
                                                     ,adj_approved_date
                                                     ,adj_approved_by
                                                     ,request_id
                                                     ,creation_date
                                                     ,created_by
                                                     ,last_update_date
                                                     ,last_updated_by
                                        )   VALUES (
                                                      v_sale_id
                                                     ,p_items(i).country_code
                                                     ,p_items(i).company_num
                                                     ,p_items(i).store_acronym
                                                     ,NVL(p_items(i).store_cost_center,'N/A')
                                                     ,p_items(i).area_type_code
                                                     ,p_items(i).sale_date
                                                     ,p_items(i).source
                                                     ,NVL(p_items(i).lease_type,'N/A')
                                                     ,NVL(p_items(i).payment_purpose_code,'N/A')
                                                     ,p_items(i).entity_type
                                                     ,p_items(i).amt_sale_net_product
                                                     ,p_items(i).amt_sale_net_noproduct
                                                     ,p_items(i).amt_sale_net
                                                     ,p_items(i).amt_sale_gross_product
                                                     ,p_items(i).amt_sale_gross_noproduct
                                                     ,p_items(i).amt_sale_gross
                                                     ,p_items(i).amt_sale_iibb_product
                                                     ,p_items(i).amt_sale_iibb_noproduct
                                                     ,p_items(i).amt_sale_iibb
                                                     ,p_items(i).amt_del_net
                                                     ,p_items(i).amt_del_gross
                                                     ,p_items(i).amt_error
                                                     ,p_items(i).amt_error_no_cancel
                                                     ,p_items(i).amt_null
                                                     ,p_items(i).amt_cancel
                                                     ,p_items(i).amt_soda
                                                     ,p_items(i).amt_free
                                                     ,p_items(i).amt_gift
                                                     ,p_items(i).amt_promotion
                                                     ,p_items(i).amt_loyalty
                                                     ,p_items(i).amt_mc_day
                                                     ,p_items(i).amt_tax_icms
                                                     ,p_items(i).amt_tax_icms_ar
                                                     ,p_items(i).amt_tax_icms_ap
                                                     ,p_items(i).amt_tax_pis
                                                     ,p_items(i).amt_tax_cofins
                                                     ,p_items(i).amt_tax_st
                                                     ,p_items(i).prc_tax
                                                     ,p_items(i).prc_delivery
                                                     ,p_items(i).qty_tc
                                                     ,p_items(i).amt_cash_map_dif
                                                     ,p_items(i).adj_status
                                                     ,p_items(i).adj_reason_code
                                                     ,p_items(i).adj_comments
                                                     ,p_items(i).adj_approved_date
                                                     ,p_items(i).adj_approved_by
                                                     ,p_items(i).request_id
                                                     ,SYSDATE
                                                     ,p_user_name
                                                     ,SYSDATE
                                                     ,p_user_name
                                        );
                        
                        
                            EXCEPTION
                            
                                WHEN OTHERS THEN
                            
                                    v_mesg_error := message('XX_FLA_SALES_INSERT',SQLERRM);
                        END;
    
                  END IF;

              END IF;

    IF v_mesg_error IS NULL
       AND v_sale_found = FALSE
    THEN
      debug(g_indent                 ||
            v_calling_sequence       ||
            '. Valida INSERT Sale: ' ||
            v_sale_id
           ,'1'
           );

    END IF;    
    
    
    
              IF v_mesg_error       IS NULL 
                 AND v_sale_found   = TRUE 
              THEN
              
                  IF NVL(p_draft_flag,'Y') = 'N' THEN
                  
                        BEGIN
    
                            UPDATE xx_fla_sales 
                            SET  country_code               =   p_items(i).country_code
                                ,company_num                =   p_items(i).company_num
                                ,store_acronym              =   p_items(i).store_acronym
                                ,store_cost_center          =   NVL(p_items(i).store_cost_center,'N/A')
                                ,area_type_code             =   p_items(i).area_type_code
                                ,sale_date                  =   p_items(i).sale_date
                                ,source                     =   p_items(i).source
                                ,lease_type                 =   NVL(p_items(i).lease_type,'N/A')
                                ,payment_purpose_code       =   NVL(p_items(i).payment_purpose_code,'N/A')
                                ,entity_type                =   p_items(i).entity_type
                                ,amt_sale_net_product       =   p_items(i).amt_sale_net_product
                                ,amt_sale_net_noproduct     =   p_items(i).amt_sale_net_noproduct
                                ,amt_sale_net               =   p_items(i).amt_sale_net
                                ,amt_sale_gross_product     =   p_items(i).amt_sale_gross_product
                                ,amt_sale_gross_noproduct   =   p_items(i).amt_sale_gross_noproduct
                                ,amt_sale_gross             =   p_items(i).amt_sale_gross
                                ,amt_sale_iibb_product      =   p_items(i).amt_sale_iibb_product
                                ,amt_sale_iibb_noproduct    =   p_items(i).amt_sale_iibb_noproduct
                                ,amt_sale_iibb              =   p_items(i).amt_sale_iibb
                                ,amt_del_net                =   p_items(i).amt_del_net
                                ,amt_del_gross              =   p_items(i).amt_del_gross
                                ,amt_error                  =   p_items(i).amt_error
                                ,amt_error_no_cancel        =   p_items(i).amt_error_no_cancel
                                ,amt_null                   =   p_items(i).amt_null
                                ,amt_cancel                 =   p_items(i).amt_cancel
                                ,amt_soda                   =   p_items(i).amt_soda
                                ,amt_free                   =   p_items(i).amt_free
                                ,amt_gift                   =   p_items(i).amt_gift
                                ,amt_promotion              =   p_items(i).amt_promotion
                                ,amt_loyalty                =   p_items(i).amt_loyalty
                                ,amt_mc_day                 =   p_items(i).amt_mc_day
                                ,amt_tax_icms               =   p_items(i).amt_tax_icms
                                ,amt_tax_icms_ar            =   p_items(i).amt_tax_icms_ar
                                ,amt_tax_icms_ap            =   p_items(i).amt_tax_icms_ap
                                ,amt_tax_pis                =   p_items(i).amt_tax_pis
                                ,amt_tax_cofins             =   p_items(i).amt_tax_cofins
                                ,amt_tax_st                 =   p_items(i).amt_tax_st
                                ,prc_tax                    =   p_items(i).prc_tax
                                ,prc_delivery               =   p_items(i).prc_delivery
                                ,qty_tc                     =   p_items(i).qty_tc
                                ,amt_cash_map_dif           =   p_items(i).amt_cash_map_dif
                                ,adj_status                 =   p_items(i).adj_status
                                ,adj_reason_code            =   p_items(i).adj_reason_code
                                ,adj_comments               =   p_items(i).adj_comments
                                ,adj_approved_date          =   p_items(i).adj_approved_date
                                ,adj_approved_by            =   p_items(i).adj_approved_by
                                ,request_id                 =   p_items(i).request_id
                                ,last_update_date           =   SYSDATE
                                ,last_updated_by            =   p_user_name
                            WHERE 1 = 1
                            AND sale_id = v_sale_id;
                        
                            EXCEPTION
                            
                                WHEN OTHERS THEN
                            
                                    v_mesg_error := message('XX_FLA_SALES_UPDATE',SQLERRM);
                        END;
    
                  END IF;

              END IF;

    IF v_mesg_error IS NULL
       AND v_sale_found = TRUE 
    THEN
      debug(g_indent                 ||
            v_calling_sequence       ||
            '. Valida UPDATE Sale: ' ||
            v_sale_id
           ,'1'
           );

    END IF;    

        v_item    := NULL;
        v_item    := xx_fla_sale_o(
                                     v_sale_id
                                    ,p_items(i).country_code
                                    ,p_items(i).company_num
                                    ,p_items(i).store_acronym
                                    ,p_items(i).store_cost_center
                                    ,p_items(i).area_type_code
                                    ,p_items(i).sale_date
                                    ,p_items(i).source
                                    ,p_items(i).lease_type
                                    ,p_items(i).payment_purpose_code
                                    ,p_items(i).entity_type
                                    ,p_items(i).amt_sale_net_product
                                    ,p_items(i).amt_sale_net_noproduct
                                    ,p_items(i).amt_sale_net
                                    ,p_items(i).amt_sale_gross_product
                                    ,p_items(i).amt_sale_gross_noproduct
                                    ,p_items(i).amt_sale_gross
                                    ,p_items(i).amt_sale_iibb_product
                                    ,p_items(i).amt_sale_iibb_noproduct
                                    ,p_items(i).amt_sale_iibb
                                    ,p_items(i).amt_del_net
                                    ,p_items(i).amt_del_gross
                                    ,p_items(i).amt_error
                                    ,p_items(i).amt_error_no_cancel
                                    ,p_items(i).amt_null
                                    ,p_items(i).amt_cancel
                                    ,p_items(i).amt_soda
                                    ,p_items(i).amt_free
                                    ,p_items(i).amt_gift
                                    ,p_items(i).amt_promotion
                                    ,p_items(i).amt_loyalty
                                    ,p_items(i).amt_mc_day
                                    ,p_items(i).amt_tax_icms
                                    ,p_items(i).amt_tax_icms_ar
                                    ,p_items(i).amt_tax_icms_ap
                                    ,p_items(i).amt_tax_pis
                                    ,p_items(i).amt_tax_cofins
                                    ,p_items(i).amt_tax_st
                                    ,p_items(i).prc_tax
                                    ,p_items(i).prc_delivery
                                    ,p_items(i).qty_tc
                                    ,p_items(i).amt_cash_map_dif
                                    ,p_items(i).adj_status
                                    ,p_items(i).adj_reason_code
                                    ,p_items(i).adj_comments
                                    ,p_items(i).adj_approved_date
                                    ,p_items(i).adj_approved_by
                                    ,p_items(i).request_id
                                   ); 


        v_items.EXTEND;
        v_items(v_items.COUNT)  :=  v_item;        
        
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
    
        x_items := v_items;   
        
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
END create_update_sales;


/*=========================================================================+
|                                                                          |
| Public Procedure                                                         |
|    GET_SALE_TAXES                                                        |
|                                                                          |
| Description                                                              |
|    (descripcion del procedimiento)                                       |
|                                                                          |
| Parameters                                                               |
|    p_country_code         IN     VARCHAR2   Código de país.              |
|    p_company_num          IN     VARCHAR2   Número de Compañía en        | 
|                                               sistema origen             |
|    p_store_acronym        IN     VARCHAR2   Acrónimo del local.          |
|    p_store_cost_center    IN     VARCHAR2   Centro de Costos del local.  |
|    p_area_type_code       IN     VARCHAR2   Código de Área del local.    |
|    p_sale_date            IN     VARCHAR2   Fecha de Venta.              |
|    p_tax_type             IN     VARCHAR2   Tipo de impuesto.            |
|    p_tax_name             IN     VARCHAR2   Nombre de impuesto.          |
|    x_sale_id              IN     NUMBER     Identificador de código      | 
|                                               de la venta.               |
|    x_found                OUT    BOOLEAN    Flag que indica si           |
|                                               encontro el registro.      |
|    x_msg_error            OUT    VARCHAR2   Mensaje de error.            |
|                                                                          |
+=========================================================================*/
PROCEDURE get_sale_taxes( 
                         p_country_code              IN      VARCHAR2
                        ,p_company_num               IN      NUMBER
                        ,p_store_acronym             IN      VARCHAR2
                        ,p_store_cost_center         IN      VARCHAR2
                        ,p_area_type_code            IN      VARCHAR2
                        ,p_sale_date                 IN      DATE
                        ,p_tax_type                  IN      VARCHAR2
                        ,p_tax_name                  IN      VARCHAR2
                        ,x_sale_id                   OUT     NUMBER
                        ,x_found                     OUT     BOOLEAN
                        ,x_mesg_error                OUT     VARCHAR2
                         ) IS 

  v_sale_id         NUMBER;  
  v_mesg_error      VARCHAR2(32767);
  v_found           BOOLEAN;
  
  
BEGIN

    BEGIN
        SELECT xfst.sale_id
        INTO v_sale_id
        FROM dual
            ,xx_fla_sales_taxes xfst
        WHERE 1 = 1
        AND xfst.country_code            = p_country_code
        AND xfst.company_num             = p_company_num
        AND xfst.store_acronym           = p_store_acronym
        AND xfst.store_cost_center       = p_store_cost_center
        AND xfst.area_type_code          = p_area_type_code
        AND xfst.sale_date               = p_sale_date
        AND xfst.tax_type                = p_tax_type
        AND xfst.tax_name                = p_tax_name
        ;
        
        v_found      := TRUE;
        
        EXCEPTION
        
            WHEN NO_DATA_FOUND THEN                
               v_sale_id    := NULL; 
               v_found      := FALSE;
            WHEN OTHERS THEN
               v_sale_id    := NULL;
               v_mesg_error := message('XX_FLA_PROPERTY_GEN',SQLERRM);
               v_found      := FALSE;
    END;    
    
    IF v_mesg_error IS NULL
       AND v_found  = FALSE 
    THEN

        BEGIN
            
                v_sale_id   := xx_fla_sales_taxes_s.NEXTVAL;
                v_found     := FALSE;
            
            EXCEPTION
                
                WHEN OTHERS THEN
                    v_mesg_error := message('XX_FLA_SALES_TAXES_SEQ',SQLERRM);
                    v_found      := FALSE;
        END; 

        
    END IF;

    IF v_mesg_error IS NULL
    THEN
        
            x_sale_id   := v_sale_id;
            x_found     := v_found;
            
        ELSE
        
            x_sale_id       := NULL;
            x_found         := FALSE;
            x_mesg_error    := v_mesg_error;
    END IF;

END get_sale_taxes;

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
PROCEDURE create_update_sales_taxes( p_request_id       IN      NUMBER
                                    ,p_request_phase_id IN      NUMBER
                                    ,p_draft_flag       IN      VARCHAR2
                                    ,p_debug_flag       IN      VARCHAR2
                                    ,p_language         IN      VARCHAR2
                                    ,p_user_name        IN      VARCHAR2
                                    ,p_sales_taxes      IN      XX_FLA_SALES_TAXES_T 
                                    ,x_items            OUT     XX_FLA_SALES_TAXES_T 
                                    ,x_return_status    OUT     VARCHAR2
                                    ,x_msg_error        OUT     VARCHAR2
                                    )
IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4);  
  v_item                    XX_FLA_SALE_TAXES_O;
  v_items                   XX_FLA_SALES_TAXES_T;
    
  v_sale_id                 xx_fla_sales_taxes.sale_id%TYPE;
  v_sale_found              BOOLEAN;
  
BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence := 'XX_FLA_PROPERTY_INT_PKG.CREATE_UPDATE_SALES_TAXES';
  x_return_status    := 'S';
  v_items            := XX_FLA_SALES_TAXES_T();
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
         
  IF v_mesg_error  IS NULL 
     AND p_sales_taxes(1).sale_date IS NOT NULL 
  THEN     
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. sale_date: ' ||
           p_sales_taxes(1).sale_date
          ,'1'
          );
  END IF;       
  
  IF v_mesg_error  IS NULL 
     AND p_sales_taxes(1).sale_id IS NOT NULL 
  THEN     
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. sale_id: ' ||
           p_sales_taxes(1).sale_id
          ,'1'
          );
  END IF;              
  -- ---------------------------------------------------------------------------
  -- Logica del proceso.
  -- ---------------------------------------------------------------------------

  IF v_mesg_error   IS NULL
     AND p_sales_taxes    IS NULL THEN
    
    v_mesg_error := message('P_SALES_TAXES_REQ');
    
  END IF;


  IF v_mesg_error       IS NULL
     AND p_sales_taxes.COUNT  < 0 THEN
    
    v_mesg_error := message('P_SALES_TAXES_REQ');
    
  END IF;


  IF v_mesg_error       IS NULL
     AND p_sales_taxes.COUNT  > 0 THEN
    
    FOR i IN 1 .. p_sales_taxes.COUNT LOOP      



  IF v_mesg_error  IS NULL 
     AND p_sales_taxes(i).sale_date IS NOT NULL 
  THEN     
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. sale_date: ' ||
           p_sales_taxes(i).sale_date
          ,'1'
          );
  END IF;
IF v_mesg_error  IS NULL 
     AND p_sales_taxes(i).sale_id IS NOT NULL 
  THEN     
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. sale_id: ' ||
           p_sales_taxes(i).sale_id
          ,'1'
          );
  END IF;       

IF v_mesg_error  IS NULL 
     AND p_sales_taxes(i).country_code IS NOT NULL 
  THEN     
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. country_code: ' ||
           p_sales_taxes(i).country_code
          ,'1'
          );
  END IF;       

IF v_mesg_error  IS NULL 
     AND p_sales_taxes(i).store_acronym IS NOT NULL 
  THEN     
     debug(g_indent                         ||
           v_calling_sequence               ||
           '. store_acronym: ' ||
           p_sales_taxes(i).store_acronym
          ,'1'
          );
  END IF;       


              -- ---------------------------------------------------------------------------
              -- Obtiene sale_id.
              -- ---------------------------------------------------------------------------
              v_sale_id  :=     -1;
              IF v_mesg_error IS NULL 
              THEN

                    get_sale_taxes( 
                                      p_sales_taxes(i).country_code
                                     ,p_sales_taxes(i).company_num
                                     ,p_sales_taxes(i).store_acronym
                                     ,p_sales_taxes(i).store_cost_center
                                     ,p_sales_taxes(i).area_type_code
                                     ,p_sales_taxes(i).sale_date
                                     ,p_sales_taxes(i).tax_type
                                     ,p_sales_taxes(i).tax_name
                                     ,v_sale_id
                                     ,v_sale_found
                                     ,v_mesg_error
                                    );                
                
              END IF;

    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida Sale: '                       ||
            sys.diutil.bool_to_int(v_sale_found)
           ,'1'
           );

    END IF;

              IF v_mesg_error IS NULL 
                 AND v_sale_found = FALSE 
              THEN
              
                  IF NVL(p_draft_flag,'Y') = 'N' THEN
                  
                        BEGIN
                        
                            INSERT INTO xx_fla_sales_taxes (
                                                          sale_id
                                                         ,country_code
                                                         ,company_num
                                                         ,store_acronym
                                                         ,store_cost_center
                                                         ,area_type_code
                                                         ,sale_date
                                                         ,tax_type
                                                         ,tax_name
                                                         ,percentage
                                                         ,calculation_basis
                                                         ,amount
                                                         ,creation_date
                                                         ,created_by
                                                         ,last_update_date
                                                         ,last_updated_by
                                            )   VALUES (
                                                          v_sale_id
                                                         ,p_sales_taxes(i).country_code
                                                         ,p_sales_taxes(i).company_num
                                                         ,p_sales_taxes(i).store_acronym
                                                         ,p_sales_taxes(i).store_cost_center
                                                         ,p_sales_taxes(i).area_type_code
                                                         ,p_sales_taxes(i).sale_date
                                                         ,p_sales_taxes(i).tax_type
                                                         ,p_sales_taxes(i).tax_name
                                                         ,p_sales_taxes(i).percentage
                                                         ,p_sales_taxes(i).calculation_basis
                                                         ,p_sales_taxes(i).amount
                                                         ,SYSDATE
                                                         ,p_user_name
                                                         ,SYSDATE
                                                         ,p_user_name
                                            );
                        
                        
                            EXCEPTION
                            
                                WHEN OTHERS THEN
                            
                                    v_mesg_error := message('XX_FLA_SALES_TAXES_INSERT',SQLERRM);
                        END;
    
                  END IF;

              END IF;

    IF v_mesg_error IS NULL
       AND v_sale_found = FALSE
    THEN
      debug(g_indent                 ||
            v_calling_sequence       ||
            '. Valida INSERT Sale: ' ||
            v_sale_id
           ,'1'
           );

    END IF;    
    
    
    
              IF v_mesg_error IS NULL 
                 AND v_sale_found = TRUE 
              THEN
              
                  IF NVL(p_draft_flag,'Y') = 'N' THEN
                  
                        BEGIN
    
                            UPDATE xx_fla_sales_taxes 
                            SET  country_code               =   p_sales_taxes(i).country_code
                                ,company_num                =   p_sales_taxes(i).company_num
                                ,store_acronym              =   p_sales_taxes(i).store_acronym
                                ,store_cost_center          =   p_sales_taxes(i).store_cost_center
                                ,area_type_code             =   p_sales_taxes(i).area_type_code
                                ,sale_date                  =   p_sales_taxes(i).sale_date
                                ,tax_type                   =   p_sales_taxes(i).tax_type
                                ,tax_name                   =   p_sales_taxes(i).tax_name
                                ,percentage                 =   p_sales_taxes(i).percentage
                                ,calculation_basis          =   p_sales_taxes(i).calculation_basis
                                ,amount                     =   p_sales_taxes(i).amount
                                ,last_update_date           =   SYSDATE
                                ,last_updated_by            =   p_user_name
                            WHERE 1 = 1
                            AND sale_id = v_sale_id;
                        
                            EXCEPTION
                            
                                WHEN OTHERS THEN
                            
                                    v_mesg_error := message('XX_FLA_SALES_TAXES_UPDATE',SQLERRM);
                        END;
    
                  END IF;

              END IF;

    IF v_mesg_error IS NULL
       AND v_sale_found = TRUE 
    THEN
      debug(g_indent                 ||
            v_calling_sequence       ||
            '. Valida UPDATE Sale: ' ||
            v_sale_id
           ,'1'
           );

    END IF;    

        v_item    := NULL;
        v_item    := xx_fla_sale_taxes_o(
                                     v_sale_id
                                    ,p_sales_taxes(i).country_code
                                    ,p_sales_taxes(i).company_num
                                    ,p_sales_taxes(i).store_acronym
                                    ,p_sales_taxes(i).store_cost_center
                                    ,p_sales_taxes(i).area_type_code
                                    ,p_sales_taxes(i).sale_date
                                    ,p_sales_taxes(i).tax_type
                                    ,p_sales_taxes(i).tax_name
                                    ,p_sales_taxes(i).percentage
                                    ,p_sales_taxes(i).calculation_basis
                                    ,p_sales_taxes(i).amount
                                   ); 

        v_items.EXTEND;
        v_items(v_items.COUNT)  :=  v_item;
        
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
        
        x_items  :=  v_items;
        
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
END create_update_sales_taxes;

/*=========================================================================+
|                                                                          |
| Public Procedure                                                         |
|    GET_INDEX_HISTORY_LINE                                                |
|                                                                          |
| Description                                                              |
|    (descripcion del procedimiento)                                       |
|                                                                          |
| Parameters                                                               |
|    p_index_id             IN     NUMBER   Ide de Indice.                 |
|    p_index_date           IN     DATE     Fecha de valor del indice      | 
|    x_index_line_id        IN     NUMBER   Identificador de linea         | 
|                                               de indice.                 |
|    x_found                OUT    BOOLEAN    Flag que indica si           |
|                                               encontro el registro.      |
|    x_msg_error            OUT    VARCHAR2   Mensaje de error.            |
|                                                                          |
+=========================================================================*/
PROCEDURE get_index_history_line( 
                                 p_index_id                  IN      NUMBER
                                ,p_index_date                IN      DATE
                                ,x_index_line_id             OUT     NUMBER
                                ,x_found                     OUT     BOOLEAN
                                ,x_mesg_error                OUT     VARCHAR2
                                 ) IS 

  v_calling_sequence    VARCHAR2(2000);
  
  v_index_line_id       NUMBER;  
  v_mesg_error          VARCHAR2(32767);
  v_found               BOOLEAN;

  
  
BEGIN

  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence := 'XX_FLA_PROPERTY_INT_PKG.GET_INDEX_HISTORY_LINE';


    BEGIN
        SELECT xfihl.index_line_id
        INTO v_index_line_id
        FROM dual
            ,xx_fla_index_history_lines xfihl
        WHERE 1 = 1
        AND xfihl.index_id      = p_index_id
        AND xfihl.index_date    = p_index_date
        ;
        
        v_found      := TRUE;
        
        EXCEPTION
        
            WHEN NO_DATA_FOUND THEN                
               v_index_line_id  := NULL; 
               v_found          := FALSE;
            WHEN OTHERS THEN
               v_index_line_id  := NULL;
               v_mesg_error     := message('XX_FLA_PROPERTY_GEN',SQLERRM);
               v_found          := FALSE;
    END;    


    IF v_mesg_error IS NULL
       AND v_index_line_id IS NULL THEN

        BEGIN
            
                v_index_line_id := xx_fla_index_history_lines_s.NEXTVAL;
                v_found         := FALSE;
            
            EXCEPTION
                
                WHEN OTHERS THEN
                    v_mesg_error := message('XX_FLA_INDEX_HISTORY_LINES_SEQ',SQLERRM);
                    v_found      := FALSE;
        END; 

        
    END IF;

    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida index_line_id: '              ||
            v_index_line_id
           ,'1'
           );

    END IF;    
    

    IF v_mesg_error IS NULL
    THEN

          debug(g_indent                                ||
                v_calling_sequence                      ||
                '. get_index_history_line.Ok: '                  
               ,'1'
               );
        
            x_index_line_id := v_index_line_id;
            x_found         := v_found;
            
        ELSE

          debug(g_indent                                ||
                v_calling_sequence                      ||
                '. get_index_history_line.Error: '                  
               ,'1'
               );

        
            x_index_line_id := NULL;
            x_found         := FALSE;
            x_mesg_error    := v_mesg_error;
    END IF;

END get_index_history_line;
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
                                           )
IS
  v_calling_sequence        VARCHAR2(2000);
  v_mesg_error              VARCHAR2(32767);
  v_language                VARCHAR2(4);  
  v_item                    XX_FLA_INDEX_HISTORY_LINE_O;
  v_items                   XX_FLA_INDEX_HISTORY_LINES_T;
  
  v_index_line_id           xx_fla_index_history_lines.index_line_id%TYPE;
  v_index_line_found        BOOLEAN;

  v_index_figure            NUMBER;
  v_sql_rowcount            NUMBER;
  

  -- ---------------------------------------------------------------------------
  -- Declaracion de Cursores.
  -- ---------------------------------------------------------------------------  
    CURSOR c_index_lines (p_index_id            NUMBER
                         ,p_index_date_from     DATE
                         ,p_index_date_to       DATE) IS
    SELECT xfihl.index_line_id
          ,xfihl.index_date
          ,xfihl.index_value
          ,xfihl.index_var
      FROM xx_fla_index_history_lines xfihl
     WHERE 1 = 1
       AND xfihl.index_id         = p_index_id
       AND xfihl.index_date BETWEEN p_index_date_from
                                AND p_index_date_to
     ORDER BY
           xfihl.index_date;

  
BEGIN
  -- ---------------------------------------------------------------------------
  -- Inicializa variables.
  -- ---------------------------------------------------------------------------
  v_calling_sequence := 'XX_FLA_PROPERTY_INT_PKG.CREATE_UPDATE_INDEX_HISTORY_LINES';
  x_return_status    := 'S';
  
  v_items            := XX_FLA_INDEX_HISTORY_LINES_T(); 
  

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
         v_mesg_error := message('XX_FLA_PROPERTY_GEN',SQLERRM);
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

  IF v_mesg_error   IS NULL
     AND p_items    IS NULL THEN
    
    v_mesg_error := message('P_INDEX_HISTORY_LINES_REQ');
    
  END IF;


  IF v_mesg_error       IS NULL
     AND p_items.COUNT  < 0 THEN
    
    v_mesg_error := message('P_INDEX_HISTORY_LINES_REQ');
    
  END IF;


  IF v_mesg_error       IS NULL
     AND p_items.COUNT  > 0 THEN
    
    FOR i IN 1 .. p_items.COUNT LOOP      

          -- ---------------------------------------------------------------------------
          -- Obtiene la fecha de indice desde y hasta.
          -- ---------------------------------------------------------------------------
          IF v_mesg_error IS NULL THEN
        
             debug(g_indent                    ||
                   v_calling_sequence          ||
                   '. Fecha de indice desde: ' ||
                   TO_CHAR(p_items(i).index_date_from
                          ,'DD-MON-YYYY'
                          )
                  ,'1'
                  );
             debug(g_indent                    ||
                   v_calling_sequence          ||
                   '. Fecha de indice hasta: ' ||
                   TO_CHAR(p_items(i).index_date_to
                          ,'DD-MON-YYYY'
                          )
                  ,'1'
                  );
        
          END IF;  
          
            IF v_mesg_error IS NULL
            THEN
              debug(g_indent                                ||
                    v_calling_sequence                      ||
                    '. Valida index_id: '                   ||
                    p_items(i).index_id
                   ,'1'
                   );
        
            END IF;
            
            IF v_mesg_error IS NULL
            THEN
              debug(g_indent                                ||
                    v_calling_sequence                      ||
                    '. Valida index_date: '                 ||
                    p_items(i).index_date
                   ,'1'
                   );
        
            END IF; 
            
              -- ---------------------------------------------------------------------------
              -- Obtiene index_line_id.
              -- ---------------------------------------------------------------------------
              v_index_line_id  :=     -1;
              IF v_mesg_error IS NULL 
                 AND NVL(p_draft_flag,'Y') = 'N'
              THEN

                    get_index_history_line( 
                                           p_items(i).index_id
                                          ,p_items(i).index_date
                                          ,v_index_line_id
                                          ,v_index_line_found
                                          ,v_mesg_error
                                         );                
                
              END IF;

    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida index_line_id: '              ||
            v_index_line_id
           ,'1'
           );

    END IF;

    IF v_mesg_error IS NULL
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida Found Index_History_Line: '   ||
            sys.diutil.bool_to_int(v_index_line_found)
           ,'1'
           );

    END IF;
              IF v_mesg_error IS NULL 
                 AND v_index_line_found = FALSE 
              THEN
              
                  IF NVL(p_draft_flag,'Y') = 'N' THEN
                  
                        BEGIN
                        
                            INSERT INTO xx_fla_index_history_lines (
                                                                     index_line_id
                                                                    ,index_id
                                                                    ,index_date
                                                                    ,index_value
                                                                    ,index_var            
                                                                    ,creation_date
                                                                    ,created_by
                                                                    ,last_update_date
                                                                    ,last_updated_by
                                                        )   VALUES (
                                                                      v_index_line_id
                                                                     ,p_items(i).index_id
                                                                     ,p_items(i).index_date
                                                                     ,p_items(i).index_value
                                                                     ,p_items(i).index_var
                                                                     ,SYSDATE
                                                                     ,-1 --p_user_name
                                                                     ,SYSDATE
                                                                     ,-1 --p_user_name
                                                        );
                        
                        
                            EXCEPTION
                            
                                WHEN OTHERS THEN
                            
                                    v_mesg_error := message('XX_FLA_INDEX_HISTORY_LINES_INSERT',SQLERRM);
                        END;
    
                  END IF;

              END IF;

    IF v_mesg_error             IS NULL
       AND v_index_line_found   = TRUE
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida INSERT Index History Line: '  ||
            v_index_line_id
           ,'1'
           );

    END IF;    
    
    
    
              IF v_mesg_error           IS NULL 
                 AND v_index_line_found = TRUE 
              THEN
              
                  IF NVL(p_draft_flag,'Y') = 'N' THEN
                  
                        BEGIN
    
                            UPDATE xx_fla_index_history_lines 
                            SET  index_id           =   p_items(i).index_id
                                ,index_date         =   p_items(i).index_date
                                ,index_value        =   p_items(i).index_value
                                ,index_var          =   p_items(i).index_var
                                ,last_update_date   =   SYSDATE
                                ,last_updated_by    =   -1 --p_user_name
                            WHERE 1 = 1
                            AND index_line_id = v_index_line_id;
                        
                            EXCEPTION
                            
                                WHEN OTHERS THEN
                            
                                    v_mesg_error := message('XX_FLA_INDEX_HISTORY_LINES_UPDATE',SQLERRM);
                        END;
    
                  END IF;

              END IF;

    IF v_mesg_error             IS NULL
       AND v_index_line_found   = FALSE 
    THEN
      debug(g_indent                                ||
            v_calling_sequence                      ||
            '. Valida UPDATE Index History Line: '  ||
            v_index_line_id
           ,'1'
           );

    END IF;    


               v_index_figure := NVL(p_items(i).index_value,1);
               FOR r_index_line IN c_index_lines (p_items(i).index_id
                                                 ,p_items(i).index_date_from 
                                                 ,p_items(i).index_date_to) LOOP
                    v_sql_rowcount := 0;                             
                   debug(g_indent               ||
                         v_calling_sequence     ||
                         '. Fecha: '            ||
                         TO_CHAR(r_index_line.index_date
                                ,'DD-MON-YYYY'
                                )
                        ,'1'
                        );
                   debug(g_indent                   ||
                         v_calling_sequence         ||
                         '. Porc. variacion: '      ||
                         TO_CHAR(r_index_line.index_value)
                        ,'1'
                        );
                   v_index_figure := NVL(v_index_figure,1)*(1+(NVL(r_index_line.index_value,0)/100));
                   debug(g_indent                ||
                         v_calling_sequence      ||
                         '. Indice: '            ||
                         TO_CHAR(v_index_figure)
                        ,'1'
                        );
                   BEGIN
                     UPDATE xx_fla_index_history_lines pihl
                        SET index_var         = v_index_figure
                           ,last_update_date  = SYSDATE
                           ,last_updated_by   = -1 --p_user_name
                      WHERE pihl.index_line_id = r_index_line.index_line_id;
                   EXCEPTION
                     WHEN others THEN
                       v_mesg_error := message('XX_FLA_INDEX_HISTORY_LINES_UPDATE',SQLERRM);
                       EXIT;
                   END;
                   v_sql_rowcount := NVL(SQL%ROWCOUNT,0);
                   debug(g_indent                       ||
                         v_calling_sequence             ||
                         '. Se actualizaron: '          ||
                         TO_CHAR(NVL(v_sql_rowcount,0)) ||
                         ' indices.'
                        ,'1'
                        );
      
      
                    v_item    := NULL;
                    v_item    := xx_fla_index_history_line_o(
                                                              r_index_line.index_line_id
                                                             ,p_items(i).index_id
                                                             ,r_index_line.index_date
                                                             ,r_index_line.index_value
                                                             ,v_index_figure
                                                             ,p_items(i).index_date_from
                                                             ,p_items(i).index_date_to
                                               ); 
            
                    v_items.EXTEND;
                    v_items(v_items.COUNT)  :=  v_item;


      
               END LOOP;   

    END LOOP;
   
   
   /*
   
   
   */
   
    
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
        
        x_items := v_items;
        
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
    
END create_update_index_history_lines;



END xx_fla_property_int_pkg;
/