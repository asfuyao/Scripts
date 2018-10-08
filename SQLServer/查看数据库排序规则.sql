--查看服务器排序规则(安装时指定的排序规则)
SELECT SERVERPROPERTY('COLLATION') AS ServerCollation
,DATABASEPROPERTYEX('tempdb','COLLATION') AS TempdbCollation
,DATABASEPROPERTYEX(DB_NAME(),'COLLATION') AS CurrentDBCollation
 
--查看数据库排序规则
SELECT name, collation_name FROM sys.databases
 
--当前数据库是否大小写敏感
SELECT CASE WHEN N'A'=N'a' THEN N'不敏感' ELSE N'敏感' END

