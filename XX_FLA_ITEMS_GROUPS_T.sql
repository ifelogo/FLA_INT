/* $Header: XX_FLA_ITEMS_GROUPS_T.sql 11.1.1111.0 2025/04/24 12:00:00 iloaiza noship $ */
REM +=======================================================================+
REM |    Copyright (c) 1997 Oracle Argentina, Buenos Aires                  |
REM |                         All rights reserved.                          |
REM +=======================================================================+
REM | FILENAME                                                              |
REM |    XX_FLA_ITEMS_GROUPS_T.sql                                          |
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


SPOOL XX_FLA_ITEMS_GROUPS_T.log


PROMPT =====================================================================
PROMPT Script XX_FLA_ITEMS_GROUPS_T.sql
PROMPT =====================================================================


PROMPT Drop type XX_FLA_ITEMS_GROUPS_T
DROP TYPE xx_fla_items_groups_t FORCE;

PROMPT Drop type XX_FLA_ITEM_GROUP_O
DROP TYPE xx_fla_item_group_o FORCE;


PROMPT Create type XX_FLA_ITEM_GROUP_O
CREATE OR REPLACE TYPE xx_fla_item_group_o AS OBJECT
(
 territory_code 	VARCHAR2(8) 
,territory_num       VARCHAR2(8)
,org_name		VARCHAR2(960)
,grp_item_id		NUMBER
,grp_item_desc		VARCHAR2(240)
,store_acronym		VARCHAR2(30)
,store_cost_center	VARCHAR2(10) 
,day_reference		NUMBER
,item_code_list		VARCHAR2(4000)
,reference_date		DATE
)
;
/

PROMPT Create type XX_FLA_ITEMS_GROUPS_T
CREATE OR REPLACE EDITIONABLE TYPE xx_fla_items_groups_t AS TABLE 
                                OF xx_fla_item_group_o
;
/


SPOOL OFF


-- EXIT
