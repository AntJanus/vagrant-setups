#!/bin/bash -e

sudo yum -y update
sudo yum -y groupinstall "Development Tools"
sudo yum install openssl-devel
(
    cd /usr/src
    wget http://nodejs.org/dist/v0.10.4/node-v0.10.4.tar.gz
    tar zxf node-v0.10.4.tar.gz
    cd node-v0.10.4
    ./configure
    make
    make install
)
(
    cd /vagrant
    npm install
)
