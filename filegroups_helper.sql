----------------------------------------------
--Filegroups
----------------------------------------------

--Delete a database if not exists

DROP DATABASE IF EXISTS complexDB;
GO

--Database with 2 filegroups

CREATE DATABASE complexDB
 ON  PRIMARY --filegroup inicial (pré-definido)
( NAME = N'complexDB', FILENAME = N'C:\DBs_Recover\dbs\complexDB.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB ), 
 FILEGROUP OtherFilegroup --segundo filegroup
( NAME = N'OtherDBFile', FILENAME = N'C:\DBs_Recover\dbs\OtherDBFile.ndf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON --ficheiro log
( NAME = N'complexDB_log', FILENAME = N'C:\DBs_Recover\dbs\complexDB_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO

--Add a filegroup a existing database
USE complexDB;
GO
ALTER DATABASE complexDB  ADD FILEGROUP test
GO

--List All Filegroups Available in 1 database
Use complexDB;
SELECT * FROM  sys.filegroups

--Put a filegroup as default
Use complexDB;
ALTER DATABASE complexDB  MODIFY FILEGROUP OtherFilegroup DEFAULT
GO

--Put a filegroup in read only
Use complexDB;
ALTER DATABASE complexDB MODIFY FILEGROUP [PRIMARY] READ_ONLY;
GO