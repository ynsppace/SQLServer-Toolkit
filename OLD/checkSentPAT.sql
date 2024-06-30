DECLARE @varcharColumn NVARCHAR(MAX)
DECLARE @tableName NVARCHAR(MAX)
DECLARE @condition NVARCHAR(MAX)

SET @varcharColumn='outb.FILTP';
SET @tableName='PRP.prp.ZCBO_OUTBFLS as outb with (nolock)'
SET @condition='outb.MANDT=''100'' AND outb.FILTP=''PAT'' AND outb.DT_CR >= CONVERT(varchar(14), DATEADD(DAY, -1, GETDATE()), 112) AND outb.DT_CR <= CONVERT(varchar(14), DATEADD(DAY, 0, GETDATE()), 112)
GROUP BY outb.FILTP
Having COUNT(outb.FILE_ID)<9'


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
