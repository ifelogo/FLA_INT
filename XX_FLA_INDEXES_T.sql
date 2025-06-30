/* $Header: XX_FLA_INDEXES_T.sql 11.1.1111.0 2025/04/25 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_INDEXES_T.sql                                          |
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
REM |    25-APR-25  iloaiza       Created                                   |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL XX_FLA_INDEXES_T.log


PROMPT =====================================================================
PROMPT Script XX_FLA_INDEXES_T.sql
PROMPT =====================================================================


PROMPT Drop type XX_FLA_INDEXES_T
DROP TYPE xx_fla_indexes_t FORCE;

PROMPT Drop type XX_FLA_INDEX_O
DROP TYPE xx_fla_index_o FORCE;


PROMPT Create type XX_FLA_INDEX_O
CREATE OR REPLACE TYPE xx_fla_index_o AS OBJECT
(
 country_code		VARCHAR2(30) 
,territory_short_name	VARCHAR2(320)
,country_num		VARCHAR2(30)
,index_id		NUMBER
,index_name	        VARCHAR2(50)
,index_source		VARCHAR2(50)
,index_figure_prv	NUMBER(15,2)
,index_unadj_1_prv	NUMBER(15,2)
,index_date_from	DATE
,index_date_to		DATE
)
;
/

PROMPT Create type XX_FLA_INDEXES_T
CREATE OR REPLACE EDITIONABLE TYPE xx_fla_indexes_t AS TABLE 
                                OF xx_fla_index_o
;
/


SPOOL OFF


-- EXIT
