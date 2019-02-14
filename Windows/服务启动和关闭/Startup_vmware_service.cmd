@echo off
net start VMAuthdService
net start VMnetDHCP
net start "VMware NAT Service"
net start VMUSBArbService
rem net start VMwareHostd
set /p choice=服务启动完毕，按任意键继续