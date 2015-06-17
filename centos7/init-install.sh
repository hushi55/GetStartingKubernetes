#!/bin/sh

# stop firewall
systemctl stop firewalld.service
systemctl disable firewalld.service

# install netstat
yum install -y net-tools
yum install -y telnet
yum install -y git
yum install -y wget
yum install -y strace