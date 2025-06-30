/* $Header: install_ords.sql 11.1.1111.0 2025/04/11 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    install_ords.sql                                                   |
REM |                                                                       |
REM | DESCRIPTION                                                           |
REM |    Install objects for ORDS.                                          |
REM |                                                                       |
REM | LANGUAGE                                                              |
REM |    PL/SQL                                                             |
REM |                                                                       |
REM | PRODUCT                                                               |
REM |    Oracle Cloud                                                       |
REM |                                                                       |
REM | HISTORY                                                               |
REM |    11-APR-25  iloaiza       Created                                   |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL install_ords.log


PROMPT =====================================================================
PROMPT Script install_ords.sql
PROMPT =====================================================================


SHOW USER

SELECT TO_CHAR(SYSDATE,'DD-MON-YYYY HH24:MI:SS') AS "Start_Date"
  FROM dual;

SELECT 'Datatabase Name...: '||SYS_CONTEXT('USERENV','DB_NAME')||CHR(10)||
       'Instance Name.....: '||SYS_CONTEXT('USERENV','INSTANCE_NAME')||CHR(10)||
       'Service Name......: '||SYS_CONTEXT('USERENV','SERVICE_NAME') AS "Environment"
  FROM dual;


SET SERVEROUTPUT ON SIZE 1000000


PROMPT Enable object XX_PO_CDP_INT_PKG
BEGIN
  ords.enable_object
      (p_enabled      => TRUE
      ,p_schema       => 'XX'
      ,p_object       => 'XX_PO_CDP_INT_PKG'
      ,p_object_type  => 'PACKAGE'
      ,p_object_alias => 'xx_po_cdp_int_pkg'
      );
  COMMIT;
END;
/

PROMPT Delete module XX_PO_CDP_INT_PKG
BEGIN
  ords.delete_module
      (p_module_name => 'xx_po_cdp_int'
      );
  COMMIT;
END;
/

PROMPT Define module XX_PO_CDP_INT_PKG
BEGIN
  ords.define_module
      (p_module_name    => 'xx_po_cdp_int'
      ,p_base_path      => 'xx_po_cdp_int/'
      ,p_items_per_page => 0
      );
  COMMIT;
END;
/



PROMPT =====================================================================
SELECT TO_CHAR(SYSDATE,'DD-MON-YYYY HH24:MI:SS') AS "End_Date"
  FROM dual;


SPOOL OFF


-- EXIT






