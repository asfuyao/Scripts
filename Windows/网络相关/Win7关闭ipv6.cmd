@echo off
rem ¹Ø±ÕIPV6ËíµÀÊÊÅäÆ÷
netsh interface teredo set state disable
netsh interface 6to4 set state disable
netsh interface isatap set state disable