/* $Header: XX_FLA_COUNTRIES_T.sql 11.1.1111.0 2025/04/24 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_COUNTRIES_T.sql                                             |
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
REM |    24-APR-25  iloaiza       Created                                   |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL XX_FLA_COUNTRIES_T.log


PROMPT =====================================================================
PROMPT Script XX_FLA_COUNTRIES_T.sql
PROMPT =====================================================================


PROMPT Drop type XX_FLA_COUNTRIES_T
DROP TYPE xx_fla_countries_t FORCE;

PROMPT Drop type XX_FLA_COUNTRY_O
DROP TYPE xx_fla_country_o FORCE;

PROMPT Create type XX_FLA_COUNTRY_O
CREATE OR REPLACE TYPE xx_fla_country_o AS OBJECT
(
 territory_short_name	VARCHAR2(320)
,territory_num       	VARCHAR2(8)
)
;
/

PROMPT Create type XX_FLA_COUNTRIES_T
CREATE OR REPLACE EDITIONABLE TYPE xx_fla_countries_t AS TABLE 
                                OF xx_fla_country_o
;
/


SPOOL OFF


-- EXIT
