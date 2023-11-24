/*==================================================================================
Informacoes sobre Instancia SQL, Bancos de Dados e objetos, via Script SQL
==================================================================================*/

SELECT SERVERPROPERTY('productversion') VersaoSQL, 
       SERVERPROPERTY ('edition') Edicao,
	   SERVERPROPERTY('InstanceDefaultDataPath')LOCALIZACAO_DADOS,
	   SERVERPROPERTY('InstanceDefaultLogPath')LOCALIZACAO_LOGS,
	   SERVERPROPERTY('ServerName')SERVERNAME,
	   SERVERPROPERTY('InstanceName')INSTANCIA,
	   SERVERPROPERTY('IsHadrEnabled')HADR_Habilitado
	
--Verificando informações do servidor
Select @@version 
-- Verificar ultimas versões e correções CUs, https://docs.microsoft.com/en-us/sql/database-engine/install-windows/latest-updates-for-microsoft-sql-server?view=sql-server-ver15

-- Retorna o nome do idioma que está sendo usado atualmente.
SELECT @@LANGUAGE

-- Retorna o nome do servidor que está executando o SQL Server.
SELECT @@SERVERNAME

--Retorna a ID de sessão do processo de usuário atual.
SELECT @@SPID
-- kill para matar processos.

-- Retorna informacoes basica sobre os bancos de dados
select name, crdate,filename from sysdatabases 

-- Retorna mais informacoes sobre os bancos de dados
SELECT name, create_date, recovery_model_desc, 
compatibility_level, collation_name, is_read_committed_snapshot_on,state_desc 
FROM sys.databases  

-- Retorna alertas configurados. 
use msdb
go
select name, severity, enabled from sysalerts

-- Retorna informações sobre itens do servidor e banco de dados que estão sendo auditados
select audit_action_name from sys.server_audit_specification_details 
select distinct audit_action_name from sys.database_audit_specification_details

-- Retorna os parametros da instancia sql server
-- https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/server-configuration-options-sql-server?view=sql-server-ver15
sp_configure

-- Como alterar um parametro via SCRIPT SQL
EXEC sp_configure 'backup compression default', '1';
RECONFIGURE;

EXEC sp_configure 'backup compression default', '0';
RECONFIGURE;

-- Para verificar todas as opções do sp_configure
USE master;
GO
EXEC sp_configure 'show advanced option', '1'; --Enable advanced options
RECONFIGURE;
EXEC sp_configure --Show all the options
EXEC sp_configure 'show advanced option', '0'; --Always disable advanced options
RECONFIGURE;

-- Retorna dados de tabelas e views do banco de dados CLIENTES
use CLIENTES
go
SELECT 
    DISTINCT NAME,* 
FROM SYS.OBJECTS
WHERE TYPE IN ('U','V')
-- AND NAME= 'MYNAME'
-- U = User Table, V = View

-- Uma outra forma de retornar dados de tabelas e views
SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Retornar dados especificos de views, inclusive o proprio script da view
SELECT * FROM INFORMATION_SCHEMA.VIEWS

--Informação acerca os files das base de dados presentes na instancia
SELECT 
    [TYPE] = A.TYPE_DESC
    ,[FILE_Name] = A.name
    ,[FILEGROUP_NAME] = fg.name
    ,[File_Location] = A.PHYSICAL_NAME
    ,[FILESIZE_MB] = CONVERT(DECIMAL(10,2),A.SIZE/128.0)
    ,[USEDSPACE_MB] = CONVERT(DECIMAL(10,2),A.SIZE/128.0 - ((SIZE/128.0) - CAST(FILEPROPERTY(A.NAME, 'SPACEUSED') AS INT)/128.0))
    ,[FREESPACE_MB] = CONVERT(DECIMAL(10,2),A.SIZE/128.0 - CAST(FILEPROPERTY(A.NAME, 'SPACEUSED') AS INT)/128.0)
    ,[FREESPACE_%] = CONVERT(DECIMAL(10,2),((A.SIZE/128.0 - CAST(FILEPROPERTY(A.NAME, 'SPACEUSED') AS INT)/128.0)/(A.SIZE/128.0))*100)
    ,[AutoGrow] = 'By ' + CASE is_percent_growth WHEN 0 THEN CAST(growth/128 AS VARCHAR(10)) + ' MB -' 
        WHEN 1 THEN CAST(growth AS VARCHAR(10)) + '% -' ELSE '' END 
        + CASE max_size WHEN 0 THEN 'DISABLED' WHEN -1 THEN ' Unrestricted' 
            ELSE ' Restricted to ' + CAST(max_size/(128*1024) AS VARCHAR(10)) + ' GB' END 
        + CASE is_percent_growth WHEN 1 THEN ' [autogrowth by percent, BAD setting!]' ELSE '' END
FROM sys.database_files A LEFT JOIN sys.filegroups fg ON A.data_space_id = fg.data_space_id 
order by A.TYPE desc, A.NAME;


