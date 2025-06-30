/* $Header: XX_FLA_SALES_T.sql 11.1.1111.0 2025/04/21 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_SALES_T.sql                                                 |
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


SPOOL XX_FLA_SALES_T.log


PROMPT =====================================================================
PROMPT Script XX_FLA_SALES_T.sql
PROMPT =====================================================================


PROMPT Drop type XX_FLA_SALES_T
DROP TYPE xx_fla_sales_t FORCE;

PROMPT Drop type XX_FLA_SALE_O
DROP TYPE xx_fla_sale_o FORCE;

PROMPT Create type XX_FLA_SALE_O
CREATE OR REPLACE TYPE xx_fla_sale_o AS OBJECT
(
 sale_id			NUMBER(15)
,country_code			VARCHAR2(3)
,company_num			NUMBER(10)
,store_acronym			VARCHAR2(3)
,store_cost_center		VARCHAR2(6)
,area_type_code			VARCHAR2(30)
,sale_date			DATE
,source				VARCHAR2(50)
,lease_type			VARCHAR2(30)
,payment_purpose_code		VARCHAR2(30)
,entity_type			VARCHAR2(300)
,amt_sale_net_product		NUMBER(15,2)
,amt_sale_net_noproduct		NUMBER(15,2)
,amt_sale_net			NUMBER(15,2)
,amt_sale_gross_product		NUMBER(15,2)
,amt_sale_gross_noproduct	NUMBER(15,2)
,amt_sale_gross			NUMBER(15,2)
,amt_sale_iibb_product		NUMBER(15,2)
,amt_sale_iibb_noproduct	NUMBER(15,2)
,amt_sale_iibb			NUMBER(15,2)
,amt_del_net			NUMBER(15,2)
,amt_del_gross			NUMBER(15,2)
,amt_error			NUMBER(15,2)
,amt_error_no_cancel		NUMBER(15,2)
,amt_null			NUMBER(15,2)
,amt_cancel			NUMBER(15,2)
,amt_soda			NUMBER(15,2)
,amt_free			NUMBER(15,2)
,amt_gift			NUMBER(15,2)
,amt_promotion			NUMBER(15,2)
,amt_loyalty			NUMBER(15,2)
,amt_mc_day			NUMBER(15,2)
,amt_tax_icms			NUMBER(15,2)
,amt_tax_icms_ar		NUMBER(15,2)
,amt_tax_icms_ap		NUMBER(15,2)
,amt_tax_pis			NUMBER(15,2)
,amt_tax_cofins			NUMBER(15,2)
,amt_tax_st			NUMBER(15,2)
,prc_tax			NUMBER(15,2)
,prc_delivery			NUMBER(15,2)
,qty_tc				NUMBER(15,2)
,amt_cash_map_dif		NUMBER(15,2)
,adj_status			VARCHAR2(30)
,adj_reason_code		VARCHAR2(30)
,adj_comments			VARCHAR2(300)
,adj_approved_date		DATE
,adj_approved_by		VARCHAR(100)
,request_id			NUMBER(15)
)
;
/

PROMPT Create type XX_FLA_SALES_T
CREATE OR REPLACE EDITIONABLE TYPE xx_fla_sales_t AS TABLE 
                                OF xx_fla_sale_o
;
/


SPOOL OFF


-- EXIT
