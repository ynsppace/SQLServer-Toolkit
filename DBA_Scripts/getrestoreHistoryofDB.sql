##Retorna um historico de restores realizados numa determinada instancia

Select database_name as Source_database, 
		destination_database_name,
		restore_date,
		physical_device_name as Backup_file_used_to_restore,
		bs.user_name,
		bs.machine_name
From msdb.dbo.restorehistory rh inner join msdb.dbo.backupset bs 
			on rh.backup_set_id=bs.backup_set_id
			inner join msdb.dbo.backupmediafamily bmf 
			on bs.media_set_id =bmf.media_set_id
ORDER BY [rh].[restore_date] DESC