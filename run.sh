#!/usr/bin/env bash

cd ~/travis-ci-vps-cd
goreman run stop travis-cd
rm -rf ./travis-cd
mv travis-cd-new travis-cd
nohup goreman start &
exit
