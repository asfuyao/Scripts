@echo off

set eth="Wi-Fi"
set ip=192.168.0.1
set netmask=255.255.255.0
set gw=192.168.0.254
set dns1=202.96.64.68
set dns2=202.96.69.38
echo.
echo �����л� %eth% �� %ip%
echo.

echo ��������IP��ַ %ip%
netsh interface ip set address %eth% static %ip% %netmask% %gw% 1
echo ����������ѡDNS������ %dns1%
netsh interface ip set dns %eth% static %dns1% primary no
echo �������ñ���DNS������ %dns2%
netsh interface ip add dns %eth% %dns2% index=2 no

netsh interface ipv4 show config %eth%
set choice=
set /p choice=IP��ַ�л���ϣ���������˳�
echo.

