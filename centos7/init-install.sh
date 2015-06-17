#!/bin/sh

# stop firewall
systemctl stop firewalld.service
systemctl disable firewalld.service

# install netstat
yum install -y bridge-utils
yum install -y net-tools
yum install -y telnet
yum install -y tcpdump
yum install -y git
yum install -y wget
yum install -y strace
yum install -y vim 
yum install -y zip unzip