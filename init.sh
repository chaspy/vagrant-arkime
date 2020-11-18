#!/bin/bash
set -eu
apt-get update -y
apt -y --fix-broken install
apt-get install -y libwww-perl \
                   libjson-perl \
                   libyaml-dev
curl -s https://s3.amazonaws.com/files.molo.ch/builds/ubuntu-20.04/moloch_2.4.2-1_amd64.deb -o moloch.deb
sudo dpkg -i moloch.deb
