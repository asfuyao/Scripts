# SQLServer�������޸��������ķ���

------
### 1���ڲ�ѯ��������,��ȡ�������������
```sql
SELECT SERVERPROPERTY('Collation')
```
### 2���ڲ�ѯ��������,�鿴��ǰ���������ݿⰲװ�汾
```sql
SELECT @@VERSION
```
### 3����ȷ�ϵ�ǰ���ݿ�Ĭ�ϰ�װ�汾��Ĭ�ϰ�װ�ļ�Ŀ¼,������Լ��汾��¼���ݿ�Ĭ�ϰ�װĿ¼��
(SQLServer Service) Ĭ�ϰ�װĿ¼��
```text
SQL Server 2008 C:\Program Files\Microsoft SQL Server\100\Setup Bootstrap\Release
SQL Server 2012 C:\Program Files\Microsoft SQL Server\110\Setup Bootstrap\SQLServer2012
SQL Server 2014 C:\Program Files\Microsoft SQL Server\120\Setup Bootstrap\SQLServer2014
SQL Server 2016 C:\Program Files\Microsoft SQL Server\140\Setup Bootstrap\SQLServer2016
```
### 4��ʹ�ù���ԱȨ�޴������д��ڣ�������Ĭ�ϰ�װĿ¼

### 5��ֹͣSQLServer�����������д�������
```text
net stop mssqlserver
```
### 6����������޸����ݿ��������
```text
Setup /QUIET /ACTION=REBUILDDATABASE /instancename=MSSQLSERVER /SQLSYSADMINACCOUNTS=����ϵͳ����Ա�˺� /sapwd=���� /sqlcollation=Latin1_General_CI_AS
```
**��ʽ˵��:**
```text
Setup /QUIET 
      /ACTION=REBUILDDATABASE 
      /INSTANCENAME=InstanceName
      /SQLSYSADMINACCOUNTS=accounts 
      / [ SAPWD= StrongPassword ]
      /SQLCOLLATION=CollationName
```      
**ע��:** accounts �û�ʹ�õ��Թ���Ա�û���CollationName Ϊ��Ҫ����������ʽ

### 7������SQLServer�����������д�������
```text
net start mssqlserver
```
