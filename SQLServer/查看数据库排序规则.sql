--�鿴�������������(��װʱָ�����������)
SELECT SERVERPROPERTY('COLLATION') AS ServerCollation
,DATABASEPROPERTYEX('tempdb','COLLATION') AS TempdbCollation
,DATABASEPROPERTYEX(DB_NAME(),'COLLATION') AS CurrentDBCollation
 
--�鿴���ݿ��������
SELECT name, collation_name FROM sys.databases
 
--��ǰ���ݿ��Ƿ��Сд����
SELECT CASE WHEN N'A'=N'a' THEN N'������' ELSE N'����' END

