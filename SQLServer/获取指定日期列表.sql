declare @StartDate datetime ='2018-03-01'
declare @Days int =30
select convert(char(10), dateadd(dd, number, @StartDate), 120) as dd
from   master.dbo.spt_values as spt
where  type='p'
  and number<=@Days;