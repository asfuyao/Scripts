/******************************************************************************
  
  *Copyright(C)
  *FileName:     p_ProcedureName
  *Author:       
  *Version:      1.00
  *Date:         2018-12-15
  *Description:  �洢��������
  *Others:
  *Function List: 
  *History: 

*******************************************************************************/

CREATE PROCEDURE [dbo].[p_ProcedureName]
  @parameter1 INT,
  @parameter2 NVARCHAR(50)
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @ErrorCode INT;

  BEGIN TRANSACTION;

  --����ɾ���ı����ݵ�����
  
  SET @ErrorCode = @@ERROR;

  IF( @ErrorCode = 0 )
  BEGIN
    COMMIT TRANSACTION;
    
    GOTO TheEnd;
  END;
  ELSE
  BEGIN
    ROLLBACK TRANSACTION;

    GOTO ErrorProcess;
  END;

  ErrorProcess:
  --PRINT @ErrorCode
  RETURN @ErrorCode;

  TheEnd:
  --PRINT 0
  RETURN 0;
END;