#!/bin/bash

#####
# Redis Installation steps:
#   https://www.linode.com/docs/databases/redis/redis-on-ubuntu-12-04-precise-pangolin
####

# Run as root
# http://askubuntu.com/questions/15853/how-can-a-script-check-if-its-being-run-as-root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# get system upto date
apt-get update
apt-get upgrade

# install redis
apt-get install redis-server

# Save redis config
cp /etc/redis/redis.conf /etc/redis/redis.conf.default

# Allow everyone to access the Redis server
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf

# Restart Redis server
service redis-server restart
