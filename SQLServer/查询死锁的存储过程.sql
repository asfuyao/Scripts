use master;
go
if exists ( select *
            from   dbo.sysobjects
            where  id=object_id(N'[dbo].[sp_who_lock]')
              and objectproperty(id, N'IsProcedure')=1
          )
  drop procedure dbo.sp_who_lock;
go

create procedure sp_who_lock
as
begin
  declare @spid int, @bl int, @intTransactionCountOnEntry int, @intRowcount int, @intCountProperties int,
          @intCounter int;

  create table #tmp_lock_who
  (
    id int identity(1, 1),
    spid smallint,
    bl smallint
  );

  if @@error<>0
    return @@error;

  insert into #tmp_lock_who(spid, bl)
  select 0, blocked
  from   ( select *
           from   sysprocesses
           where  blocked>0
         ) as a
  where  not exists ( select *
                      from   ( select *
                               from   sysprocesses
                               where  blocked>0
                             ) as b
                      where  a.blocked=spid
                    )
  union
  select spid, blocked from sysprocesses where blocked>0;

  if @@error<>0
    return @@error;

  -- �ҵ���ʱ��ļ�¼�� 
  select @intCountProperties=count(*), @intCounter=1 from #tmp_lock_who;

  if @@error<>0
    return @@error;

  if @intCountProperties=0
    select '����û��������������Ϣ' as message;

  -- ѭ����ʼ 
  while @intCounter<=@intCountProperties
  begin
    -- ȡ��һ����¼ 
    select @spid=spid, @bl=bl from #tmp_lock_who where id=@intCounter;
    begin
      if @spid=0
        select '�������ݿ���������: '+cast(@bl as varchar(10))+'���̺�,��ִ�е�SQL�﷨����';
      else
        select '���̺�SPID��'+cast(@spid as varchar(10))+'��'+'���̺�SPID��'+cast(@bl as varchar(10))+'����,�䵱ǰ����ִ�е�SQL�﷨����';
      dbcc inputbuffer(@bl);
    end;

    -- ѭ��ָ������ 
    set @intCounter=@intCounter+1;
  end;

  drop table #tmp_lock_who;

  return 0;
end;


