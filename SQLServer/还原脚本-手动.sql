USE [master]
GO
ALTER DATABASE [SITMesDB] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

use [master]
restore database [SITMesDB] from  disk = N'D:\temp\SITMesDB20180628.bak' with  file = 1,  
move N'SITMesDB_Data'                 to N'D:\Database\SITMesDB.MDF',  
move N'SITMesDB_Engineering_Data'     to N'D:\Database\SITMesDB_0.NDF',  
move N'SITMesDB_Engineering_Indexes'  to N'D:\Database\SITMesDB_1.NDF',  
move N'SITMesDB_Runtime_Data'         to N'D:\Database\SITMesDB_2.NDF',  
move N'SITMesDB_Runtime_Indexes'      to N'D:\Database\SITMesDB_3.NDF',  
move N'SITMesDB_Historical_Data'      to N'D:\Database\SITMesDB_4.NDF',  
move N'SITMesDB_Historical_Indexes'   to N'D:\Database\SITMesDB_5.NDF',  
move N'SITMesDB_CustomObject_Data'    to N'D:\Database\SITMesDB_6.NDF',  
move N'SITMesDB_CustomObject_Indexes' to N'D:\Database\SITMesDB_7.NDF',  
move N'SITMesDB_Alt_DataO'            to N'D:\Database\SITMesDB_8.NDF',  
move N'SITMesDB_Alt_IndexO'           to N'D:\Database\SITMesDB_9.NDF',  
move N'SITMesDB_Alt_DataC'            to N'D:\Database\SITMesDB_10.NDF',  
move N'SITMesDB_Alt_IndexC'           to N'D:\Database\SITMesDB_11.NDF',  
move N'SITMesDB_Services_Data'        to N'D:\Database\SITMesDB_12.NDF',  
move N'SITMesDB_Services_Indexes'     to N'D:\Database\SITMesDB_13.NDF',  
move N'SITMesDB_Log' to N'D:\Database\SITMesDB_14.LDF',  
nounload,  replace,  stats = 5

go


USE [master]
GO
ALTER DATABASE [SITMesDB] SET  multi_user WITH ROLLBACK IMMEDIATE
GO