DECLARE @varcharColumn NVARCHAR(MAX)
DECLARE @tableName NVARCHAR(MAX)
DECLARE @condition NVARCHAR(MAX)

SET @varcharColumn='inb.FILE_ID';
SET @tableName='PRP.prp.ZCBO_INBFLS as inb with (nolock)'
SET @condition='MANDT=''100'' and inb.FILTP=''INC'' and inb.ORIGIN_ID=''VVP'' and inb.FIST =''6'' 
and inb.DT_CR >= (SELECT TOP 1 inb2.DT_PR
FROM PRP.prp.ZCBO_INBFLS as inb2 with (nolock)
WHERE inb2.MANDT=''100'' AND inb2.FILTP=''TP'' AND inb2.ORIGIN_ID=''VVP'' AND inb2.FIST=''6''
ORDER BY inb2.DT_PR DESC)'


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