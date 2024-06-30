----------------------------------------------
--TempDB
----------------------------------------------

--List info about TempDB

Use tempdb;

SELECT * 
FROM sys.database_files
GO

----------------------------------------------
--Move Databases for another location
----------------------------------------------

Use complexDB;

ALTER DATABASE complexDB
MODIFY FILE 
( NAME = 'complexData', FILENAME = 'C:\DBs_Recover\dbs\otherLocation\complexData.mdf');
GO

ALTER DATABASE complexDB
MODIFY FILE 
( NAME = 'complexLog', FILENAME = 'C:\DBs_Recover\dbs\otherLocation\DB02Log.ldf');
GO

--we will can move other files, like .ndf

----------------------------------------------
--Put the database offline
----------------------------------------------
USE Master;
GO
ALTER DATABASE complexDB SET OFFLINE;
GO

----------------------------------------------
--Move the files for the destination via file explorer
----------------------------------------------

----------------------------------------------
--Put the database offline
----------------------------------------------
USE Master;
GO
ALTER DATABASE complexDB SET ONLINE;
GO








