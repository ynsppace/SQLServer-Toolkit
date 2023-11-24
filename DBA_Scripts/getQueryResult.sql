USE [M5Database]
GO
/****** Object:  StoredProcedure [dbo].[GetQueryResult]    Script Date: 16/11/2023 14:54:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetQueryResult]
    @varcharColumn NVARCHAR(MAX),
    @tableName NVARCHAR(MAX),
    @condition NVARCHAR(MAX) = NULL
AS
BEGIN
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
END;
