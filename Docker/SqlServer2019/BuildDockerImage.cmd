@echo off

docker build -f "Dockerfile" --force-rm -t mssql2019 --cache-from mssql2019:latest .

pause