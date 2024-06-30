DECLARE @varcharColumn NVARCHAR(MAX)
DECLARE @tableName NVARCHAR(MAX)
DECLARE @condition NVARCHAR(MAX)

SET @varcharColumn='inb.FILTP';
SET @tableName='PRP.prp.ZCBO_INBFLS as inb with (nolock)'
SET @condition=' inb.MANDT = ''100''
    AND inb.FILTP = ''AEPE''
    AND inb.ORIGIN_ID = ''SIBS''
    AND inb.DT_CR >= CONVERT(VARCHAR(14), DATEADD(DAY, -1, GETDATE()), 112)
    AND inb.DT_CR < CONVERT(VARCHAR(14), DATEADD(DAY, 0, GETDATE()), 112)
GROUP BY
    inb.FILTP,
    (CASE WHEN SUBSTRING(inb.PATH, 32, 3) IN (''API'', ''LCP'') THEN ''EQUI'' ELSE SUBSTRING(inb.PATH, 32, 3) END)
HAVING
    (
        (CASE WHEN SUBSTRING(inb.PATH, 32, 3) IN (''API'', ''LCP'') THEN ''EQUI'' ELSE SUBSTRING(inb.PATH, 32, 3) END) = ''AEN''
        AND COUNT(inb.FILN) < 5
    )
    OR (
        (CASE WHEN SUBSTRING(inb.PATH, 32, 3) IN (''API'', ''LCP'') THEN ''EQUI'' ELSE SUBSTRING(inb.PATH, 32, 3) END) = ''EQUI''
        AND COUNT(inb.FILN) <10
    )
	 OR (
        (CASE WHEN SUBSTRING(inb.PATH, 32, 3) IN (''API'', ''LCP'') THEN ''EQUI'' ELSE SUBSTRING(inb.PATH, 32, 3) END) = ''LGL''
        AND COUNT(inb.FILN) <5
    )'


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




