#!/bin/sh

# stop firewall
systemctl disable  firewalld
systemctl stop firewalld

# install iptables
yum install -y iptables-services
systemctl start iptables.service

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