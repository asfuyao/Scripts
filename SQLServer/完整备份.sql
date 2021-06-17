declare @BackupPath nvarchar(255);
declare @BackupDatabases table
(
  DataBaseName varchar(255)
);
declare @DataBaseName varchar(100);
declare @STime varchar(20);
declare @SQLCMD nvarchar(1000);

set @STime=replace(replace(replace(convert(varchar(20), getdate(), 20), '-', ''), ' ', ''), ':', '');

--在此处填写备份路径
set @BackupPath=N'D:\databak\test\';

--在此处填写要备份的数据名称，不能包含[]符号
insert into @BackupDatabases(DataBaseName)
values('LibraryDb'), ('LiShenEamDb');

--
declare TableName_Cursor cursor for
select DataBaseName from @BackupDatabases;
open TableName_Cursor;
fetch next from TableName_Cursor
into @DataBaseName;
while @@fetch_status=0
begin
  select @SQLCMD='backup database '+@DataBaseName+' to disk='''+@BackupPath+@DataBaseName+@STime
                 +'.bak'' with noformat, init, name='''+@DataBaseName
                 +'-Full Backup'', skip, norewind, nounload, compression';
  exec(@SQLCMD);
  fetch next from TableName_Cursor
  into @DataBaseName;
end;
close TableName_Cursor;
deallocate TableName_Cursor;



