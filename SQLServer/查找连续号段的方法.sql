--���������ŶΣ�����ʾÿ���Ŷε���ʼ�źͽ�����
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
select gid ���,min(id) ��ʼID,max(id) ����ID,count(id) ����ID����,sum(num) ��ϼ�
from temp_table
group by gid

drop table #temp;