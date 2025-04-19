set COLSEP ';';
set HEADSEP OFF;
--set feedback off;
--set timeout off;
SET UNDERLINE OFF
SET LINESIZE 32000
SET NEWPAGE NONE
SET PAGESIZE 50000
SET TRIMSPOOL ON
SET HEADING ON

DEFINE outfolder = 'C:\Users\sunti\Projects\ispro-ora-export\csv\'

DEFINE filename = 'usertorole.csv'
SPOOL &outfolder.&filename
SELECT 	USER_RCD "ID",
	USERROLE_RCD "roleID",
	USERROLE_FIRM "firmID",
	URLINK_FLG "flag",
	BOOKMARK "bookmark"
FROM I711_SYS.usertorole;
SPOOL off

DEFINE filename = 'gl_account.csv'
SPOOL &outfolder.&filename;
select
	sprpls_rcd "ID"
	,sprpls_sch "code"
	,sprpls_nm "name"
	,sprpls_sch || ' ' || sprpls_nm "description"
from dfirm001.sprpls p1
where sprpls_rcd in (
	select distinct KpuPrkz_Sch
	from dfirm001.kpuprk1
	where KpuPrkz_Sch <> 0
);
spool off;
