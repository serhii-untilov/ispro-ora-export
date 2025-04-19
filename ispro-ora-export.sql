set COLSEP ';'
set HEADSEP OFF
SET UNDERLINE OFF
SET LINESIZE 32000
SET NEWPAGE NONE
SET PAGESIZE 50000
SET TRIMSPOOL ON
SET HEADING ON

SET FEEDBACK OFF
SET ECHO OFF
--SET TERMOUT OFF
SET VERIFY OFF

--set TIMEOUT OFF
ALTER SESSION SET QUERY_TIMEOUT = 3000;  -- Timeout after 50 minutes

DEFINE schema_firm = dfirm001
DEFINE schema_sys = I711_SYS
DEFINE outfolder = 'C:\Users\sunti\Projects\ispro-ora-export\csv\'

DEFINE filename = 'usertorole.csv'
SPOOL &outfolder.&filename
SELECT 	USER_RCD "ID",
	USERROLE_RCD "roleID",
	USERROLE_FIRM "firmID",
	URLINK_FLG "flag",
	BOOKMARK "bookmark"
FROM &schema_sys..usertorole;
SPOOL off

DEFINE filename = 'gl_account.csv'
SPOOL &outfolder.&filename;
select
	sprpls_rcd "ID"
	,sprpls_sch "code"
	,sprpls_nm "name"
	,sprpls_sch || ' ' || sprpls_nm "description"
from &schema_firm..sprpls p1
where sprpls_rcd in (
	select distinct KpuPrkz_Sch
	from &schema_firm..kpuprk1
	where KpuPrkz_Sch <> 0
);
spool off;
