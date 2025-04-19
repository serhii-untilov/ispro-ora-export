-- назва схеми підприємства, замініть dfirm001 на ім`я вашої схеми
DEFINE schema_firm = dfirm001
-- назва схеми системних таблиць ІС-Про, замініть I711_SYS на ім`я вашої схеми
DEFINE schema_sys = I711_SYS
-- каталог для створення csv-файлів, замініть на ваш каталог
DEFINE outfolder = 'C:\Users\sunti\Projects\ispro-ora-export\csv\'

SET TERMOUT OFF
SET VERIFY OFF

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

--set TIMEOUT OFF
ALTER SESSION SET QUERY_TIMEOUT = 3000;  -- Timeout after 50 minutes

-- Тест
DEFINE filename = 'usertorole.csv'
SPOOL &outfolder.&filename
SELECT 	USER_RCD "ID",
	USERROLE_RCD "roleID",
	USERROLE_FIRM "firmID",
	URLINK_FLG "flag",
	BOOKMARK "bookmark"
FROM &schema_sys..usertorole;
SPOOL off

-- Балансові рахунки (gl_account)
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
SPOOL OFF;

-- Працівники (hr_employee)
DEFINE filename = 'hr_employee.csv'
DEFINE sysste_cd = '1'
SPOOL &outfolder.&sysste_cd..&filename;
with ste1 as (select max(sysste_rcd) sysste_rcd from /*FIRM_SCHEMA*/&schema_firm..sysste where sysste_cd = /*SYSSTE_CD*/&sysste_cd)
select
	cast(x1.kpu_rcd as varchar(11)) "ID"
/*
	,fnKdrSegregateFio(c1.kpu_fio, 1) lastName
	,fnKdrSegregateFio(c1.kpu_fio, 2) firstName
	,fnKdrSegregateFio(c1.kpu_fio, 3) middleName
	,fnKdrSegregateFio(c1.kpu_fio, 1) + ' ' + SUBSTR(fnKdrSegregateFio(c1.kpu_fio, 2), 0, 1) + '. ' + SUBSTR(fnKdrSegregateFio(c1.kpu_fio, 3), 0, 1) + '. ' shortFIO
*/
	,REPLACE(REPLACE(c1.kpu_fio, CHR(13), ''), CHR(10), '') "fullFIO"
	,REPLACE(REPLACE(c1.kpu_fioR, CHR(13), ''), CHR(10), '') "genName"
	,REPLACE(REPLACE(c1.kpu_fioD, CHR(13), ''), CHR(10), '') "datName"
	,REPLACE(REPLACE(c1.kpu_fioV, CHR(13), ''), CHR(10), '') "accusativeName"
	,REPLACE(REPLACE(c1.kpu_fio, CHR(13), ''), CHR(10), '') "insName"
	,cast(x1.kpu_tn as varCHaR(10)) "tabNum"
	,'NEW' "state"
	,case when c1.kpu_cdpol = 1 then 'W' when c1.kpu_cdpol = 2 then 'M' else null end "sexType"
	,cast(cast(c1.kpu_dtroj as date) as varCHaR(10)) "birthDate"
	,c1.kpu_cdnlp "taxCode"
	,Kpu_TelM "phoneMobile"
	,Kpu_TelS "phoneWorking"
	,Kpu_Tel "phoneHome"
	,Kpu_EMail "email"
	,c1.kpu_fio "description"
	,c1. kpu_fio "locName"
	,cast(EXTRACT(DAY FROM c1.kpu_dtroj) as varCHaR(10)) "dayBirthDate"
	,cast(EXTRACT(MONTH FROM c1.kpu_dtroj) as varCHaR(10)) "monthBirthDate"
	,cast(EXTRACT(YEAR FROM c1.kpu_dtroj) as varCHaR(10)) "yearBirthDate"
from &schema_firm..kpux x1
inner join &schema_firm..KPUC1 c1 on c1.Kpu_Rcd = x1.kpu_rcd
inner join &schema_firm..KPUK1 k1 on k1.Kpu_Rcd = x1.kpu_rcd
inner join ste1 on ste1.sysste_rcd = c1.kpuc_se
where x1.kpu_tn < 4000000000;
--	and { fn MOD( { fn TRUNCATE( Kpu_Flg / 64, 0 ) }, 2 ) } = 0
--	and (Kpu_Flg & 2) = 0	--
--	and x1.kpu_tnosn = 0
SPOOL OFF;

----------------------------------------------
exit;