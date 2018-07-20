if object_id('tempdb..#tempTable') is not null
begin
  truncate table #tempTable;
  drop table #tempTable;
end;
create table #tempTable
(
  data int constraint dataKey001 primary key nonclustered(data asc)
);

declare @i int;
set @i=0;
while(@i<1000)
begin
  insert into #tempTable(data)
  values(floor(rand(abs(checksum(newid())))* 1000));
  set @i=@i+1;
end;

select   row_number() over (order by data) as rownum, *
from     #tempTable
order by data offset 0 rows fetch next 5 rows only;


with
temp_a as
(
  select row_number() over (order by data) as rownum, * from #tempTable
)
select * from temp_a where temp_a.rownum>=0 and temp_a.rownum<=5;