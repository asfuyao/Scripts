IF OBJECT_ID(N'dbo.f_UTC2LocalDatetime', N'FN') IS NOT NULL
  DROP FUNCTION dbo.f_UTC2LocalDatetime;
GO

/******************************************************************************

  *Copyright(C)
  *FileName:     f_UTC2LocalDatetime
  *Author:       Winds
  *Version:      1.00
  *Date:         2019-09-10
  *Description:  转换UTC时间为本地时间
  *Others:
  *Function List:
  *History:

*******************************************************************************/

CREATE FUNCTION f_UTC2LocalDatetime
(
  @UTCDateTime DATETIMEOFFSET(7)
)
RETURNS DATETIME
BEGIN
  DECLARE @LocalDateTime DATETIME;
  DECLARE @OffSet INT;

  SET @LocalDateTime = CONVERT(DATETIME, @UTCDateTime, 1);
  SET @OffSet = DATEDIFF(hh, GETUTCDATE(), GETDATE());

  RETURN DATEADD(HOUR, @OffSet, @LocalDateTime);
END;
