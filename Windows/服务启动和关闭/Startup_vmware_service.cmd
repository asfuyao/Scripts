@echo off
net start VMAuthdService
net start VMnetDHCP
net start "VMware NAT Service"
net start VMUSBArbService
rem net start VMwareHostd
set /p choice=����������ϣ������������