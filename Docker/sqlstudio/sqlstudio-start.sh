#!/bin/bash

SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
APP_JAR=$(cd $SHELL_FOLDER/main_application;ls Maicong-SQLynx-*.jar)
LOG_PATH=$SHELL_FOLDER/log

JAVA_OPTS="
-server
-Xms256m
-Xmx4g
-XX:+UseG1GC
-XX:+UseStringDeduplication
-XX:+AlwaysPreTouch
-XX:+PrintGCDetails
-XX:+PrintGCTimeStamps
-XX:+PrintGCCause
-Xloggc:$LOG_PATH/maicong-sqlstudio-gc.log
-XX:+HeapDumpOnOutOfMemoryError
-XX:HeapDumpPath=$LOG_PATH/maicong-sqlstudio-heapdump
-Dfile.encoding=utf-8"

java $JAVA_OPTS -jar $SHELL_FOLDER/main_application/$APP_JAR --spring.config.location=config/maicong.yaml
