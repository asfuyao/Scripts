--查找连续号段，并显示每个号段的起始号和结束号
create table #temp
(
  id int,
  num int
);

insert into #temp(id, num)
values(1, 33), (2, 344), (3, 25), (5, 222), (6, 229), (10, 238), (15, 88);

--select * from #temp
with
temp_table as
(
  select id-row_number() over (order by id) gid, id, num from #temp
)
select gid 组号,min(id) 起始ID,max(id) 结束ID,count(id) 组内ID数量,sum(num) 组合计
from temp_table
group by gid

drop table #temp;