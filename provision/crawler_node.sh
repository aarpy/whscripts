#!/bin/bash

# Run as root
# http://askubuntu.com/questions/15853/how-can-a-script-check-if-its-being-run-as-root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# keep it quite
export DEBIAN_FRONTEND=noninteractive

# Update and upgrade
apt-get update -q -y
apt-get upgrade -q -y

#Install Node.js
# https://nodesource.com/blog/nodejs-v012-iojs-and-the-nodesource-linux-repositories
curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
apt-get install nodejs build-essential libssl-dev

# Install go
# http://munchpress.com/install-golang-1-5-on-ubuntu/
wget https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.5.1.linux-amd64.tar.gz

# Go write profile
echo "export GOROOT=/usr/local/go" >> /etc/environment
echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/environment

# --- add git scripts ----
# Deploy keys:
# https://developer.github.com/guides/managing-deploy-keys/#deploy-keys
# https://help.github.com/articles/generating-ssh-keys/
# Add to: https://github.com/aarpy/wisehoot/settings/keys
cd /usr/local/
git clone git@github.com:aarpy/wisehoot.git
