/* $Header: XX_FLA_COMMON_INT_STEPS_T.sql 11.1.1111.0 2025/05/15 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_COMMON_INT_STEPS_T.sql                                      |
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
REM |    25-JUN-25  iloaiza       Created                                   |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL XX_FLA_COMMON_INT_STEPS_T.log


PROMPT =====================================================================
PROMPT Script XX_FLA_COMMON_INT_STEPS_T.sql
PROMPT =====================================================================


PROMPT Drop type XX_FLA_COMMON_INT_STEPS_T
DROP TYPE xx_fla_common_int_steps_t FORCE;

PROMPT Drop type XX_FLA_COMMON_INT_STEP_O
DROP TYPE xx_fla_common_int_step_o FORCE;

PROMPT Create type XX_FLA_COMMON_INT_STEP_O
CREATE OR REPLACE TYPE xx_fla_common_int_step_o AS OBJECT
(
 integration_code   VARCHAR2(150)
,step		    NUMBER
,step_type          VARCHAR2(40)    -- REST / PL/SQL / FILE / MAIL
,step_object        VARCHAR2(2000)
)
;
/

PROMPT Create type XX_FLA_COMMON_INT_STEPS_T
CREATE OR REPLACE EDITIONABLE TYPE xx_fla_common_int_steps_t AS TABLE 
                                OF xx_fla_common_int_step_o 
;
/


SPOOL OFF


-- EXIT
