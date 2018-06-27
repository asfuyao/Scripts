# SQLServer服务器修改排序规则的方法

------
### 1、在查询分析器中,获取服务器排序规则
```sql
SELECT SERVERPROPERTY('Collation')
```
### 2、在查询分析器中,查看当前服务器数据库安装版本
```sql
SELECT @@VERSION
```
### 3、请确认当前数据库默认安装版本及默认安装文件目录,请根据自己版本记录数据库默认安装目录。
(SQLServer Service) 默认安装目录：
```text
SQL Server 2008 C:\Program Files\Microsoft SQL Server\100\Setup Bootstrap\Release
SQL Server 2012 C:\Program Files\Microsoft SQL Server\110\Setup Bootstrap\SQLServer2012
SQL Server 2014 C:\Program Files\Microsoft SQL Server\120\Setup Bootstrap\SQLServer2014
SQL Server 2016 C:\Program Files\Microsoft SQL Server\140\Setup Bootstrap\SQLServer2016
```
### 4、使用管理员权限打开命令行窗口，并进入默认安装目录

### 5、停止SQLServer服务，在命令行窗口输入
```text
net stop mssqlserver
```
### 6、运行语句修改数据库排序规则
```text
Setup /QUIET /ACTION=REBUILDDATABASE /instancename=MSSQLSERVER /SQLSYSADMINACCOUNTS=操作系统管理员账号 /sapwd=密码 /sqlcollation=Latin1_General_CI_AS
```
**格式说明:**
```text
Setup /QUIET 
      /ACTION=REBUILDDATABASE 
      /INSTANCENAME=InstanceName
      /SQLSYSADMINACCOUNTS=accounts 
      / [ SAPWD= StrongPassword ]
      /SQLCOLLATION=CollationName
```      
**注意:** accounts 用户使用电脑管理员用户，CollationName 为需要变更的排序格式

### 7、启动SQLServer服务，在命令行窗口输入
```text
net start mssqlserver
```
