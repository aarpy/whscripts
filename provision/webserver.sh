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

# Install core packages
apt-get install make ntp git nginx

# --- www server ----

# Install for web server
apt-get install ruby-full ruby-dev

# Install Jekyll
# http://stackoverflow.com/questions/13767725/unable-to-install-gem-failed-to-build-gem-native-extension-cannot-load-such
gem update
gem install jekyll

#Install Node.js
# https://nodesource.com/blog/nodejs-v012-iojs-and-the-nodesource-linux-repositories
curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
apt-get install nodejs build-essential libssl-dev

# --- web api server ----

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

# --- build public web site ---
cd /usr/local/wisehoot/www/
jekyll build


# nginix setup
# https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-server-blocks-virtual-hosts-on-ubuntu-14-04-lts
cd /etc/nginx/sites-enabled/
ln -s sites-available/www.wisehoot.com www.wisehoot.com
rm sites-enabled/default

# Increase server_names_hash_bucket_size to 128
# http://www.comtechies.com/2014/03/How-to-install-and-configure-nginx-on-amazon-ec2.html
# vi /etc/nginx/nginx.conf
# add line 23: "server_names_hash_bucket_size 128;"

# restart nginx
sudo service nginx restart

# DNS configuraiton validation
# https://www.namecheap.com/support/knowledgebase/article.aspx/579
