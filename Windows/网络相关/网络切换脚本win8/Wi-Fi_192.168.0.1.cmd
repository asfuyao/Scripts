@echo off

set eth="Wi-Fi"
set ip=192.168.0.1
set netmask=255.255.255.0
set gw=192.168.0.254
set dns1=202.96.64.68
set dns2=202.96.69.38
echo.
echo 正在切换 %eth% 到 %ip%
echo.

echo 正在设置IP地址 %ip%
netsh interface ip set address %eth% static %ip% %netmask% %gw% 1
echo 正在设置首选DNS服务器 %dns1%
netsh interface ip set dns %eth% static %dns1% primary no
echo 正在设置备用DNS服务器 %dns2%
netsh interface ip add dns %eth% %dns2% index=2 no

netsh interface ipv4 show config %eth%
set choice=
set /p choice=IP地址切换完毕，按任意键退出
echo.

