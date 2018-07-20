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

  -- 找到临时表的记录数 
  select @intCountProperties=count(*), @intCounter=1 from #tmp_lock_who;

  if @@error<>0
    return @@error;

  if @intCountProperties=0
    select '现在没有阻塞和死锁信息' as message;

  -- 循环开始 
  while @intCounter<=@intCountProperties
  begin
    -- 取第一条记录 
    select @spid=spid, @bl=bl from #tmp_lock_who where id=@intCounter;
    begin
      if @spid=0
        select '引起数据库死锁的是: '+cast(@bl as varchar(10))+'进程号,其执行的SQL语法如下';
      else
        select '进程号SPID：'+cast(@spid as varchar(10))+'被'+'进程号SPID：'+cast(@bl as varchar(10))+'阻塞,其当前进程执行的SQL语法如下';
      dbcc inputbuffer(@bl);
    end;

    -- 循环指针下移 
    set @intCounter=@intCounter+1;
  end;

  drop table #tmp_lock_who;

  return 0;
end;


