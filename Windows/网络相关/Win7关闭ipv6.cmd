@echo off
rem �ر�IPV6���������
netsh interface teredo set state disable
netsh interface 6to4 set state disable
netsh interface isatap set state disable