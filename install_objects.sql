/* $Header: install_objects.sql 11.1.1111.0 2021/01/01 12:00:00 giturbur noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    install_objects.sql                                                |
REM |                                                                       |
REM | DESCRIPTION                                                           |
REM |    Install database objects.                                          |
REM |                                                                       |
REM | LANGUAGE                                                              |
REM |    PL/SQL                                                             |
REM |                                                                       |
REM | PRODUCT                                                               |
REM |    Oracle Cloud                                                       |
REM |                                                                       |
REM | HISTORY                                                               |
REM |    01-JAN-21  giturbur      Created                                   |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL install_objects.log


PROMPT =====================================================================
PROMPT Script install_objects.sql
PROMPT =====================================================================

SHOW USER

SELECT TO_CHAR(SYSDATE,'DD-MON-YYYY HH24:MI:SS') AS "Start_Date"
  FROM dual;

SELECT 'Datatabase Name...: '||SYS_CONTEXT('USERENV','DB_NAME')||CHR(10)||
       'Instance Name.....: '||SYS_CONTEXT('USERENV','INSTANCE_NAME')||CHR(10)||
       'Service Name......: '||SYS_CONTEXT('USERENV','SERVICE_NAME') AS "Environment"
  FROM dual;


PROMPT =====================================================================
PROMPT Tables and indexes.
PROMPT =====================================================================

SPOOL OFF


SPOOL install_objects.log APPEND


PROMPT =====================================================================
PROMPT Packages.
PROMPT =====================================================================

SPOOL OFF

@@XX_FLA_COMMON_PRO_INT_PKG.pls
HOST type XX_FLA_COMMON_PRO_INT_PKG.log >> install_objects.log
@@XX_FLA_PROPERTY_INT_PKG.plb
HOST type XX_FLA_COMMON_PRO_INT_PKG.log >> install_objects.log

SPOOL install_objects.log APPEND

PROMPT =====================================================================
SELECT TO_CHAR(SYSDATE,'DD-MON-YYYY HH24:MI:SS') AS "End_Date"
  FROM dual;


SPOOL OFF


-- EXIT


