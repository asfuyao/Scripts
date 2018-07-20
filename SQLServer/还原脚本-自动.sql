--还原脚本，只适合普通数据库还原，如数据库由多个文件组成此脚本不适用
use master
go

declare @databasename nvarchar(255)
declare @dataname nvarchar(255)
declare @logname nvarchar(255)
declare @datafile nvarchar(2000)
declare @logfile nvarchar(2000)
declare @backupfile nvarchar(2000)
declare @sql nvarchar(4000)


set @databasename=N'SITMesDB'
set @backupfile=N'D:\temp\SITMesDB20180628.bak'

--**************************************************************************************************--
set @sql=N'select @dname=name, @dfile=filename from '+@databasename+'..sysfiles where fileid=1;'
exec sys.sp_executesql
  @sql,
  N'@dname as nvarchar(2000) output,@dfile as nvarchar(2000) output',
  @dname=@dataname output,
  @dfile=@datafile output

set @sql=N'select @lname=name, @lfile=filename from '+@databasename+'..sysfiles where fileid=2;'
exec sys.sp_executesql
  @sql,
  N'@lname as nvarchar(2000) output,@lfile as nvarchar(2000) output',
  @lname=@logname output,
  @lfile=@logfile output  

set @sql=N'alter database '+@databasename+ ' set single_user with rollback immediate'
exec sys.sp_executesql @sql

restore database @databasename
  from disk=@backupfile with file=1, 
  move @dataname to @datafile, 
  move @logname  to @logfile, 
  nounload, replace, stats=10

set @sql=N'alter database '+@databasename+ ' set multi_user with rollback immediate'
exec sys.sp_executesql @sql
--**************************************************************************************************--