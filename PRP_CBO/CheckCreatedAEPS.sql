DECLARE @varcharColumn NVARCHAR(MAX)
DECLARE @tableName NVARCHAR(MAX)
DECLARE @condition NVARCHAR(MAX)

SET @varcharColumn='out.FILTP';
SET @tableName='PRP.prp.ZCBO_OUTBFLS as out with (nolock)'
SET @condition='out.MANDT=''100'' and out.FILTP=''AEPS'' and out.DESTINY_ID=''SIBS'' and out.DT_CR>=CONVERT(varchar(14), DATEADD(DAY, -1, GETDATE()), 112 )and out.DT_CR< CONVERT(varchar(14), DATEADD(DAY, 0, GETDATE()), 112)
Group by out.FILTP, SUBSTRING(out.PATH,32,3 )
HAVING COUNT(out.FNAM) < 5'


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


