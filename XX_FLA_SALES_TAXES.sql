/* $Header: .sql 11.1.1111.0 2025/05/26 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_SALES_TAXES.sql                                             |
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
REM |    26-MAY-25  iloaiza       Created                                   |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL XX_FLA_SALES_TAXES.log


PROMPT =====================================================================
PROMPT Script XX_FLA_SALES_TAXES.sql
PROMPT =====================================================================


PROMPT Drop table XX_FLA_SALES_TAXES
DROP TABLE xx_fla_sales_taxes;


PROMPT Create table XX_FLA_SALES_TAXES
CREATE TABLE xx_fla_sales_taxes (
 sale_id            NUMBER
,country_code       VARCHAR2(150)
,company_num        NUMBER(3)
,store_acronym      VARCHAR2(3)
,store_cost_center  VARCHAR2(6)
,area_type_code     VARCHAR2(30)
,sale_date          DATE
,tax_type     	    VARCHAR2(30)
,tax_name     	    VARCHAR2(30)
,percentage    	    NUMBER
,calculation_basis  NUMBER
,amount    	    NUMBER
,creation_date      DATE
,created_by         VARCHAR2(256)
,last_update_date   DATE
,last_updated_by    VARCHAR2(256)
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


