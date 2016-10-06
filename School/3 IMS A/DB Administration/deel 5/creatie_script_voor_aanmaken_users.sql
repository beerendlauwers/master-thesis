set head off
set feed off
set lines 999
set pages 9999
spool c:\script_voor_aanmaken_users.sql


select 'CREATE USER '|| USER_NAAM || ' PROFILE DEFAULT IDENTIFIED BY '|| PASWOORD ||' DEFAULT TABLESPACE '|| DEFAULT_TS ||
' TEMPORARY TABLESPACE '|| TEMP_TS || ' ACCOUNT UNLOCK;' VELDJE
from DBA_A_2.nieuwe_users;

select 'GRANT ' || ROL || ' TO '|| USER_NAAM || ';' VELDNAAMPJE from DBA_A_2.nieuwe_users;

select 'exit' from dual;
spool off;
exit
