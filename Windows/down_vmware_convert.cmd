@echo off
net stop "vmware-converter-agent"
net stop "vmware-converter-server"
net stop "vmware-converter-worker"

set /p choice=服务已停止，按任意键继续