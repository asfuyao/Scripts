USE [master]
GO
ALTER DATABASE [TZToolDB] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

DECLARE @table NVARCHAR(128); --ѭ��Item����
DECLARE @column NVARCHAR(128); --ѭ��Item�ֶ���
DECLARE @type NVARCHAR(128); --��Ӧ�ֶε����ͣ�char��nchar��varchar��nvarchar��
DECLARE @typeLenght NVARCHAR(128); --��Ӧ���͵ĳ��ȣ�nchar��nvarchar��Ҫ����ֵ����2
DECLARE @sql NVARCHAR(MAX); --Ҫƴ��ִ�е�sql���


SET ROWCOUNT 0;

SELECT NULL mykey,
       c.name,
       t.name AS [Table],
       c.name AS [Column],
       c.collation_name AS [Collation],
       TYPE_NAME(c.system_type_id) AS [TypeName],
       c.max_length AS [TypeLength]
INTO #temp
FROM sys.columns c
    RIGHT JOIN sys.tables t
        ON c.object_id = t.object_id
WHERE c.collation_name IS NOT NULL;
--      AND t.name = 'SysLog'
--      AND TYPE_NAME(c.system_type_id) = 'nvarchar';

SET ROWCOUNT 1;
UPDATE #temp
SET mykey = 1;

WHILE @@ROWCOUNT > 0
BEGIN
    SET ROWCOUNT 0;

    --ÿ�β�ѯ��һ����¼����ֵ����Ӧ������
    SELECT @table = [Table],
           @column = [Column],
           @type = TypeName,
           @typeLenght = TypeLength
    FROM #temp
    WHERE mykey = 1;

    --nchar��nvarchar��Ҫ����ֵ����2
    IF CONVERT(INT, @typeLenght) > 0
       AND
       (
           @type = 'nvarchar'
           OR @type = 'nchar'
       )
    BEGIN
        SET @typeLenght = CONVERT(NVARCHAR(128), CONVERT(INT, @typeLenght) / 2);
    END;

    IF @typeLenght = '-1'
    BEGIN
        SET @typeLenght = N'max';
    END;


    --ƴ��sql��ע��������ֶ���Ҫ��[]������Group�ȹؼ���
    SET @sql
        = N' ALTER TABLE [' + @table + N'] ALTER COLUMN [' + @column + N'] ' + @type + N'(' + @typeLenght
          + N') COLLATE Latin1_General_CI_AS';

    --Tryִ��
    BEGIN TRY
        EXEC (@sql);
    END TRY
    --Catch��ѯ�쳣���
    BEGIN CATCH
        SELECT @sql AS [ASL],
               ERROR_MESSAGE() AS msg;
    END CATCH;

    DELETE #temp
    WHERE mykey = 1;

    SET ROWCOUNT 1;

    UPDATE #temp
    SET mykey = 1;
END;

SET ROWCOUNT 0;

DROP TABLE #temp;


USE [master]
GO

ALTER DATABASE [TZToolDB] SET  multi_user WITH ROLLBACK IMMEDIATE
GO