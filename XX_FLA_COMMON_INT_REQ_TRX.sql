/* $Header: XX_FLA_COMMON_INT_REQ_TRX.sql 11.1.1111.0 2025/05/26 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_COMMON_INT_REQ_TRX.sql                                      |
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
REM |    26-jun-25  iloaiza       Created                                   |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL XX_FLA_COMMON_INT_REQ_TRX.log


PROMPT =====================================================================
PROMPT Script XX_FLA_COMMON_INT_REQ_TRX.sql
PROMPT =====================================================================


PROMPT Drop table xx_fla_common_int_req_trx
DROP TABLE xx_fla_common_int_req_trx;


PROMPT Create table xx_fla_common_int_req_trx
CREATE TABLE xx_fla_common_int_req_trx (
 req_trx_id            NUMBER
,request_id	    VARCHAR2(150)
,integration_code   VARCHAR2(150)
,step   	    NUMBER
,iteration   	    NUMBER
,param_key          VARCHAR2(240)
,param_value        VARCHAR2(4000)
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


