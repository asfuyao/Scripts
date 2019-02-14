@echo off

set eth="本地连接"
echo.
echo 正在切换 %eth% 到DHCP网络环境
echo.
echo 正在设置IP地址为自动获得
netsh interface ip set address %eth% source=dhcp
echo 设置首选DNS服务器为自动获得
netsh interface ip set dns %eth% source=dhcp
echo   正在自动获取IP，请稍侯...
echo.
ipconfig /renew %eth% > nul
netsh interface ipv4 show config %eth%
set choice=
set /p choice=IP地址切换完毕，按任意键退出
echo.