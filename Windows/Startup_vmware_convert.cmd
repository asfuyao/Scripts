@echo off
net start "vmware-converter-agent"
net start "vmware-converter-server"
net start "vmware-converter-worker"

set /p choice=服务启动完毕，按任意键继续