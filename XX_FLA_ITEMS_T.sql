/* $Header: XX_FLA_ITEMS_T.sql 11.1.1111.0 2025/05/15 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_ITEMS_T.sql                                                 |
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
REM |    15-APR-25  iloaiza       Created                                   |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL XX_FLA_ITEMS_T.log


PROMPT =====================================================================
PROMPT Script XX_FLA_ITEMS_T.sql
PROMPT =====================================================================


PROMPT Drop type XX_FLA_ITEMS_T
DROP TYPE xx_fla_items_t FORCE;

PROMPT Drop type XX_FLA_ITEM_O
DROP TYPE xx_fla_item_o FORCE;

PROMPT Create type XX_FLA_ITEM_O
CREATE OR REPLACE TYPE xx_fla_item_o AS OBJECT
(
 item_id            NUMBER
,country_code       VARCHAR2(150)
,item_code          NUMBER
,description        VARCHAR2(2000)
,enabled_flag       VARCHAR2(1)
,request_id         NUMBER
)
;
/

PROMPT Create type XX_FLA_ITEMS_T
CREATE OR REPLACE EDITIONABLE TYPE xx_fla_items_t AS TABLE 
                                OF xx_fla_item_o
;
/


SPOOL OFF


-- EXIT
