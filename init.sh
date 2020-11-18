#!/bin/bash
set -eu
apt-get update -y

# Install Elasticsearch
# ref: https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html#deb-repo
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
apt-get -y install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
apt-get -y update && apt-get -y install elasticsearch

sudo /lib/systemd/systemd-sysv-install enable elasticsearch
sudo systemctl start elasticsearch.service

# Install moloch
apt -y --fix-broken install
apt-get install -y libwww-perl \
                   libjson-perl \
                   libyaml-dev
curl -s https://s3.amazonaws.com/files.molo.ch/builds/ubuntu-20.04/moloch_2.4.2-1_amd64.deb -o moloch.deb
sudo dpkg -i moloch.deb
sed '/^MOLOCH_LOCALELASTICSEARCH=set-no/d' /data/moloch/bin/Configure
sed '/^MOLOCH_INET=set-no/d' /data/moloch/bin/Configure
export MOLOCH_INTERFACE="enp0s3"
export MOLOCH_LOCALELASTICSEARCH="no"
export MOLOCH_PASSWORD="chaspy123"
export MOLOCH_ELASTICSEARCH="http://localhost:9200"
export MOLOCH_INET="yes"

sudo -E /data/moloch/bin/Configure # Not idempotent

sudo /data/moloch/db/db.pl http://localhost:9200 init # Not idempotent
sudo /data/moloch/bin/moloch_add_user.sh admin "Admin User" THEPASSWORD --admin

sudo systemctl start molochcapture.service
sudo systemctl start molochviewer.service
