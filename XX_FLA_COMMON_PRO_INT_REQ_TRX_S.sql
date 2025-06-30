/* $Header: XX_FLA_COMMON_PRO_INT_REQ_TRX_S.sql 11.1.1111.0 2025/05/26 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_COMMON_PRO_INT_REQ_TRX_S.sql                                |
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
REM |    26-JUN-25  iloaiza        Created                                  |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL XX_FLA_COMMON_PRO_INT_REQ_TRX_S.log


PROMPT =====================================================================
PROMPT Script XX_FLA_COMMON_PRO_INT_REQ_TRX_S.sql
PROMPT =====================================================================


PROMPT Drop sequence XX_FLA_COMMON_PRO_INT_REQ_TRX_S
DROP SEQUENCE xx_fla_common_pro_int_req_trx_s;


PROMPT Create sequence XX_FLA_COMMON_PRO_INT_REQ_TRX_S
CREATE SEQUENCE xx_fla_common_pro_int_req_trx_s START WITH 1 NOCACHE ORDER;


SPOOL OFF


-- EXIT


