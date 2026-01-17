/* $Header: XX_FLA_SALES_TAXES_T.sql 11.1.1111.0 2025/08/13 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_SALES_TAXES_T.sql                                           |
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
REM |    13-AUG-25  iloaiza       Created                                   |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL XX_FLA_SALES_TAXES_T.log


PROMPT =====================================================================
PROMPT Script XX_FLA_SALES_TAXES_T.sql
PROMPT =====================================================================


PROMPT Drop type XX_FLA_SALES_TAXES_T
DROP TYPE xx_fla_sales_taxes_t FORCE;

PROMPT Drop type XX_FLA_SALE_TAXES_O
DROP TYPE xx_fla_sale_taxes_o FORCE;

PROMPT Create type XX_FLA_SALE_TAXES_O
CREATE OR REPLACE TYPE xx_fla_sale_taxes_o AS OBJECT
(
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
,error_msg	    VARCHAR2(4000)
)
;
/

PROMPT Create type XX_FLA_SALES_TAXES_T
CREATE OR REPLACE EDITIONABLE TYPE xx_fla_sales_taxes_t AS TABLE 
                                OF xx_fla_sale_taxes_o
;
/


SPOOL OFF


-- EXIT
