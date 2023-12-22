# Zabbix-Template-MSSQL

Microsoft SQL Server 2012 monitoring. For English and Russian version. With LLD. Сhecked in 2.4.8 and 3.0.0
Based on Anton Golubkin's "Template MS SQL 2012" at 
https://share.zabbix.com/databases/microsoft-sql-server/template-ms-sql-2012

### Install

To enable the powershell scripts in the server you have to configure the scripts as UserParams in zabbix_agent2.conf

    UserParameter=mssql.db.discovery,powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Program Files\Zabbix Agent 2\scripts\mssql_basename.ps1"
    UserParameter=mssql.version,powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Program Files\Zabbix Agent 2\scripts\mssql_version.ps1"

The preferred location for the scripts is in the folder "C:\Program Files\Zabbix Agent 2\scripts\", update accordinly if you change it


### Changelog
* Updated install instructions
* LLD : now you can skip some databases from LLD, check $DB_to_skip in SQLBaseName_To_Zabbix.ps1 
* Add "{HOST.NAME}" to trigger name
* Screen with "Top 10 SQL Server Counters for Monitoring SQL Server Performance" (http://www.databasejournal.com/features/mssql/article.php/3932406/Top-10-SQL-Server-Counters-for-Monitoring-SQL-Server-Performance.htm)
* Template for Russian MSSQL server
* Howto add Express server



