/* $Header: XX_FLA_ITEM_PRICES_T.sql 11.1.1111.0 2025/05/14 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_ITEM_PRICES_T.sql                                           |
REM |                                                                       |
REM | DESCRIPTION                                                           |
REM |    Create types.                                                      |
REM |                                                                       |
REM | LANGUAGE                                                              |
REM |    PL/SQL                                                             |
REM |                                                                       |
REM | PRODUCT                                                               |
REM |    Oracle Cloud                                                       |
REM |                                                                       |
REM | HISTORY                                                               |
REM |    14-APR-25  iloaiza       Created                                   |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL XX_FLA_ITEM_PRICES_T.log


PROMPT =====================================================================
PROMPT Script XX_FLA_ITEM_PRICES_T.sql
PROMPT =====================================================================


PROMPT Drop type XX_FLA_ITEM_PRICES_T
DROP TYPE xx_fla_item_prices_t FORCE;

PROMPT Drop type XX_FLA_ITEM_PRICES_O
DROP TYPE xx_fla_item_prices_o FORCE;

PROMPT Create type XX_FLA_ITEM_PRICES_O
CREATE OR REPLACE TYPE xx_fla_item_prices_o AS OBJECT
( item_price_id         NUMBER
 ,item_id               NUMBER
 ,item_code             NUMBER
 ,description		VARCHAR2(2000)
 ,store_acronym         VARCHAR2(4)
 ,store_cost_center     VARCHAR2(10)
 ,store_id              NUMBER
 ,reference_date        DATE
 ,price                 NUMBER
 ,price_tax_free        NUMBER
 ,price_type            VARCHAR2(6)
 ,request_id            NUMBER
)
;
/

PROMPT Create type XX_FLA_ITEM_PRICES_T
CREATE OR REPLACE EDITIONABLE TYPE xx_fla_item_prices_t AS TABLE 
                                OF xx_fla_item_prices_o
;
/


SPOOL OFF


-- EXIT
