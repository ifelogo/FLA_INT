/* $Header: XX_FLA_INDEX_HISTORY_LINES_T.sql 11.1.1111.0 2025/04/21 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_INDEX_HISTORY_LINES_T.sql                                   |
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
REM |    21-APR-25  iloaiza       Created                                   |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL XX_FLA_INDEX_HISTORY_LINES_T.log


PROMPT =====================================================================
PROMPT Script XX_FLA_INDEX_HISTORY_LINES_T.sql
PROMPT =====================================================================


PROMPT Drop type XX_FLA_INDEX_HISTORY_LINES_T
DROP TYPE xx_fla_index_history_lines_t FORCE;

PROMPT Drop type XX_FLA_INDEX_HISTORY_LINE_O
DROP TYPE xx_fla_index_history_line_o FORCE;

PROMPT Create type XX_FLA_INDEX_HISTORY_LINE_O
CREATE OR REPLACE TYPE xx_fla_index_history_line_o AS OBJECT
(
 index_line_id		NUMBER
,index_id		NUMBER
,index_date		DATE
,index_value		NUMBER(15)
,index_var		NUMBER(15)
,index_date_from	DATE
,index_date_to		DATE
)
;
/

PROMPT Create type XX_FLA_INDEX_HISTORY_LINES_T
CREATE OR REPLACE EDITIONABLE TYPE xx_fla_index_history_lines_t AS TABLE 
                                OF xx_fla_index_history_line_o
;
/


SPOOL OFF


-- EXIT
