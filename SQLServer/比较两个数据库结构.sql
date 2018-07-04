create proc dbo.EAP_SP_CompareStructure
  @dbname1 varchar(250), --要比较的数据库名1 
  @dbname2 varchar(250)  --要比较的数据库名2 
as
create table #tb1
(
  表名1 nvarchar(250),
  字段名1 nvarchar(250),
  序号1 int,
  类型1 nvarchar(250),
  长度1 int,
  小数位数1 int
);
create table #tb2
(
  表名2 nvarchar(250),
  字段名2 nvarchar(250),
  序号2 int,
  类型2 nvarchar(250),
  长度2 int,
  小数位数2 int
);
--得到数据库1的结构 
exec('insert into #tb1 SELECT 
表名=d.name,字段名=a.name,序号=a.colid,类型=b.name,长度=a.prec,小数位数=a.scale
FROM '+@dbname1+'..syscolumns a
left join '+@dbname1+'..systypes b on a.xtype=b.xusertype 
inner join '+@dbname1+'..sysobjects d on a.id=d.id  and d.xtype=''U'' and  d.name <>''dtproperties'' 
order by a.id,a.colorder');
--得到数据库2的结构 
exec('insert into #tb2 SELECT 
表名=d.name,字段名=a.name,序号=a.colid,类型=b.name,长度=a.prec,小数位数=a.scale
FROM '+@dbname2+'..syscolumns a
left join '+@dbname2+'..systypes b on a.xtype=b.xusertype 
inner join '+@dbname2+'..sysobjects d on a.id=d.id  and d.xtype=''U'' and  d.name <>''dtproperties'' 
order by a.id,a.colorder');
select   比较结果=case
                when a.表名1 is null
                  and not exists (select 1 from #tb1 where 表名1=b.表名2) then '库1缺少表：'+b.表名2
                when b.表名2 is null
                  and not exists (select 1 from #tb2 where 表名2=a.表名1) then '库2缺少表:'+a.表名1
                when a.字段名1 is null
                  and exists (select 1 from #tb1 where 表名1=b.表名2) then '库1 ['+b.表名2+'] 缺少字段：'+b.字段名2
                when b.字段名2 is null
                  and exists (select 1 from #tb2 where 表名2=a.表名1) then '库2 ['+a.表名1+'] 缺少字段：'+a.字段名1
                when a.类型1<>b.类型2 then '字段类型不同'
                when a.长度1<>b.长度2 then '长度不同'
                when a.小数位数1<>b.小数位数2 then '小数位数不同'
                else ''
              end, 结果类型=case
                          when a.表名1 is null
                            and not exists (select 1 from #tb1 where 表名1=b.表名2) then 'table'
                          when b.表名2 is null
                            and not exists (select 1 from #tb2 where 表名2=a.表名1) then 'table'
                          when a.字段名1 is null
                            and exists (select 1 from #tb1 where 表名1=b.表名2) then 'fieldname'
                          when b.字段名2 is null
                            and exists (select 1 from #tb2 where 表名2=a.表名1) then 'fieldname'
                          when a.类型1<>b.类型2 then 'fieldtype'
                          when a.长度1<>b.长度2 then 'fieldlength'
                          when a.小数位数1<>b.小数位数2 then 'fieldprecision'
                          else ''
                        end, *
from     #tb1 as a
full join #tb2 as b on a.表名1=b.表名2
                      and a.字段名1=b.字段名2
where    a.表名1 is null
  or a.字段名1 is null
  or b.表名2 is null
  or b.字段名2 is null
  or a.类型1<>b.类型2
  or a.长度1<>b.长度2
  or a.小数位数1<>b.小数位数2
order by isnull(a.表名1, b.表名2), isnull(a.序号1, b.序号2); --ISNULL(a.字段名1,b.字段名2

--EXEC EAP_SP_CompareStructure 'test1','test2'

go


