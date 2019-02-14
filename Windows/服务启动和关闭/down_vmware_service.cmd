@echo off
net stop VMAuthdService
net stop VMnetDHCP
net stop "VMware NAT Service"
net stop VMUSBArbService
rem net stop VMwareHostd

set /p choice=服务已停止，按任意键继续