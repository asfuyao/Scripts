@echo off

set eth="��������"
echo.
echo �����л� %eth% ��DHCP���绷��
echo.
echo ��������IP��ַΪ�Զ����
netsh interface ip set address %eth% source=dhcp
echo ������ѡDNS������Ϊ�Զ����
netsh interface ip set dns %eth% source=dhcp
echo   �����Զ���ȡIP�����Ժ�...
echo.
ipconfig /renew %eth% > nul
netsh interface ipv4 show config %eth%
set choice=
set /p choice=IP��ַ�л���ϣ���������˳�
echo.