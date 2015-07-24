#!/bin/sh

## centos7 base image
cd centos7
sh image.sh 

## java7 base image
cd ../java7
sh image.sh 

## java8 base image
cd ../java8
sh image.sh 

## jetty base image
cd ../jetty
sh image.sh 

## play base image
cd ../play
sh image.sh 











