/******************************************************************************
  
  *Copyright(C)
  *FileName:     p_ArchiveTableData
  *Author:
  *Version:      1.00
  *Date:         2019-05-20
  *Description:  �����±�鵵����
  *Others:
  *Function List:
  *History:

*******************************************************************************/
ALTER PROCEDURE [dbo].[p_ArchiveTableData]
  @TableNameBase sysname, --����
  @ArchiveDate   DATE --�鵵���ڣ��鵵�趨����֮ǰ������
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
  DECLARE @i_column NVARCHAR(MAX) = N''; --�������ϣ����ŷָ�
  DECLARE @d_sqlstr NVARCHAR(MAX) = N'';
  DECLARE @SaveDataMinMonths INT = 1;
  --���ݹ鵵�����ٱ��������µ�����

  --����������ر���
  DECLARE @ErrorCode INT; --�������
  DECLARE @ErrorSeverity INT; --���󼶱�
  DECLARE @ErrorState INT; --����״̬
  DECLARE @ErrorText NVARCHAR(500);

  --��������

  --��ȡ�����ID
  SELECT @object_id = o.[object_id]
  FROM   sys.objects o WITH( NOWAIT )
  JOIN   sys.schemas s WITH( NOWAIT )ON o.[schema_id] = s.[schema_id]
  WHERE  s.name + '.' + o.name = 'dbo.' + @TableNameBase
    AND  o.[type] = 'U'
    AND  o.is_ms_shipped = 0;

  SELECT @MaxDateTime = MAX(createdatetime), @MinDateTime = DATEADD(MONTH, @SaveDataMinMonths, MIN(createdatetime))
  FROM   dbo.qcmescelldata
  WHERE  createdatetime > @ArchiveDate;

  --��������
  --SELECT @MinDateTime = '2017-02-01', @MaxDateTime = '2017-12-30';
  SELECT @DiffMonth = DATEDIFF(MONTH, @MinDateTime, @MaxDateTime);

  SELECT @MinDateTime, @MaxDateTime, @DiffMonth;

  BEGIN TRY
    --��ʼ����
    BEGIN TRAN;

    WHILE( @DiffMonth >= 0 )
    BEGIN
      SET @TableName = @TableNameBase
                       + REPLACE(CONVERT(CHAR(7), DATEADD(MONTH, @DiffMonth, @MinDateTime), 120), '-', '');

      --�ж��Ƿ���ڶ�Ӧ���±����û�о��ѻ�����Ϊ�ο�������ṹ���½ṹ�����������������Ĭ��ֵ
      IF NOT EXISTS ( SELECT *
                      FROM   sys.sysobjects
                      WHERE  name = @TableName
                        AND  xtype = 'U' )
      BEGIN
        EXEC dbo.p_GenerateTableStructure @TableNameBase, @TableName, 0, 0, 0, @t_sqlstr OUTPUT;

        PRINT ( @t_sqlstr );
      END;

      --�������ݹ鵵���
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

      --����ɾ���鵵�����ݵ����
      SET @d_sqlstr = N' DELETE FROM dbo.' + @TableNameBase;
      SET @d_sqlstr = @d_sqlstr + N' WHERE createdatetime>''' + CONVERT(NVARCHAR(20), @MinDateTime, 120)
                      + N''' and CONVERT(NCHAR(7),createdatetime,120)='''
                      + CONVERT(NCHAR(7), DATEADD(MONTH, @DiffMonth, @MinDateTime), 120) + N'''' + CHAR(13);

      PRINT @d_sqlstr;

      SET @DiffMonth = @DiffMonth - 1;
    END;

    --�ύ����
    COMMIT TRAN;

    --����0
    RETURN 0;
  END TRY
  BEGIN CATCH
    --�ع�����
    ROLLBACK TRAN;

    SET @ErrorCode = ERROR_NUMBER();
    SET @ErrorSeverity = ERROR_SEVERITY();
    SET @ErrorState = ERROR_STATE();
    SET @ErrorText = ERROR_MESSAGE();

    --�׳�����
    RAISERROR(@ErrorText, @ErrorSeverity, @ErrorState);

    RETURN @ErrorCode;
  END CATCH;
END;