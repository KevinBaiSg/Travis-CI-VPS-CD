#!/usr/bin/env bash

cd ~/travis-ci-vps-cd
goreman run stop travis-ci-vps-cd
rm -rf ./travis-ci-vps-cd
mv travis-ci-vps-cd-new travis-ci-vps-cd
nohup goreman start &
exit
