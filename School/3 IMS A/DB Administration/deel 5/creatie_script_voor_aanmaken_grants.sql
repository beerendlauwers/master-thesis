set head off
set feed off
set lines 999
set pages 9999
spool c:\script_voor_aanmaken_grants.sql

select '-- Alle privileges voor BELEID updaten' from dual;

SELECT 'GRANT SELECT ON ' || owner || '.' || table_name || ' TO BELEID;' VELDNAAM
FROM (select table_name, owner from sys.all_tables where owner= 'INFO');

SELECT 'GRANT INSERT ON ' || owner || '.' || table_name || ' TO BELEID;' VELDNAAM
FROM (select table_name, owner from sys.all_tables where owner= 'INFO');

SELECT 'GRANT UPDATE ON ' || owner || '.' || table_name || ' TO BELEID;' VELDNAAM
FROM (select table_name, owner from sys.all_tables where owner= 'INFO');

SELECT 'GRANT DELETE ON ' || owner || '.' || table_name || ' TO BELEID;' VELDNAAM
FROM (select table_name, owner from sys.all_tables where owner= 'INFO');

select '-- Alle privileges voor FINANCIEEL updaten' from dual;

SELECT 'GRANT SELECT ON ' || owner || '.' || table_name || ' TO FINANCIEEL;' VELDNAAM
FROM (select table_name, owner from sys.all_tables where owner= 'FINA');

SELECT 'GRANT INSERT ON ' || owner || '.' || table_name || ' TO FINANCIEEL;' VELDNAAM
FROM (select table_name, owner from sys.all_tables where owner= 'FINA');

SELECT 'GRANT UPDATE ON ' || owner || '.' || table_name || ' TO FINANCIEEL;' VELDNAAM
FROM (select table_name, owner from sys.all_tables where owner= 'FINA');

SELECT 'GRANT DELETE ON ' || owner || '.' || table_name || ' TO FINANCIEEL;' VELDNAAM
FROM (select table_name, owner from sys.all_tables where owner= 'FINA');

select 'exit' from dual;
spool off;
exit
