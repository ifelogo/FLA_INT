/* $Header: XX_FLA_COMMON_EXEC_REQS_T.sql 11.1.1111.0 2025/05/27 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_COMMON_EXEC_REQS_T.sql                                      |
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
REM |    27-JUN-25  iloaiza       Created                                   |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL XX_FLA_COMMON_EXEC_REQS_T.log


PROMPT =====================================================================
PROMPT Script XX_FLA_COMMON_EXEC_REQS_T.sql
PROMPT =====================================================================


PROMPT Drop type XX_FLA_COMMON_EXEC_REQS_T
DROP TYPE xx_fla_common_exec_reqs_t FORCE;

PROMPT Drop type XX_FLA_COMMON_EXEC_REQ_O
DROP TYPE xx_fla_common_exec_req_o FORCE;

PROMPT Create type XX_FLA_COMMON_EXEC_REQ_O
CREATE OR REPLACE TYPE xx_fla_common_exec_req_o AS OBJECT
(
 request	    VARCHAR2(2000)
)
;
/

PROMPT Create type XX_FLA_COMMON_EXEC_REQS_T
CREATE OR REPLACE EDITIONABLE TYPE xx_fla_common_exec_reqs_t AS TABLE 
                                OF xx_fla_common_exec_req_o 
;
/


SPOOL OFF


-- EXIT
