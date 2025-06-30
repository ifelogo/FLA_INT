/* $Header: XX_FLA_ITEMS.sql 11.1.1111.0 2025/04/15 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_ITEMS.sql                                                   |
REM |                                                                       |
REM | DESCRIPTION                                                           |
REM |    Create tables and indexes.                                         |
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


SPOOL XX_FLA_ITEMS.log


PROMPT =====================================================================
PROMPT Script XX_FLA_ITEMS.sql
PROMPT =====================================================================


PROMPT Drop table XX_FLA_ITEMS
DROP TABLE xx_fla_items;


PROMPT Create table XX_FLA_ITEMS
CREATE TABLE xx_fla_items (
 item_id            NUMBER
,country_code       VARCHAR2(150)
,item_code          NUMBER
,description        VARCHAR2(2000)
,enabled_flag       VARCHAR2(1)
,request_id         NUMBER
,creation_date      DATE
,created_by         VARCHAR2(256)
,last_update_date   DATE
,last_updated_by    VARCHAR2(256)
)
TABLESPACE xx
   NOLOGGING
   NO INMEMORY
   PCTFREE      10
   PCTUSED      60
   INITRANS     10
   MAXTRANS    255
   STORAGE (INITIAL              16384
            NEXT               2129920
            MINEXTENTS               1
            MAXEXTENTS      2147483645
            FREELISTS                1
            FREELIST GROUPS          1
            PCTINCREASE              0
           )
   NOCACHE;




SPOOL OFF


-- EXIT


