@echo off

docker build -f "Dockerfile" --force-rm -t sqlstudio --cache-from sqlstudio:latest .

pause