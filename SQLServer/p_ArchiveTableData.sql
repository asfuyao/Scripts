/******************************************************************************
  
  *Copyright(C)
  *FileName:     p_ArchiveTableData
  *Author:
  *Version:      1.00
  *Date:         2019-05-20
  *Description:  创建月表归档数据
  *Others:
  *Function List:
  *History:

*******************************************************************************/
ALTER PROCEDURE [dbo].[p_ArchiveTableData]
  @TableNameBase sysname, --表名
  @ArchiveDate   DATE --归档日期，归档设定日期之前的数据
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @MaxDateTime DATETIME;
  DECLARE @MinDateTime DATETIME;
  DECLARE @DiffMonth INT = 0;
  DECLARE @TableName sysname;
  DECLARE @object_id INT;
  DECLARE @t_sqlstr NVARCHAR(MAX) = N'';
  DECLARE @i_sqlstr NVARCHAR(MAX) = N'';
  DECLARE @i_column NVARCHAR(MAX) = N''; --列名集合，逗号分隔
  DECLARE @d_sqlstr NVARCHAR(MAX) = N'';
  DECLARE @SaveDataMinMonths INT = 1;
  --数据归档后最少保留几个月的数据

  --声明错误相关变量
  DECLARE @ErrorCode INT; --错误代码
  DECLARE @ErrorSeverity INT; --错误级别
  DECLARE @ErrorState INT; --错误状态
  DECLARE @ErrorText NVARCHAR(500);

  --错误内容

  --获取表对象ID
  SELECT @object_id = o.[object_id]
  FROM   sys.objects o WITH( NOWAIT )
  JOIN   sys.schemas s WITH( NOWAIT )ON o.[schema_id] = s.[schema_id]
  WHERE  s.name + '.' + o.name = 'dbo.' + @TableNameBase
    AND  o.[type] = 'U'
    AND  o.is_ms_shipped = 0;

  SELECT @MaxDateTime = MAX(createdatetime), @MinDateTime = DATEADD(MONTH, @SaveDataMinMonths, MIN(createdatetime))
  FROM   dbo.qcmescelldata
  WHERE  createdatetime > @ArchiveDate;

  --测试数据
  --SELECT @MinDateTime = '2017-02-01', @MaxDateTime = '2017-12-30';
  SELECT @DiffMonth = DATEDIFF(MONTH, @MinDateTime, @MaxDateTime);

  SELECT @MinDateTime, @MaxDateTime, @DiffMonth;

  BEGIN TRY
    --开始事务
    BEGIN TRAN;

    WHILE( @DiffMonth >= 0 )
    BEGIN
      SET @TableName = @TableNameBase
                       + REPLACE(CONVERT(CHAR(7), DATEADD(MONTH, @DiffMonth, @MinDateTime), 120), '-', '');

      --判断是否存在对应的月表，如果没有就已基础表为参考创建表结构，新结构不设置自增、不添加默认值
      IF NOT EXISTS ( SELECT *
                      FROM   sys.sysobjects
                      WHERE  name = @TableName
                        AND  xtype = 'U' )
      BEGIN
        EXEC dbo.p_GenerateTableStructure @TableNameBase, @TableName, 0, 0, 0, @t_sqlstr OUTPUT;

        PRINT ( @t_sqlstr );
      END;

      --产生数据归档语句
      SET @i_sqlstr = N' INSERT INTO dbo.' + @TableName + N' (';
      SET @i_column = ( SELECT '' + name + ', '
                        FROM   sys.syscolumns
                        WHERE  id = @object_id
                        FOR XML PATH(''));
      SET @i_column = LEFT(@i_column, LEN(@i_column) - 1);
      SET @i_sqlstr = @i_sqlstr + @i_column + N')' + CHAR(13);
      SET @i_sqlstr = @i_sqlstr + N' SELECT ' + @i_column + N' FROM dbo.' + @TableNameBase + CHAR(13);
      SET @i_sqlstr = @i_sqlstr + N' WHERE createdatetime>''' + CONVERT(NVARCHAR(20), @MinDateTime, 120)
                      + N''' and CONVERT(NCHAR(7),createdatetime,120)='''
                      + CONVERT(NCHAR(7), DATEADD(MONTH, @DiffMonth, @MinDateTime), 120) + N'''' + CHAR(13);

      PRINT @i_sqlstr;

      --产生删除归档后数据的语句
      SET @d_sqlstr = N' DELETE FROM dbo.' + @TableNameBase;
      SET @d_sqlstr = @d_sqlstr + N' WHERE createdatetime>''' + CONVERT(NVARCHAR(20), @MinDateTime, 120)
                      + N''' and CONVERT(NCHAR(7),createdatetime,120)='''
                      + CONVERT(NCHAR(7), DATEADD(MONTH, @DiffMonth, @MinDateTime), 120) + N'''' + CHAR(13);

      PRINT @d_sqlstr;

      SET @DiffMonth = @DiffMonth - 1;
    END;

    --提交事务
    COMMIT TRAN;

    --返回0
    RETURN 0;
  END TRY
  BEGIN CATCH
    --回滚事务
    ROLLBACK TRAN;

    SET @ErrorCode = ERROR_NUMBER();
    SET @ErrorSeverity = ERROR_SEVERITY();
    SET @ErrorState = ERROR_STATE();
    SET @ErrorText = ERROR_MESSAGE();

    --抛出错误
    RAISERROR(@ErrorText, @ErrorSeverity, @ErrorState);

    RETURN @ErrorCode;
  END CATCH;
END;