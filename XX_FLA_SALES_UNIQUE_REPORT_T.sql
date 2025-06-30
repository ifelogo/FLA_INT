/* $Header: XX_FLA_SALES_UNIQUE_REPORT_T.sql 11.1.1111.0 2025/05/23 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_SALES_UNIQUE_REPORT_T.sql                                   |
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
REM |    23-MAY-25  iloaiza       Created                                   |
REM |                                                                       |
REM | NOTES                                                                 |
REM |                                                                       |
REM +=======================================================================+


SPOOL XX_FLA_SALES_UNIQUE_REPORT_T.log


PROMPT =====================================================================
PROMPT Script XX_FLA_SALES_UNIQUE_REPORT_T.sql
PROMPT =====================================================================


PROMPT Drop type XX_FLA_SALES_UNIQUE_REPORT_T
DROP TYPE xx_fla_sales_unique_report_t FORCE;

PROMPT Drop type XX_FLA_SALES_UNIQUE_REPORT_O
DROP TYPE xx_fla_sales_unique_report_o FORCE;

PROMPT Create type XX_FLA_SALES_UNIQUE_REPORT_O
CREATE OR REPLACE TYPE xx_fla_sales_unique_report_o AS OBJECT
(
 country_code			VARCHAR2(3)
,company_num			NUMBER(10)
,store_acronym			VARCHAR2(3)
,store_cost_center		VARCHAR2(6)
,area_type_code			VARCHAR2(30)
,sale_date			DATE
,source				VARCHAR2(50)
,lease_type			VARCHAR2(30)
,payment_purpose_code		VARCHAR2(30)
,entity_type			VARCHAR2(300)
,sale_id			NUMBER(15)
,mesg_error			VARCHAR2(4000)
)
;
/

PROMPT Create type XX_FLA_SALES_UNIQUE_REPORT_T
CREATE OR REPLACE EDITIONABLE TYPE xx_fla_sales_unique_report_t AS TABLE 
                                OF xx_fla_sales_unique_report_o 
;
/


SPOOL OFF


-- EXIT
