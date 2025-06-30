/* $Header: XX_FLA_COMMON_INT_NEXT_STEPS.sql 11.1.1111.0 2025/05/26 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_COMMON_INT_NEXT_STEPS.sql                                   |
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
REM |    26-JUN-25  iloaiza       Created                                   |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL XX_FLA_COMMON_INT_NEXT_STEPS.log


PROMPT =====================================================================
PROMPT Script XX_FLA_COMMON_INT_NEXT_STEPS.sql
PROMPT =====================================================================


PROMPT Drop table xx_fla_common_int_next_steps
DROP TABLE xx_fla_common_int_next_steps;


PROMPT Create table xx_fla_common_int_next_steps
CREATE TABLE xx_fla_common_int_next_steps (
 next_step_id           NUMBER
,integration_code   	VARCHAR2(150)
,to_step          	NUMBER
,from_field          	VARCHAR2(240)
,to_field        	VARCHAR2(240)
,to_field_type        	VARCHAR2(5)
,to_value       	VARCHAR2(4000)
,transformation         VARCHAR2(2000)
,request_order		NUMBER
,creation_date      	DATE
,created_by         	VARCHAR2(256)
,last_update_date   	DATE
,last_updated_by    	VARCHAR2(256)
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


