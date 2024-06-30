

DECLARE @varcharColumn NVARCHAR(MAX)
DECLARE @tableName NVARCHAR(MAX)
DECLARE @condition NVARCHAR(MAX)

SET @varcharColumn='tbt.JOBNAME';
SET @tableName='PRP.prp.TBTCO AS tbt WITH (NOLOCK)
Inner join PRP.prp.TBTCS as ts with (nolock) on tbt.JOBNAME=ts.JOBNAME'
SET @condition='(tbt.STATUS =''A'' OR  (cast(tbt.ENDTIME as int)- cast(tbt.STRTTIME as int)) <= 2 and tbt.STATUS<>''R'' and tbt.STATUS<>''S'') 
AND tbt.JOBNAME IN (''ZPCE_TM + AJUSTE CONTABILÍSTICO'' ,''ZPCE_TNE'' ,''ZPROCESS_CTT_UNCOLLECTED'' ,''ZPCE_PROCESS_RPF'' ,''ZCBO_RT_DISCOUNTS'' ,''ZPCE_PUSHTRANSACTIONS2'' ,''ZSCE_PUSHTRANSACTIONS_FOREIGN'' ,''ZSCE_PUSHTRANSACTIONS_LPNCH'' ,''ZSCE_PUSHTRANSACTIONS'' )
AND tbt.SDLSTRTDT>=CONVERT(varchar(14), DATEADD(DAY, -1, GETDATE()), 112) 
AND tbt.SDLSTRTDT < CONVERT(varchar(14), DATEADD(DAY, 0, GETDATE()), 112) and ts.SDLSTRTDT=CONVERT(varchar(14), DATEADD(DAY, 0, GETDATE()), 112);'


DECLARE @sqlQuery NVARCHAR(MAX);
DECLARE @result VARCHAR(MAX);

-- Set the SQL query variable
SET @sqlQuery = 'SELECT @result = COALESCE(@result + '', '', '''') + ' + @varcharColumn + ' FROM ' + @tableName;

-- Add the condition if it is provided
IF @condition IS NOT NULL
SET @sqlQuery = @sqlQuery + ' WHERE ' + @condition;

-- Execute the dynamic SQL query and store the result in @result
EXEC sp_executesql @sqlQuery, N'@result VARCHAR(MAX) OUTPUT', @result OUTPUT;

-- Now @result contains the concatenated result of the dynamic SQL query

-- Use an IF statement to conditionally return a result
IF @result IS NOT NULL
   BEGIN
 -- Code to be executed if the condition is true
     Select @result as Result;
  END
   ELSE
   BEGIN
     -- Code to be executed if the condition is false
      Select 'OK' as Result;
 END;



