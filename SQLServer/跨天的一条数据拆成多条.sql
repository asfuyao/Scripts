--开始时间
DECLARE @beginDT DATETIME = '2019-05-07 08:58:00.000';
--结束时间
DECLARE @endDT DATETIME = '2019-05-07 09:08:00.000';

SELECT t.d,
       CASE
         WHEN d = CONVERT(DATE, @beginDT) THEN CASE
                                                 WHEN d = CONVERT(DATE, @endDT) THEN DATEDIFF(MINUTE, @beginDT, @endDT)
                                               ELSE DATEDIFF(MINUTE, @beginDT, DATEADD(DAY, 1, d))
                                               END
         WHEN d > CONVERT(DATE, @beginDT)
          AND d < CONVERT(DATE, @endDT) THEN 24 * 60
         WHEN d = CONVERT(DATE, @endDT) THEN
           DATEDIFF(MINUTE, CONVERT(DATETIME, CONVERT(NVARCHAR(10), d, 120) + ' 00:00:00'), @endDT)
       ELSE 0
       END h
FROM   ( SELECT CONVERT(NVARCHAR(10), DATEADD(DAY, number, @beginDT), 120) d
         FROM   master..spt_values
         WHERE  type = 'p'
           AND  number <= DATEDIFF(DAY, @beginDT, @endDT)) t;
