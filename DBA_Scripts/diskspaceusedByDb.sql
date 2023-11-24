select 
	 ISNULL(t.DSname, 'Log') as DataSpaceName
	,cast(sum(t.CurrentSizeMB/1024) as numeric(36,2)) as CurrentSizeGB
	,cast(sum(t.FreeSpaceMB/1024) as numeric(36,2)) as FreeSpaceGB
	,cast(sum(t.UsedSpaceMB/1024) as numeric(36,2)) as UsedSpaceGB
From
	(
		SELECT DB_NAME() AS DbName,
		ds.name as DSname,
		dbf.name AS FileName,
		dbf.size/128.0 AS CurrentSizeMB, 
		dbf.size/128.0 - CAST(FILEPROPERTY(dbf.name, 'SpaceUsed') AS INT)/128.0 AS FreeSpaceMB,
		CAST(FILEPROPERTY(dbf.name, 'SpaceUsed') AS INT)/128.0 AS UsedSpaceMB
		FROM sys.database_files as dbf
			left join sys.data_spaces as ds on  dbf.data_space_id = ds.data_space_id
	) as t
group by t.DSname
order by DSname;