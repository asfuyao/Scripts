create proc dbo.EAP_SP_CompareStructure
  @dbname1 varchar(250), --Ҫ�Ƚϵ����ݿ���1 
  @dbname2 varchar(250)  --Ҫ�Ƚϵ����ݿ���2 
as
create table #tb1
(
  ����1 nvarchar(250),
  �ֶ���1 nvarchar(250),
  ���1 int,
  ����1 nvarchar(250),
  ����1 int,
  С��λ��1 int
);
create table #tb2
(
  ����2 nvarchar(250),
  �ֶ���2 nvarchar(250),
  ���2 int,
  ����2 nvarchar(250),
  ����2 int,
  С��λ��2 int
);
--�õ����ݿ�1�Ľṹ 
exec('insert into #tb1 SELECT 
����=d.name,�ֶ���=a.name,���=a.colid,����=b.name,����=a.prec,С��λ��=a.scale
FROM '+@dbname1+'..syscolumns a
left join '+@dbname1+'..systypes b on a.xtype=b.xusertype 
inner join '+@dbname1+'..sysobjects d on a.id=d.id  and d.xtype=''U'' and  d.name <>''dtproperties'' 
order by a.id,a.colorder');
--�õ����ݿ�2�Ľṹ 
exec('insert into #tb2 SELECT 
����=d.name,�ֶ���=a.name,���=a.colid,����=b.name,����=a.prec,С��λ��=a.scale
FROM '+@dbname2+'..syscolumns a
left join '+@dbname2+'..systypes b on a.xtype=b.xusertype 
inner join '+@dbname2+'..sysobjects d on a.id=d.id  and d.xtype=''U'' and  d.name <>''dtproperties'' 
order by a.id,a.colorder');
select   �ȽϽ��=case
                when a.����1 is null
                  and not exists (select 1 from #tb1 where ����1=b.����2) then '��1ȱ�ٱ�'+b.����2
                when b.����2 is null
                  and not exists (select 1 from #tb2 where ����2=a.����1) then '��2ȱ�ٱ�:'+a.����1
                when a.�ֶ���1 is null
                  and exists (select 1 from #tb1 where ����1=b.����2) then '��1 ['+b.����2+'] ȱ���ֶΣ�'+b.�ֶ���2
                when b.�ֶ���2 is null
                  and exists (select 1 from #tb2 where ����2=a.����1) then '��2 ['+a.����1+'] ȱ���ֶΣ�'+a.�ֶ���1
                when a.����1<>b.����2 then '�ֶ����Ͳ�ͬ'
                when a.����1<>b.����2 then '���Ȳ�ͬ'
                when a.С��λ��1<>b.С��λ��2 then 'С��λ����ͬ'
                else ''
              end, �������=case
                          when a.����1 is null
                            and not exists (select 1 from #tb1 where ����1=b.����2) then 'table'
                          when b.����2 is null
                            and not exists (select 1 from #tb2 where ����2=a.����1) then 'table'
                          when a.�ֶ���1 is null
                            and exists (select 1 from #tb1 where ����1=b.����2) then 'fieldname'
                          when b.�ֶ���2 is null
                            and exists (select 1 from #tb2 where ����2=a.����1) then 'fieldname'
                          when a.����1<>b.����2 then 'fieldtype'
                          when a.����1<>b.����2 then 'fieldlength'
                          when a.С��λ��1<>b.С��λ��2 then 'fieldprecision'
                          else ''
                        end, *
from     #tb1 as a
full join #tb2 as b on a.����1=b.����2
                      and a.�ֶ���1=b.�ֶ���2
where    a.����1 is null
  or a.�ֶ���1 is null
  or b.����2 is null
  or b.�ֶ���2 is null
  or a.����1<>b.����2
  or a.����1<>b.����2
  or a.С��λ��1<>b.С��λ��2
order by isnull(a.����1, b.����2), isnull(a.���1, b.���2); --ISNULL(a.�ֶ���1,b.�ֶ���2

--EXEC EAP_SP_CompareStructure 'test1','test2'

go


