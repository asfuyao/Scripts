#!/bin/bash

webroot=/usr/share/nginx/html
srcdir=/root/gitbook

initdir=$(dirname $(readlink -f "$0"))

echo Into work dir. $srcdir
cd $srcdir/

echo pull new code
git pull

echo build gitbook
gitbook build

echo clean webroot..
rm -rf $webroot/*

echo copy new files...
cp -r $srcdir/_book/* $webroot/

cd $initdir
~
