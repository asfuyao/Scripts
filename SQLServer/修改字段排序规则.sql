USE [master];
GO

ALTER DATABASE 数据库名 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

USE 数据库名;
GO

DECLARE @Collate NVARCHAR(50) = N'Latin1_General_CI_AS'; --排序规则名
DECLARE @table NVARCHAR(128); --循环Item表名
DECLARE @column NVARCHAR(128); --循环Item字段名
DECLARE @type NVARCHAR(128); --对应字段的类型，char、nchar、varchar、nvarchar等
DECLARE @typeLenght NVARCHAR(128); --对应类型的长度，nchar、nvarchar需要将数值除于2
DECLARE @sql NVARCHAR(MAX); --要拼接执行的sql语句

SET ROWCOUNT 0;

SELECT     NULL mykey, c.name, t.name AS [Table], c.name AS [Column], c.collation_name AS [Collation],
           TYPE_NAME(c.system_type_id) AS [TypeName], c.max_length AS [TypeLength]
INTO       #temp
FROM       sys.columns c
RIGHT JOIN sys.tables t ON c.object_id = t.object_id
WHERE      c.collation_name IS NOT NULL;

--      AND t.name = 'SysLog'
--      AND TYPE_NAME(c.system_type_id) = 'nvarchar';
SET ROWCOUNT 1;

UPDATE #temp
SET    mykey = 1;

WHILE @@ROWCOUNT > 0
BEGIN
  SET ROWCOUNT 0;

  --每次查询第一条记录并赋值到对应变量中
  SELECT @table = [Table], @column = [Column], @type = TypeName, @typeLenght = TypeLength
  FROM   #temp
  WHERE  mykey = 1;

  --nchar、nvarchar需要将数值除于2
  IF CONVERT(INT, @typeLenght) > 0
 AND ( @type = 'nvarchar'
    OR @type = 'nchar' )
  BEGIN
    SET @typeLenght = CONVERT(NVARCHAR(128), CONVERT(INT, @typeLenght) / 2);
  END;

  IF @typeLenght = '-1'
  BEGIN
    SET @typeLenght = N'max';
  END;

  --拼接sql，注意表名、字段名要带[]，避免Group等关键字
  SET @sql = N' ALTER TABLE [' + @table + N'] ALTER COLUMN [' + @column + N'] ' + @type + N'(' + @typeLenght
             + N') COLLATE ' + @Collate;

  --Try执行
  BEGIN TRY
    EXEC( @sql );
  END TRY
  --Catch查询异常结果
  BEGIN CATCH
    SELECT @sql AS [ASL], ERROR_MESSAGE() AS msg;
  END CATCH;

  DELETE #temp
  WHERE  mykey = 1;

  SET ROWCOUNT 1;

  UPDATE #temp
  SET    mykey = 1;
END;

SET ROWCOUNT 0;

DROP TABLE #temp;

USE [master];
GO

ALTER DATABASE 数据库名 SET MULTI_USER WITH ROLLBACK IMMEDIATE;
GO