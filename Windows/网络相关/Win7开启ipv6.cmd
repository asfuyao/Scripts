@echo off
rem ����IPV6���������
netsh interface teredo set state default
netsh interface 6to4 set state default
netsh interface isatap set state default