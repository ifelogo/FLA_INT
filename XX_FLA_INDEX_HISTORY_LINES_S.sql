/* $Header: XX_FLA_INDEX_HISTORY_LINES_S.sql 11.1.1111.0 2025/04/21 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_INDEX_HISTORY_LINES_S.sql     	                    	    |
REM |                                                                       |
REM | DESCRIPTION                                                           |
REM |    Create sequences.                                                  |
REM |                                                                       |
REM | LANGUAGE                                                              |
REM |    PL/SQL                                                             |
REM |                                                                       |
REM | PRODUCT                                                               |
REM |    Oracle Cloud                                                       |
REM |                                                                       |
REM | HISTORY                                                               |
REM |    21-APR-25  iloaiza        Created                                  |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL XX_FLA_INDEX_HISTORY_LINES_S.log


PROMPT =====================================================================
PROMPT Script XX_FLA_INDEX_HISTORY_LINES_S.sql
PROMPT =====================================================================


PROMPT Drop sequence XX_FLA_INDEX_HISTORY_LINES_S
DROP SEQUENCE xx_fla_index_history_lines_s;


PROMPT Create sequence XX_FLA_INDEX_HISTORY_LINES_S
CREATE SEQUENCE xx_fla_index_history_lines_s START WITH 1 NOCACHE ORDER;


SPOOL OFF


-- EXIT


