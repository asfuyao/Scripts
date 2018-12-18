-- 查看数据库已有触发器
use BBACPLSCDB
go
select * from sysobjects where xtype='TR'

-- 查看单个触发器
exec sp_helptext 'TRIGER_PartsPic'

exec sp_helptext 'TRIGER_PQD'
