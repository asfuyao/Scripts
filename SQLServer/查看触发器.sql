-- �鿴���ݿ����д�����
use BBACPLSCDB
go
select * from sysobjects where xtype='TR'

-- �鿴����������
exec sp_helptext 'TRIGER_PartsPic'

exec sp_helptext 'TRIGER_PQD'
