SELECT t.d,
       CASE
         WHEN d = CONVERT(DATE, @beginDT) THEN DATEDIFF(MINUTE, @beginDT, DATEADD(DAY, 1, d))
         WHEN d > CONVERT(DATE, @beginDT)
          AND d < CONVERT(DATE, @endDT) THEN 24*60
         WHEN d = CONVERT(DATE, @endDT) THEN
           DATEDIFF(MINUTE, CONVERT(DATETIME, CONVERT(NVARCHAR(10), d, 120) + ' 00:00:00'), @endDT)
       ELSE 0
       END h
FROM   ( SELECT CONVERT(NVARCHAR(10), DATEADD(DAY, number, @beginDT), 120) d
         FROM   master..spt_values
         WHERE  type = 'p'
           AND  number <= DATEDIFF(DAY, @beginDT, @endDT) ) t;