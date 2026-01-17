/* $Header: XX_FLA_COMMON_INT_REST_COLUMNS.sql 11.1.1111.0 2025/06/08 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_COMMON_INT_REST_COLUMNS.sql                                 |
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
REM |    08-JUL-25  iloaiza       Created                                   |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL XX_FLA_COMMON_INT_REST_COLUMNS.log


PROMPT =====================================================================
PROMPT Script XX_FLA_COMMON_INT_REST_COLUMNS.sql
PROMPT =====================================================================


PROMPT Drop table xx_fla_common_int_rest_columns
DROP TABLE xx_fla_common_int_rest_columns;


PROMPT Create table xx_fla_common_int_rest_columns
CREATE TABLE xx_fla_common_int_rest_columns (
 rest_column_id            NUMBER
,integration_code   VARCHAR2(150)
,step		    NUMBER
,root_item          VARCHAR2(100) 
,step_object        VARCHAR2(100) 
,column_name        VARCHAR2(100) 
,enabled_flag       VARCHAR2(1)
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


