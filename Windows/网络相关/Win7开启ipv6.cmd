@echo off
rem ¿ªÆôIPV6ËíµÀÊÊÅäÆ÷
netsh interface teredo set state default
netsh interface 6to4 set state default
netsh interface isatap set state default