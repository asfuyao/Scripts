rem Install the certificate (assuming it's on the root of C drive)
slmgr.vbs /ilc C:\DELL.XRM-MS
rem 如出现错误提示，如：在运行microsoft windows 非核心版本上,运行slui.exe 0x2a 0xBBA以显示错误文本
rem 先运行slmgr.vbs -rearm（用来删除计算机原有授权许可，以便重置）需要重启
rem 后面改为用 slmgr.vbs -rilc 命令导入 (重新安装系统许可文件)，就可以了
rem slmgr.vbs /rilc C:\DELL.XRM-MS

rem Install the key

rem Windows 7 Professional
slmgr.vbs /ipk 32KD2-K9CTF-M3DJT-4J3WC-733WD
rem Windows 7 Ultimate
slmgr.vbs /ipk 342DG-6YJR8-X92GV-V7DCV-P4K27

rem Server 2008 R2 Standard
slmgr.vbs /ipk D7TCH-6P8JP-KRG4P-VJKYY-P9GFF
rem Server 2008 R2 Enterprise
slmgr.vbs /ipk BKCJJ-J6G9Y-4P7YF-8D4J7-7TCWD
rem Server 2008 R2 Datacenter
slmgr.vbs /ipk 26FXG-KYC7Q-XG29P-T2HFQ-KPF96


rem Windows Server 2012 R2 Datacenter
slmgr.vbs /ipk 2N9T6-Y284D-T68G9-QGV6X-FRFTD
rem Windows Server 2012 R2 Standard
slmgr.vbs /ipk 2FND4-FCR66-RK9Q3-F82H3-4GB43
rem Windows Storage Server 2012 R2 Standard
slmgr.vbs /ipk 2DND8-VMDWJ-9KTH7-2RK24-WFFV3

rem Windows Server 2016 Standard
slmgr.vbs /ipk 2499N-BCGX3-FHJKF-DH9QR-8B63W
rem Windows Server 2016 Storage Server Standard
slmgr.vbs /ipk 26K68-7NBHG-XQGQG-KYYCJ-QDCGG

rem Activate Windows
slmgr.vbs /ato
rem Check activation status
slmgr.vbs /dli