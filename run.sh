#!/usr/bin/env bash

cd ~/travis-ci-vps-cd
goreman -p 3001 run stop travis-cd
rm -rf ./travis-cd
mv travis-cd-new travis-cd
nohup goreman -p 3001 -b 4001 start &
exit
